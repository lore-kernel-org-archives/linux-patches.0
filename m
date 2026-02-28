Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBD5375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301643; cv=none; b=raYRDoerJ21gFaspgW0Q3hBY2dqQd/2Vv0fbWt+HMI+ufhZHoigbo+0lAjt3fhobxQlkQlEvNaLJYRNLPQBP1dGz0CP72/FwDQBTOo7HtQQMFEvBexFY1+m8Vmdsd6JlsKUE/WgOxen7csNv+cVncXmqP7W5L6h5fKbmpa8L2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301643; c=relaxed/simple;
	bh=/kKNOefBofEyNaj3/PX0QYsA/EKvkl3ZMG3PFcl5yMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIbpnKJl5arEzZQJhIXVja2jB8rpKQidOdFT5jrSslDN+1ylkCq0d6pyYis/T72Uf2tt78lXJuG5lxTZiTcBl67KNo4XuJqqo787QKEwhsC/xWtayagrwn/qIIMwILNDmml8sY87KrzAvAwWylncBLxBLYbMKF9o9fSUXHzO56I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohDn2H+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohDn2H+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A20C116D0;
	Sat, 28 Feb 2026 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301642;
	bh=/kKNOefBofEyNaj3/PX0QYsA/EKvkl3ZMG3PFcl5yMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohDn2H+7T9kEXtIrr+iF1gw7N30bXWr+FXhdKuC8kxQ0GqG7bhYHuV0AFDoTJ6kqW
	 Nm+00NglGDnDzjdx5QQCoPZDlYjqRxefTUswL3OqjALU+k8ZlbJT2Ec80f7FUjNvqH
	 3MIDErDYOK95eEg7uyZajNKKTCv/6SIkUTcaAddrgzwZJqZv9XRJIGUmjFehkJmAWw
	 ZmD2pkGbnALdQNlbXsyrOecB/p2egGkTPP5rsJL7c1rm3Rw+L76kc06o7Gar+Yfk7c
	 pLRcdfYX7rSFpCVaeCnUD+BRDPOVTaCNQn0WcjL/dn8A5SyAJEbAr4IpLMc94k8EBv
	 ZQrS65gLRgKeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/385] iomap: fix submission side handling of completion side errors
Date: Sat, 28 Feb 2026 12:54:19 -0500
Message-ID: <20260228180011.1568201-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 52dd8c9c3f6f0..5ccf215f932db 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -398,9 +398,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
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

