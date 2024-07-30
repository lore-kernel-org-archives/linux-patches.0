Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66777189514;
	Tue, 30 Jul 2024 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358762; cv=none; b=qBvH1sEMeJZ2qs/bCNHQXvaXntw960VzcwwK/s/YLP8MlTtqwfwGBnMun4ISEOZrb9nHbpWLjxIGxcvk43gdYogicpSfWaKdKKFQMsiDiXVV3igBoBgyzyZ/tBsXuu2IqDvyDRzkdafIaW1M4W0pPyFKmBKmU3jP6ZUQ1kq9Frw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358762; c=relaxed/simple;
	bh=1JiwULpSQfUERRY44Ily22wLUOcKhY7dCYe0M5pI8vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS3BigRRX6srQ6Oixy5yTOZoUXk2opYBpdGIBwRn31CjQaczcl7TrlhwOnJDdqU9+n18HUGqaKbJNKSTyCzL4OpprtRYlBBfyUtH3qwGIQaS2kicXz23oldf/8tYFhoIukJIzpz/4buWTHkS7B63Wuroal0z8AePrnM5E9gx07g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tZ6AsOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tZ6AsOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB251C32782;
	Tue, 30 Jul 2024 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358762;
	bh=1JiwULpSQfUERRY44Ily22wLUOcKhY7dCYe0M5pI8vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tZ6AsOOSRyU/f5qCmEyUOQXWw0K1wTEQgHI2lWV4oJj269Q4Tt0FYxV4u/V4tDnp
	 +6Dg6ZL8ckFf1ZJZKB86Qvc2BCwuoNg4G1T5K+ZVkfndS668Qa9rKGq3PmOkH/cHFf
	 TWS+a77Gk7iO0ADU/WH75ULEhBUQitkSBMFbNORQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 391/568] cifs: fix reconnect with SMB1 UNIX Extensions
Date: Tue, 30 Jul 2024 17:48:18 +0200
Message-ID: <20240730151655.145820189@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit a214384ce26b6111ea8c8d58fa82a1ca63996c38 upstream.

When mounting with the SMB1 Unix Extensions (e.g. mounts
to Samba with vers=1.0), reconnects no longer reset the
Unix Extensions (SetFSInfo SET_FILE_UNIX_BASIC) after tcon so most
operations (e.g. stat, ls, open, statfs) will fail continuously
with:
        "Operation not supported"
if the connection ever resets (e.g. due to brief network disconnect)

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3686,6 +3686,7 @@ error:
 }
 #endif
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 /*
  * Issue a TREE_CONNECT request.
  */
@@ -3807,11 +3808,25 @@ CIFSTCon(const unsigned int xid, struct
 		else
 			tcon->Flags = 0;
 		cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
-	}
 
+		/*
+		 * reset_cifs_unix_caps calls QFSInfo which requires
+		 * need_reconnect to be false, but we would not need to call
+		 * reset_caps if this were not a reconnect case so must check
+		 * need_reconnect flag here.  The caller will also clear
+		 * need_reconnect when tcon was successful but needed to be
+		 * cleared earlier in the case of unix extensions reconnect
+		 */
+		if (tcon->need_reconnect && tcon->unix_ext) {
+			cifs_dbg(FYI, "resetting caps for %s\n", tcon->tree_name);
+			tcon->need_reconnect = false;
+			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
+		}
+	}
 	cifs_buf_release(smb_buffer);
 	return rc;
 }
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 static void delayed_free(struct rcu_head *p)
 {


