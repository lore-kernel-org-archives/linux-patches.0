Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F514038F;
	Tue,  9 Jul 2024 11:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524807; cv=none; b=t3fWKOoalowPcbLHih0FdQ//KeNKfzmoVF34pqRS134J1pWy/ckr7u8oWUwPXn9U20lo3yXxOndhzaOXip4kZtMMktUE0HIut9awjkPpl2CmsCyC+s6cVWOnkIizgwVWJgXA35wt7xZbJ1yD2Hm5WVgT6aPyp8kNL0/W46Xt8AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524807; c=relaxed/simple;
	bh=xxP8H5I9wgzNpUZ2BstBy3ZSRKv2Y5QMJGfbTv0iRyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBeKRDnAqe/4aaakKfx4WAgEm4rHeIpe0nW8rO2XNbmqz3eN9a4b+CIp47caUNd03RgkCZGiy1uQ3C2QnmLftIeGDQqhWWtxn8iqDyDy9mU27Qs1/ZR3NXBYJd4UwMeGZVx+vo0N6nVc1AIVJjeTqebIahlTpv9fuKcuUsMlaxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5kFEToz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5kFEToz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9D5C3277B;
	Tue,  9 Jul 2024 11:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524806;
	bh=xxP8H5I9wgzNpUZ2BstBy3ZSRKv2Y5QMJGfbTv0iRyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5kFETozf07yTFBMUJDCw4SDo+4LxWVs5jhOwZceZvoFAqazhrI2vB0M1s/qiLTnA
	 QrOT6eJ1kBDdIGKwWlCLD4BniKhbKw17xgf8Ye6wjcE2SwytZ+9kzhYZbH3q+EfRqh
	 Ozz5V+z6RAPxNvS59a8i9GMmftf4Ft2RHqJpo/PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <21cnbao@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/102] dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails
Date: Tue,  9 Jul 2024 13:10:55 +0200
Message-ID: <20240709110654.948704662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f7c9ccaadffd13066353332c13d7e9bf73b8f92d ]

If do_map_benchmark() has failed, there is nothing useful to copy back
to userspace.

Suggested-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/map_benchmark.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/dma/map_benchmark.c b/kernel/dma/map_benchmark.c
index af661734e8f90..dafdc47ae5fcc 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -252,6 +252,9 @@ static long map_benchmark_ioctl(struct file *file, unsigned int cmd,
 		 * dma_mask changed by benchmark
 		 */
 		dma_set_mask(map->dev, old_dma_mask);
+
+		if (ret)
+			return ret;
 		break;
 	default:
 		return -EINVAL;
-- 
2.43.0



