Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062097;
	b=Fmn8Elu6LV2CTXVekhLsDkLZnDMM/7GCw0vyxhZ1rXWDFhxtd419CpUQC2pOxSoQ+jXI
	 CvDS+LS6ixrJqgk05wXna96UIEBGfa8VqAJgtjkrvksUTacFqJkiRS5EKdg3yiDZS0QdB
	 Az6lhjw4A53xslVUrfIZ103u0YJo4NhLNP3AG4bn+UxdPEjqWRQafuG8OmFRN/FLhl2HD
	 PwXsbvUw3Uj9/TnuVtgPhN89+IchJ8flUH9TXdiL8Mct13gFrh+HHCtezqxKQcZnGUQOQ
	 ucmqKzO6evTt7udb9uG30YbuMunz/rNfibCUBOKovTVS6bT9j8QtEP8OAzHuCO3Neqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z85gTEa0Cykr0w+lymivYGymw6yGqUDykLkcrqSde5M=;
	b=lALEdQgo8rMCtA57VSubO+RCwmBl5PjyGvSyYBU9vzyJSMnnaMyS5gxPXmEhupQy6Anm
	 US6sNGYclyOmGBpMTw3SWuL/3ENfI0xCHjeN0A+nBHbMghRMU0JBYA53my1aWIhqfUHMI
	 HH8XQQE1SzUbQa43MxPWRlJ69pL5EBlMxyCdxw0vTO+IAx7/IOYF3ICHETsX/wfco9hYA
	 ZePEFpn6SABrbRKV/I2m2SPkO+pQeMrGtDlGw79PAVYVzmGo2v4WEi6kNqH4qWUJnF3X4
	 MW+cx7WfhOWJTtfWgg6YLyTAbnBgX0FNfgrvi1Uwg8PZFGOAUIpzrryEHaMkYIHbdMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6BgZzVe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA868606D834;
	Sat,  7 Nov 2026 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6BgZzVe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413A71F008A3;
	Sat,  7 Nov 2026 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062096;
	bh=Z85gTEa0Cykr0w+lymivYGymw6yGqUDykLkcrqSde5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6BgZzVehFUiuMHK7SFUVDNwjUADVre1gOtFkkfVVGZiaa2M8yL6m6I3bDp/IsSOI
	 Yd7jMc67JP7x3noCP7h5NUbOCo7/LogQfSPRDxpSFiOJCaUv8StYpTlqbD28Ye5lje
	 U29FJy7nJAPkZU44zpoqjohwsJ/GnvG6KD/aLzcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1033/1536] md: validate bblog_size when loading v1.x badblocks metadata
Date: Sat,  7 Nov 2026 08:50:49 -0500
Message-ID: <20261107135026.685907598@linuxfoundation.org>
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

From: Yuchao Zhang <ndaugoing@gmail.com>

[ Upstream commit ae5f89b23cb88667cfa1273b42d6a551db9c651e ]

In super_1_load(), when the on-disk feature_map does not have
MD_FEATURE_BAD_BLOCKS set but sb->bblog_offset is non-zero,
rdev->badblocks.shift is initialized to 0 without validating
sb->bblog_size.  The same field is validated in the
MD_FEATURE_BAD_BLOCKS branch ("sectors > (PAGE_SIZE / 512)"), but this
branch bypasses that check.

A forged on-disk superblock (malicious storage device or crafted
image) can therefore carry an oversized sb->bblog_size.  When bad
blocks are later recorded, super_1_sync() sets bb->size from
sb->bblog_size and md_write_metadata() issues a bio larger than the
single rdev->bb_page, reading beyond the page and leaking kernel
memory contents to disk.

sb->bblog_size is never modified by the kernel between load and sync,
and the MD_FEATURE_BAD_BLOCKS branch already validates it, so checking
it in this branch is sufficient to cover both paths.

Fix this by rejecting an oversized sb->bblog_size with -EINVAL,
matching the existing check in the MD_FEATURE_BAD_BLOCKS branch.

Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260922044606.30774-1-ndaugoing@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 634b68b6632ea..4c17608e066dd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1797,8 +1797,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			if (badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset != 0)
+	} else if (sb->bblog_offset != 0) {
+		if (le16_to_cpu(sb->bblog_size) > (PAGE_SIZE / 512))
+			return -EINVAL;
 		rdev->badblocks.shift = 0;
+	}
 
 	if ((le32_to_cpu(sb->feature_map) &
 	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS))) {
-- 
2.53.0



