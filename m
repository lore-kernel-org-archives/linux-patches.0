Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7664E2FF641;
	Fri,  7 Aug 2026 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114154; cv=none; b=s5G7f8psKU9dSAk0xj+LgGC6105Px5cEvLA2iI1DfYoWjncdnj+dacURQwz6nMgH4t7y3iDqgsVgt2+0+1d+OUNsb3752zL02oasSl3oFijKFnhTmXZa9rFDMswJRYCrbCV0ET1LANNq/CpipT+oumqW49hcBarDrxCjXuGpfSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114154; c=relaxed/simple;
	bh=85VQE4+A9Da7+lhIWCxzJKnAxwRDm5F1sq9AxQCItTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMT8lF7vOIZz52sNs2jE6KGWNhMnP4lrJcOPKSoa7u5xrQPjiUXTJNeCSikDg2Cgy5OP3pBFHos48PmzYRl5P/BqM0kIePX2LKRlpExZu5TDNE1VKwXdM5PNTG3PhuemwhLg0CalSxGlxN/fc0tEh1d5rXSmW5WC0YMjOeOEcT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rv3TNaML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rv3TNaML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF041F000E9;
	Fri,  7 Aug 2026 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114153;
	bh=HuRYNqprBxQduWeMIg9U/A3Knx9p5X2M+A1weIz57+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rv3TNaMLktbWgiabj6xheKK85QyHoqQZdhfd9PWrVUZ3a3F6yjqDgnE+chiNVasWV
	 NAxuSGp7lR+eYltRtZ82DtKIYJqzUdOTVxAetlbkdVQNOJbOPBTTEvQ4Ar5Ls8e2na
	 kRDgJBMroSUHnxs+P2bTneV4YjIbgJX5tOOzTqgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/337] ksmbd: return success for deferred final close
Date: Fri,  7 Aug 2026 16:35:29 +0200
Message-ID: <20260807143421.263788848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b6d8bb8edb27..0d3341927b483 100644
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



