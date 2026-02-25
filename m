Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C02248F54;
	Wed, 25 Feb 2026 01:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983806; cv=none; b=rrfNMvZumcPQzjPJ/JbkCWek1h1ixa5pON3wGR7xktaASbr8ov8PjOEwsSeLrRDEOj4ImKpns3VsuwbOygI9GqhZZT91qaCw84d7dO7SbsWAwHPj6pVae9PYAycWw9mDPFAJHPonY0PtXB2i2HBmWG+iPM+A6gAVch8tF1Yg6YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983806; c=relaxed/simple;
	bh=7qg/g7QLNZwNu1vbSjh/ZWajvsaWwdDko814yJ3m4tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA6Y1PqZPjIqvvzZJTan5vA55rPyCH1bKW488uufiqY5X2ezJNSQjwTaLUiHFFwi1a4iBcgKJ9RqsjGV0+hKeqM2jUvvv4YNxQal4iu92dWMfCe4tFNABTlPPXZSeX/zAem7LwQ6n/gK2CBu3GAUF8aIt+pAWp+xfjFNAOncfUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCtQ0uOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCtQ0uOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F19CC116D0;
	Wed, 25 Feb 2026 01:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983806;
	bh=7qg/g7QLNZwNu1vbSjh/ZWajvsaWwdDko814yJ3m4tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCtQ0uOb+5PtjJpPvdA0ZA8/QO24sKsU1Yqnk57SADTTqoZBmy2FvOmUSvM54tc27
	 kDdtXTapoFmd0LW+wlhYPxE/1T7iNOgGqrBcXZa8+JoVBpXow1+bG38ZYXL4SjSAB/
	 8vWjDTFFhwQk51UNHZ0aWX9ip7Zyo659U+9U4kPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/641] iomap: fix submission side handling of completion side errors
Date: Tue, 24 Feb 2026 17:16:15 -0800
Message-ID: <20260225012350.223220731@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

[ Upstream commit 4ad357e39b2ecd5da7bcc7e840ee24d179593cd5 ]

The "if (dio->error)" in iomap_dio_bio_iter exists to stop submitting
more bios when a completion already return an error.  Commit cfe057f7db1f
("iomap_dio_actor(): fix iov_iter bugs") made it revert the iov by
"copied", which is very wrong given that we've already consumed that
range and submitted a bio for it.

Fixes: cfe057f7db1f ("iomap_dio_actor(): fix iov_iter bugs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6317e4cd42517..e73c71f39bd45 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -429,9 +429,13 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS);
 	do {
 		size_t n;
-		if (dio->error) {
-			iov_iter_revert(dio->submit.iter, copied);
-			copied = ret = 0;
+
+		/*
+		 * If completions already occurred and reported errors, give up now and
+		 * don't bother submitting more bios.
+		 */
+		if (unlikely(data_race(dio->error))) {
+			ret = 0;
 			goto out;
 		}
 
-- 
2.51.0



