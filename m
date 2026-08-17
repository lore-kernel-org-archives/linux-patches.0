Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1562E762C;
	Mon, 17 Aug 2026 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979872; cv=none; b=umO/ZTLQN6143mtHbX2XBkCyQijYcAyJYE+zmqolPZgvzVMfVu8qbk4TgfiQxd3bx/W+yogiyk3qvOMM/uDH7ih5LIGHbinM29uIDugtNrfQkojI9Oj/EaJWW5tYiwMbcdtydtK/DRuI6AHVLmuDt5CWRy8ne+LH3z8IQAQSuN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979872; c=relaxed/simple;
	bh=/ZUbQjENjGyTm3qz03gNm/pN77HLdFQL1pXSh5Ne3aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy57trule9pJnSNQSNJxO9rZN6kfEsT824fH2Ai+TNvCxGixPsYtqqO5pGOPW39RQ/edpDvk/Q/iWOjnx7NL4XjtnoVm7GiuI/ShExpfCKZCxJVCJ6n64QPJx+v6lSvtCoOPCpAlkKSmV+NRk2EXS9nVMU/Xk7VhVES+q2AzY7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uafs8nFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uafs8nFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385CD1F000E9;
	Mon, 17 Aug 2026 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979870;
	bh=6s1HSSVvA7uXryY4QdqcU+Wi8PW25LgmbgboBMkuL5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uafs8nFzL8R+8xq/9XBRgUIhUhBvAB4c5lyzs1TAv3HYGmB+yf4E5ZIpFblo9VH2t
	 AvqS92NUju6L0J3cPSRdPDNuvNfnrw9LyLMuMvGeSZZ1+dFFr9YCwfXN8NrDWox6m2
	 kGfOJe8WdHz8Q7vq7F7qjbhUArz3SjWCakq+i/OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/609] ksmbd: return success for deferred final close
Date: Mon, 17 Aug 2026 15:31:13 +0200
Message-ID: <20260817132556.887070107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4911d1e325cd2..e67b055b8eb3b 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -394,6 +394,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 {
 	struct ksmbd_file	*fp;
 	struct ksmbd_file_table	*ft;
+	bool closed = false;
 
 	if (!has_file_id(id))
 		return 0;
@@ -408,6 +409,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
 		}
@@ -415,7 +417,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 	write_unlock(&ft->lock);
 
 	if (!fp)
-		return -EINVAL;
+		return closed ? 0 : -EINVAL;
 
 	__put_fd_final(work, fp);
 	return 0;
-- 
2.53.0



