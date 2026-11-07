Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062158;
	b=3ETm2kPVoULBbzF1XyviMMkN57y4s7OYrEwmK/OO8TpdyxYMor9q83yf+cwYjept8px2
	 l4xKmaPH71QR46x1n2BGWO6GU5RyxfSpxSA8GEMNC2SFh5lJRauy03XME0xRO6MKoKO4A
	 oNitCDWpwY3s+dpNIewhvhqvAna2ylIa/h72duhdK9LpomKms/ea6BO6tN+YiHFZPXAT7
	 wlmvGF90mtTDDD9IDBycTkhr0XboeAq4CWvVCHi1H7tDOBnEfUGiqJQrk3ko8Q+8jNmfW
	 WvEn5lucHyjnE0d2h0GVn6fS/Cmd+Su8DB2UaM/pTSmfkNIzIv/biNUic0NJpyRo3gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62REG6roT4WPS1lA5zPaDmwL+wgppTkW3iC5keAylyI=;
	b=XDQaStNHSp+VWgHopo6IURcwaIzz9H9au3hHAViHX4hFKLKlVWYB/sH7gQWpsDIkQTdJ
	 7GAs+0WO8mtIciE+GBB7eJ3q7PvRqakXWTcocdIFtoBdBlmXQRuQnMDrTfX/eptVgv4er
	 3JjUwBi3qrhK+LskjRVwZTj9xY9osvBZcVGoRanNzUR1LrPRXyNwsfIBRbPR/Vi3UL9VN
	 FKBUVozsFXn6Tldci4q4kyW1XTHlQfQughREUQEFgJNmy9vKq1kaxW66bXPx90uiCseMT
	 0Pfb0jtm1VxInQHXQhD2eUSfJ2FLSdXshnQMR+PX/db5451ybs3EAwQN65wZVulGD+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AgOV1/0G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABAD606A66A;
	Sat,  7 Nov 2026 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgOV1/0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9331F0089F;
	Sat,  7 Nov 2026 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062158;
	bh=62REG6roT4WPS1lA5zPaDmwL+wgppTkW3iC5keAylyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgOV1/0GPbr38cRNNFVKqeFz+cY6DFJjj5Cim+tDr57TUgc9/KdPFF0F84LvJrqzF
	 U/I9cCUV1ROnZwfwGb/sF9e9AJcwxNYbu40u3UMi64jL81V6Sb9YN0AM+UfcQv+A85
	 IZKkO+B19rAwDk7lftsAhNtgRir07biA+QgJUBnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1122/1536] dm: fix a bug in dm_accept_partial_bio
Date: Sat,  7 Nov 2026 08:52:18 -0500
Message-ID: <20261107135029.223298706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit a279804752e6c767b7f9ecbb32a15bdfd2b80aea ]

dm-writecache doesn't work in pmem mode - mkfs.ext4 and the following
fsck.ext4 fail with data corruption reported.

The commit 7dd76d1feec7 ("dm: improve bio splitting and associated IO
accounting") introduced a latent bug in dm_accept_partial_bio - it set
tio->io->sectors = n_sectors;. This is incorrect, according to the
diagram in the source code at dm_accept_partial_bio, it should be the
size of regions 1+2, not the region 2 alone.

The latent bug become real bug with the commit 8b211aaccb91 ("dm: add two
stage requeue mechanism").

dm-writecache in pmem mode is the only target that actually advances bio
with bio_advance and then calls dm_accept_partial_bio (so, the region 1
is non-empty). All the other targets call dm_accept_partial_bio with
region 1 empty, so bug went unnoticed for so long.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 8b211aaccb91 ("dm: add two stage requeue mechanism")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e23d4c63484b3..bc3338cc48b56 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1372,7 +1372,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 	 * for accounting but it is being reduced so update accordingly.
 	 */
 	dm_io_set_flag(io, DM_IO_WAS_SPLIT);
-	io->sectors = n_sectors;
+	io->sectors = *tio->len_ptr;
 	io->sector_offset = bio_sectors(io->orig_bio);
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
-- 
2.53.0



