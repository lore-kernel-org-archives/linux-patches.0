Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD6E39A4C4;
	Fri,  7 Aug 2026 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117063; cv=none; b=CKgj7b/1VAFGV4LNDreeNkOAIVhyXoDWNGKTknfelkdIkkVS9Sc+YcURs2sfR5uunJEIib7fsNcDfw8jtJZV2z1dTneJoFyhHnqW8NpqmGdU9h6OeJzeJSxeHir8ED4y60OBm99saN3yqjeG9Ye3ja3IsiEyvvaWzff2bTz57EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117063; c=relaxed/simple;
	bh=0Tgml5MELG/1Cp6F3OmYUZ2XqdBVLL5NDAGvPSdOhyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqVjrggH3vqg/GYZqEEulyo06x2Gngakr80gSVSx6ydbGbRbdqNp4A1ymeWXoF9xl0WQcJ65msgMUAo6awvHOJuPqLlM+MwqxevvtFgeKhu8W2fYhqhFg2VCLeWHHW0h3lGoivWPk2kzScBtQIVZLyK/0w1EIujXEDVoPwgVhqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/kJsPRP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/kJsPRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6703B1F000E9;
	Fri,  7 Aug 2026 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117061;
	bh=X/iDI/FsAeA0FuxAQElXWHuN+TgdQPy5+IxiY1dRl2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/kJsPRPpOXfK5mMoVptHrGa4aA6L7KenWgGBct2hKcqWZE2AUuJ3mNvvUqWkC7Sk
	 YrNOIaUYR+2Oy25phXLns613ri2xul18jZaXU7se0xVR4LKQMMwVbpMpNpOGkjSiaa
	 l3FFhqeAe0ctUqROpstvGQbLaoMDA0nm5WoBb0os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 187/438] ksmbd: return success for deferred final close
Date: Fri,  7 Aug 2026 16:36:23 +0200
Message-ID: <20260807143432.019039449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa0924c9fdf96..b12c0bb527e41 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -580,6 +580,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 {
 	struct ksmbd_file	*fp;
 	struct ksmbd_file_table	*ft;
+	bool closed = false;
 
 	if (!has_file_id(id))
 		return 0;
@@ -594,6 +595,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
 		}
@@ -601,7 +603,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 	write_unlock(&ft->lock);
 
 	if (!fp)
-		return -EINVAL;
+		return closed ? 0 : -EINVAL;
 
 	__put_fd_final(work, fp);
 	return 0;
-- 
2.53.0



