Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126373728;
	Mon, 29 Jan 2024 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548532; cv=none; b=mSXTd3ssKpSnhuT2dBX8j/I0xiobpUKiZFmPy0eZOkn1Fq/yvHfmom9UfV+Ip9VRrU57KypyahW8gq63Zt33UV7odAyYJyaRsbXUP+J2d3HJSaFaCK9dmJiZvIWL0+ZQTVXN4MIHrhGjaBw6cz0mGeDCWEVMSE5/DaKo/0MR1rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548532; c=relaxed/simple;
	bh=AwNJvhwrTsB74Jr+xkvctYXCqHIfynUf8a+40rIMZB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/nDy/mSDK1pTrvrJFBdnVKNQZ67GtwoRq+ozQKpU5CBDe4df6pfP/iWz8bR6/+FocWrhB+yeNHIix2qgm56nGa2RZ8UQAswD6IvGFecZUhMxMFNUQj6Zy5mLv9G7hJlRZPDoP9+LTwRqGFlC8SKzbL4/B7Yi3eHytgtPYDRX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcYSWXXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcYSWXXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F1CC433F1;
	Mon, 29 Jan 2024 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548532;
	bh=AwNJvhwrTsB74Jr+xkvctYXCqHIfynUf8a+40rIMZB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcYSWXXaFvBIQ3pwISNSAXvtz+UjS54+wQIbwHGcfSGm1C/zDGlUh/WZb7gR9nySY
	 jfINrsK7/Fl80hwFrOlb7S0ApM/DvXC0oLrc7CY2WechP8+VBj5lRUf2vEiBwdlk/x
	 QFXrmAlD0QbxfxqfitOHmX24bwwKcK+Xb8Cc7pko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 143/331] ksmbd: send lease break notification on FILE_RENAME_INFORMATION
Date: Mon, 29 Jan 2024 09:03:27 -0800
Message-ID: <20240129170019.122649079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3fc74c65b367476874da5fe6f633398674b78e5a ]

Send lease break notification on FILE_RENAME_INFORMATION request.
This patch fix smb2.lease.v2_epoch2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c  |   12 +++++++-----
 fs/smb/server/smb2pdu.c |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -541,14 +541,12 @@ static struct oplock_info *same_client_h
 				continue;
 			}
 
-			if (lctx->req_state != lease->state)
-				lease->epoch++;
-
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
 				if (lease->state != SMB2_LEASE_NONE_LE &&
 				    lease->state == (lctx->req_state & lease->state)) {
+					lease->epoch++;
 					lease->state |= lctx->req_state;
 					if (lctx->req_state &
 						SMB2_LEASE_WRITE_CACHING_LE)
@@ -559,13 +557,17 @@ static struct oplock_info *same_client_h
 				    atomic_read(&ci->sop_count)) > 1) {
 				if (lctx->req_state ==
 				    (SMB2_LEASE_READ_CACHING_LE |
-				     SMB2_LEASE_HANDLE_CACHING_LE))
+				     SMB2_LEASE_HANDLE_CACHING_LE)) {
+					lease->epoch++;
 					lease->state = lctx->req_state;
+				}
 			}
 
 			if (lctx->req_state && lease->state ==
-			    SMB2_LEASE_NONE_LE)
+			    SMB2_LEASE_NONE_LE) {
+				lease->epoch++;
 				lease_none_upgrade(opinfo, lctx->req_state);
+			}
 		}
 		read_lock(&ci->m_lock);
 	}
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5581,6 +5581,7 @@ static int smb2_rename(struct ksmbd_work
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
+	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
 out:
 	kfree(new_name);


