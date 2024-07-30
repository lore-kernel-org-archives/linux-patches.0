Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FA7188013;
	Tue, 30 Jul 2024 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357489; cv=none; b=SBh3TUh+nTTGgr0GHYH1RXrQx6Hl2w5hkG8q6vGoiOUibJntYwLm+NNwJYxoDLfQtPvbYrJ/m/zFb2BgQ+6AByalxkqSr3gchFD0m7SO13lJ6wHnrAl18La7WDdni/FY47Uc4uR9iVcxtrm2gLF6aa/qtyYTEFurPNc7vei0J/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357489; c=relaxed/simple;
	bh=dAN6IrJRn1tP7gR1oPk0IlOKpf5pfoHMbTP3lUmnQYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED6UaV3p/e7rJa36s5DN6Y1hUtEBpmJCEbrGsXWh3VLDsH9U3Bj9gV8wM0NGzHVcsvlia36E5Y9Amv4vDRhiGqwOwSwTg+I5JhJjOpAKvVqH2lphDgR6PfhsPddKnFhGt0MQRNMzw5me5ymYrYOiPWS+iun6Xq48Jb6qq8PzFQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVDt7MNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVDt7MNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B5EC32782;
	Tue, 30 Jul 2024 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357489;
	bh=dAN6IrJRn1tP7gR1oPk0IlOKpf5pfoHMbTP3lUmnQYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVDt7MNVY0fwpvBh7YAEF7FG1f2a9tHl2RvrawLlEL4xCIFFaQ1DtmQd9see1cDMW
	 HVTsL6/LNvKFhzsZvjMlH0wbTMNGQ7O4fqdB38dixYvYvob1nTRm9D4r1jKtCBbrSY
	 h4iE+Td3tSvKKJkn9mdIov7DpCovCWZ8bSGJ5SxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 297/440] cifs: fix reconnect with SMB1 UNIX Extensions
Date: Tue, 30 Jul 2024 17:48:50 +0200
Message-ID: <20240730151627.429363771@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3975,6 +3975,7 @@ error:
 }
 #endif
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 /*
  * Issue a TREE_CONNECT request.
  */
@@ -4096,11 +4097,25 @@ CIFSTCon(const unsigned int xid, struct
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


