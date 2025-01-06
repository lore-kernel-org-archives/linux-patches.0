Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BEE14884C;
	Mon,  6 Jan 2025 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177287; cv=none; b=OKveGL0F+DDQ2P8pjzeWvdIHnDutPoD233bHEnUlBFMQm4RagsqixM3mPfWS9sXR/IgvpFa4HAqyhyq9H6D47ry/cz/ffKY+hLf7EXwCOLvQ2HD1MOTczA4/kJCbC3vTmudmr/ULs22Qm3tNO0uA1ugMmrPeF2iX4S4/lzCXe6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177287; c=relaxed/simple;
	bh=j7jvoKRjZlD0zjOUa5jKACBlda7nowEt1P1Q/KV6fcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AXUI+tP2DV3v6kyeQ+bh/pfeXjtnU5BgTLtgC3hJ11hVlG+hy5jQX5hu37sm7Ung8XF7j5/uWfwxG5ZgW9GUUZpb+ZBMhUCavattC8MqrYzVehYYaF+6K7pUtQN2J9C5SbJqtVJLVaAubZuH2pk9nq91p9jmxD6sbVqTp7jyPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdjBSGq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdjBSGq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B10AC4CED2;
	Mon,  6 Jan 2025 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177286;
	bh=j7jvoKRjZlD0zjOUa5jKACBlda7nowEt1P1Q/KV6fcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdjBSGq74kTZf7HjMWTnkRU+ZfBERUIkp9DbkKUGRwb5HC6GhFgupDQSq4igWdIwV
	 SPvLNoMRdNY1FMLi/7glvHZtjz8HF+yoiagNOUtqWTPEjP4xAa5RtzA6MSmM9VzZ+f
	 WkF9wUhodXbPghD5hHMG67Xrso7ubSbdxqxGMiYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 113/222] selinux: ignore unknown extended permissions
Date: Mon,  6 Jan 2025 16:15:17 +0100
Message-ID: <20250106151154.873405262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -956,7 +956,10 @@ void services_compute_xperms_decision(st
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
@@ -993,7 +996,8 @@ void services_compute_xperms_decision(st
 					node->datum.u.xperms->perms.p[i];
 		}
 	} else {
-		BUG();
+		pr_warn_once("SELinux: unknown specified key (%u)\n",
+			     node->key.specified);
 	}
 }
 


