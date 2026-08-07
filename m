Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A642F5337;
	Fri,  7 Aug 2026 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116018; cv=none; b=OGHc+jEjk7IhBgt8BE2tHcrkNMzWgn9PJ66D850mlexwbjoMPip4WHx+wqWIMAE7OIcnC+HeS9g4PlofwLLwEmqu+s/4wuu+8CDLqYREN+WmHqhk64C4ypTKxVjZHRhIFUwZ9lLsphq7noAaMQhELXU4iEr+tlppX48pr1+IYgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116018; c=relaxed/simple;
	bh=ZHLHyM6Lr8ikoBp6yAjR9SP3EwT8HPO1sVySNafVerI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ0YIaKEFMna7b73svEOOi3bgsXv5C0LUJEuFiCTvYE4OnnXChc4ELhCEgkthn2fNGrZCtmAcVbPWrG6wAVUGXum/k+343AYEIURuoC90muYAoucqS5H5ieUwmfOMfRvMrf5F8gFr50nnh316KyXfP/dH96ipbhfp5Unn6FjFiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JunLrfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JunLrfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E11F000E9;
	Fri,  7 Aug 2026 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116017;
	bh=gwZ66kPXFTpKpfyuAMPzzC55RjAZzZg0Gs8O82TiWfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JunLrfvPB67ql9z1tEJ5wA2AV4EqsCQqXjwyN1HGzHQfY2iODTqTmY9UOnhodbCT
	 9fCpFtxsHjzTBaFmDVc4m9mfn4x7PhmgNTEEm4C+xtYX6cUxfTI0eAYgBcAZib68LT
	 jjVYLTQettbvglirqX9xpFlmjyXRQnzHgghUcxc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/261] ksmbd: return success for deferred final close
Date: Fri,  7 Aug 2026 16:37:21 +0200
Message-ID: <20260807143417.196576123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit c5db4de8988f1a621556ca5c4537f77b766ca07d ]

ksmbd_close_fd() marks an open file as FP_CLOSED and drops the file table
reference. If another in-flight request still holds a reference, the final
close is deferred until that request drops its reference.

The function currently returns -EINVAL in that deferred-final-close case
because fp is cleared when the reference count does not reach zero.  That
turns a valid close into STATUS_FILE_CLOSED.

smb2.compound_find.compound_find_close sends QUERY_DIRECTORY and then
closes the same directory handle before receiving the find response.
The query holds a reference while it builds the response, so close must
mark the handle closed and return success even though final teardown is
delayed. Track whether the handle was successfully transitioned to
FP_CLOSED and return success when only the final close is deferred.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: e7188199eff4 ("ksmbd: fix use-after-free in __close_file_table_ids()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index d15641007d4e3..320d467d46ca8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -487,6 +487,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 {
 	struct ksmbd_file	*fp;
 	struct ksmbd_file_table	*ft;
+	bool closed = false;
 
 	if (!has_file_id(id))
 		return 0;
@@ -501,6 +502,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
 		}
@@ -508,7 +510,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 	write_unlock(&ft->lock);
 
 	if (!fp)
-		return -EINVAL;
+		return closed ? 0 : -EINVAL;
 
 	__put_fd_final(work, fp);
 	return 0;
-- 
2.53.0



