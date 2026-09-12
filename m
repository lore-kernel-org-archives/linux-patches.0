Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568F3002B3;
	Sat, 12 Sep 2026 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208742; cv=none; b=nMMADzz8NKp+q4vNAMc9mBD5hMBgn6DonGALg6JrCEaJRXJ32c18TcjJSkSM8oQ25Zd8mAKBbukqYdwEXNWmPJrbAEIQ1rbDSlrDe6pL/7+jybIuSRnTJjEuNGAjtmsLdj2BI6uQIwMxxo1cStAA4tf8W7Eiix/V6o4R+iMKOhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208742; c=relaxed/simple;
	bh=+EkgmF1+n/va0QwPNDyfxETbEXH8reCggNfhEpFlzxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJWbJIh/ZsjHmDRWlxVem+OQUr8M59jffgBgJKjhLbJYZB3oWWeSK5PF1V+zt6qwyA1fkYBXuQFIFA06n3PaU1pmJe87AhA8QLEqSBr1vutdLbTH6PRQHe3pKvktk6JuLvjoHfs4DhRO8CcvzP8N4YXw/YXx7eJIKuACDYBvuuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HumF467T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HumF467T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEA61F000FF;
	Sat, 12 Sep 2026 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208741;
	bh=E5+ZiBfyi5Qugz+gdMdB+yFO6Z64e5pYpHfHomxc/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HumF467TuguDCbqdsEfMF07Ucu5ugXq5k9MlEz4XWObtB9Syg1LSeYMq3t6kRuOpa
	 ZKDFwU4ZmMGPSvzMTTcOjpg5Pw7YrRZ+RLy9e1Q62dOBuM/Lxn07njmyJKo0tMU932
	 8MYjMVs0rtPQWhK0aYCqwSuhSFT4RzTb0mr4AbK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0678/1518] block: dont set BIO_QUIET for BLK_STS_AGAIN
Date: Sat, 12 Sep 2026 08:47:27 +0200
Message-ID: <20260912065638.770895440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a148d0a5af1ab60253994047403f9eb41ef709a4 ]

Commit abb30460bda2 ("block: mark bio_wouldblock_error() bio with
BIO_QUIET") added this to suppress buffer_head warnings, but neither
when this commit was added nor now any buffer_head using code actually
ever sets REQ_NOWAIT which can lead to BLK_STS_AGAIN.

Remove the special handling for now.  If we ever plan to use REQ_NOWAIT
for buffer_head based I/O we're better off handling BLK_STS_AGAIN in
the completion handler as it actually needs to retry the I/O as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260518063336.507369-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 702a2a9f3dfe ("block: fix dio leak on metadata mapping error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bio.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 16c1c85613b76..257ff84dbd56b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -384,7 +384,6 @@ static inline void bio_io_error(struct bio *bio)
 
 static inline void bio_wouldblock_error(struct bio *bio)
 {
-	bio_set_flag(bio, BIO_QUIET);
 	bio->bi_status = BLK_STS_AGAIN;
 	bio_endio(bio);
 }
-- 
2.53.0



