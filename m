Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3670154C04;
	Mon,  6 Jan 2025 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179207; cv=none; b=S3XQ8XvFFuzK7/AMciKK12XAUmQCe6BO2Tfur3lJCTQjOkHvNJW0gGe5O5Us3zgOJ/HRVbmlK2Slo1cuq/wM/bDumg3iDLULYKSLw2tU1QgrPePGBzR3njNGZnn/RI5WjZJVAHbJAbmFZ3v7wCj0dLCrgae6jEhCTfkNuY7kDh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179207; c=relaxed/simple;
	bh=7gvxFrwAM4nXJLc1PDia6k7drFH0ihNzc50rZ+O4sGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AxPkZuIFV4ZChVgPt5dO18z2fbZQBtOl3T1G/J6tAk3l/hQdFFy/viKeb22qXj7ksdIjlDlUOBZrUgOPpxG3wrrs4MPaKDqi3ECjPkNQzkY8fxjm7M0DpL8LWFCAp2GLgKOXbj1WVmM1m199dxggaUZW7fiVmLvnwcO4F38PhfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpphoSy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpphoSy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D85CC4CED2;
	Mon,  6 Jan 2025 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179206;
	bh=7gvxFrwAM4nXJLc1PDia6k7drFH0ihNzc50rZ+O4sGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpphoSy4DHOovlwKzjj2EasIiZynlpWEO6G9Q1kCIP+kH/JzcjAuYLZWElefQiG6V
	 37c+t6wqJzayJKYrlHfLv2TKPciCXqkY2EOjjsTPGSGl53ehuxrH39e8XdU7uq02qv
	 hNlMH0kgeOq3d/RoquiBax7Xb03D/UdibBO7ftIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 62/93] selinux: ignore unknown extended permissions
Date: Mon,  6 Jan 2025 16:17:38 +0100
Message-ID: <20250106151131.046259770@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiébaud Weksteen <tweek@google.com>

commit 900f83cf376bdaf798b6f5dcb2eae0c822e908b6 upstream.

When evaluating extended permissions, ignore unknown permissions instead
of calling BUG(). This commit ensures that future permissions can be
added without interfering with older kernels.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -954,7 +954,10 @@ void services_compute_xperms_decision(st
 					xpermd->driver))
 			return;
 	} else {
-		BUG();
+		pr_warn_once(
+			"SELinux: unknown extended permission (%u) will be ignored\n",
+			node->datum.u.xperms->specified);
+		return;
 	}
 
 	if (node->key.specified == AVTAB_XPERMS_ALLOWED) {
@@ -991,7 +994,8 @@ void services_compute_xperms_decision(st
 					node->datum.u.xperms->perms.p[i];
 		}
 	} else {
-		BUG();
+		pr_warn_once("SELinux: unknown specified key (%u)\n",
+			     node->key.specified);
 	}
 }
 


