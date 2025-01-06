Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB351DE4D2;
	Mon,  6 Jan 2025 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178343; cv=none; b=OI2kTg9/m0yzS5Eki3jlC/jp89LxckqAwhKTmlUD8sRjgF/gNLC0f8DRXpZtWRiBypQmbTr89eKHgheRwmHuJ3Z7d1QBULNHiEumocV0K4WX1Mo2NFU/MSEPpdFdjkjS7G5tGLUF41wYTCDNZ0PtzZ51GLG0R30MKiSVHexB6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178343; c=relaxed/simple;
	bh=ESPycb9pUBLp8UIzFVsuM/Uyf4F3K6AVxrrEZX0EcbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNaKvgzt6uq+bVOT3jJbLYSJ4gbx9jIcJ8VNqxlmt3cjVf0JtbVqwcouRJfHNnHMAsU77WqoYaLueNdJn5ERmPwf6uvXz8az5kczrlFANF8OvYRCFlIdnkP82vq41XOzaEN2A8oRGj4gmE7hEMUFvG9hKa669DEakIx4YRV4XaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuQBTI4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuQBTI4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51826C4CED2;
	Mon,  6 Jan 2025 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178343;
	bh=ESPycb9pUBLp8UIzFVsuM/Uyf4F3K6AVxrrEZX0EcbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuQBTI4jr0sR6vzyF4T+cxhiapC2Ms1RCFfMK0DmKsINHQicQXCW2d9l/+pTUWtNW
	 sYVnel4NlRN1ocIOBTwPY24qxpH+UzdiuE7xDzfebf/1aKNTqN8MtcFoO+sF/o7Sur
	 9TcN1wWV4G0mmrCtrgJGEUeMX3w4usE/wUOJi4bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 085/138] selinux: ignore unknown extended permissions
Date: Mon,  6 Jan 2025 16:16:49 +0100
Message-ID: <20250106151136.452477153@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -970,7 +970,10 @@ void services_compute_xperms_decision(st
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
@@ -1007,7 +1010,8 @@ void services_compute_xperms_decision(st
 					node->datum.u.xperms->perms.p[i];
 		}
 	} else {
-		BUG();
+		pr_warn_once("SELinux: unknown specified key (%u)\n",
+			     node->key.specified);
 	}
 }
 


