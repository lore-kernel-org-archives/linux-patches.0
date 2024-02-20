Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBE0612D7;
	Tue, 20 Feb 2024 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465269; cv=none; b=V3GCa8Xkry5sCgS22qa8SO07TxPGX6z1KXrhQxWxpT0O2RFSSJ8C8lKIDyAn2qmyBuQXf20MGy2qY9xSSJ9+prnKVxcNhaU9zwdqr1KV0wxFAhgg1G6p/X9dpxD9Q0qlvWlbu0Q3ehijPelnon6EHT6CHo6oaaCa+84MTDwk8Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465269; c=relaxed/simple;
	bh=7FDFFMVf0L6ei5X6UVZxm/r3W+nC2wLvf0NyOBcLbdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6ffFXLousZ68Wve2RrOlzZA5VyUV4gviW+Gd2WYxVru07HepmkrlFaPOmPfqshNw7WcEYtsRO8wKFWeJI33NSLAvPw0RnSGws1MPoBapZlADVdDLCfSJg0iIYHabcHQnVcsiFdMCrN4RlZ6G9n8HMDx1A/MXDo/BXdN7LPkhc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLfQdEJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLfQdEJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1597FC433C7;
	Tue, 20 Feb 2024 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465269;
	bh=7FDFFMVf0L6ei5X6UVZxm/r3W+nC2wLvf0NyOBcLbdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLfQdEJ9uK8MxlTp1Uuw1ZaMi+S3ddvA3TPj6TkFsP9jRiw0HXm7CAIvdEAyRSFDI
	 /FmpyyijeqyWgH+iJkEGfyMNE+zVnlqK4bpE76Z21uPMXca8EODbUfQQYfnogfTXii
	 fqUhrmDwEmgvPaOHc7NInJrrSwC2lJ+QmHy53+O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"R. Diez" <rdiez-2006@rd10.de>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Matthew Ruffell <matthew.ruffell@canonical.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 260/309] smb: Fix regression in writes when non-standard maximum write size negotiated
Date: Tue, 20 Feb 2024 21:56:59 +0100
Message-ID: <20240220205641.284394696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 4860abb91f3d7fbaf8147d54782149bb1fc45892 upstream.

The conversion to netfs in the 6.3 kernel caused a regression when
maximum write size is set by the server to an unexpected value which is
not a multiple of 4096 (similarly if the user overrides the maximum
write size by setting mount parm "wsize", but sets it to a value that
is not a multiple of 4096).  When negotiated write size is not a
multiple of 4096 the netfs code can skip the end of the final
page when doing large sequential writes, causing data corruption.

This section of code is being rewritten/removed due to a large
netfs change, but until that point (ie for the 6.3 kernel until now)
we can not support non-standard maximum write sizes.

Add a warning if a user specifies a wsize on mount that is not
a multiple of 4096 (and round down), also add a change where we
round down the maximum write size if the server negotiates a value
that is not a multiple of 4096 (we also have to check to make sure that
we do not round it down to zero).

Reported-by: "R. Diez" <rdiez-2006@rd10.de>
Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Suggested-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Acked-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Tested-by: Matthew Ruffell <matthew.ruffell@canonical.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org # v6.3+
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c    |   14 ++++++++++++--
 fs/smb/client/fs_context.c |   11 +++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3425,8 +3425,18 @@ int cifs_mount_get_tcon(struct cifs_moun
 	 * the user on mount
 	 */
 	if ((cifs_sb->ctx->wsize == 0) ||
-	    (cifs_sb->ctx->wsize > server->ops->negotiate_wsize(tcon, ctx)))
-		cifs_sb->ctx->wsize = server->ops->negotiate_wsize(tcon, ctx);
+	    (cifs_sb->ctx->wsize > server->ops->negotiate_wsize(tcon, ctx))) {
+		cifs_sb->ctx->wsize =
+			round_down(server->ops->negotiate_wsize(tcon, ctx), PAGE_SIZE);
+		/*
+		 * in the very unlikely event that the server sent a max write size under PAGE_SIZE,
+		 * (which would get rounded down to 0) then reset wsize to absolute minimum eg 4096
+		 */
+		if (cifs_sb->ctx->wsize == 0) {
+			cifs_sb->ctx->wsize = PAGE_SIZE;
+			cifs_dbg(VFS, "wsize too small, reset to minimum ie PAGE_SIZE, usually 4096\n");
+		}
+	}
 	if ((cifs_sb->ctx->rsize == 0) ||
 	    (cifs_sb->ctx->rsize > server->ops->negotiate_rsize(tcon, ctx)))
 		cifs_sb->ctx->rsize = server->ops->negotiate_rsize(tcon, ctx);
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1107,6 +1107,17 @@ static int smb3_fs_context_parse_param(s
 	case Opt_wsize:
 		ctx->wsize = result.uint_32;
 		ctx->got_wsize = true;
+		if (ctx->wsize % PAGE_SIZE != 0) {
+			ctx->wsize = round_down(ctx->wsize, PAGE_SIZE);
+			if (ctx->wsize == 0) {
+				ctx->wsize = PAGE_SIZE;
+				cifs_dbg(VFS, "wsize too small, reset to minimum %ld\n", PAGE_SIZE);
+			} else {
+				cifs_dbg(VFS,
+					 "wsize rounded down to %d to multiple of PAGE_SIZE %ld\n",
+					 ctx->wsize, PAGE_SIZE);
+			}
+		}
 		break;
 	case Opt_acregmax:
 		ctx->acregmax = HZ * result.uint_32;


