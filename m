Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854741F7540;
	Tue,  3 Dec 2024 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239320; cv=none; b=fzdawo+u/PaKYp03SoYmCS7Ck6BKc6h58/CDIg3Z5o7UBJ4JHoztOP3U8ppolbxHmoKKNwKPfp1WnffLuk8tTYVKkOFnl55Ug2ZQItpAa7AY1Bwf9OXz2rP2PYHbM9MviefO17fFIOyTGBU+JeD3Ai9jTcs0nJjJt/9ewqAy930=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239320; c=relaxed/simple;
	bh=6lLNvQXy/S1kbqo4+Kw8u5I7J210w7MT6m9Z3Vq0EFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWbLHKr2Y2KjFAdxPz1S09TyO7Dixo3+34+Ij+nFHfdt8QHhRmTkcEocpmFY8T9lDw9LaZ8q/kzO8qoufkA8XViWlQCUHfOPl9CbpW00l0NuKPlVZo3r3YOqDp0wfrIciwFOMQ0vegtMJC40z/XNS4Nt6peHOT9N2vwLAmKKITQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTuHnZCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTuHnZCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC3AC4CED9;
	Tue,  3 Dec 2024 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239320;
	bh=6lLNvQXy/S1kbqo4+Kw8u5I7J210w7MT6m9Z3Vq0EFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTuHnZCJJWCQgIhNtFqhBE+dtF1mKiFXICrHIOLKq2NWKISCYfasDYCdFiwHBm08y
	 6LjV2g3ocQ4zgIdocDmSxwRAoxU02Iug9fFXof7jUFTak/trPpOiHfrvfIjUk1CVkO
	 Cjfz+FWTOrJ4vxALTCOxouz1yXowaSLmhIv/kWG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 572/817] exfat: fix file being changed by unaligned direct write
Date: Tue,  3 Dec 2024 15:42:24 +0100
Message-ID: <20241203144018.241086788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 2e94e5bb94a3e641a25716a560bf474225fda83c ]

Unaligned direct writes are invalid and should return an error
without making any changes, rather than extending ->valid_size
and then returning an error. Therefore, alignment checking is
required before extending ->valid_size.

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 64c31867bc761..525c3ad411ea3 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -578,6 +578,16 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret < 0)
 		goto unlock;
 
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		unsigned long align = pos | iov_iter_alignment(iter);
+
+		if (!IS_ALIGNED(align, i_blocksize(inode)) &&
+		    !IS_ALIGNED(align, bdev_logical_block_size(inode->i_sb->s_bdev))) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+	}
+
 	if (pos > valid_size) {
 		ret = exfat_file_zeroed_range(file, valid_size, pos);
 		if (ret < 0 && ret != -ENOSPC) {
-- 
2.43.0



