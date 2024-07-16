Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794231DDCE;
	Tue, 16 Jul 2024 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146136; cv=none; b=rg4y+KxoZJnWGhHzZbRbztjAzAxyvfGNsHdY1LeVqm+yX4XNRZnk++NPsOF9TadV/1eB8p3zANJvy25L8P0uV5HmpyY5G89r2iCCoAaWo3GZuUxTjA8/4tKa7V113HPmm5tJhTiqxI+1mD7FX1P4H/jG0bwkt8583L+kBAm6XDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146136; c=relaxed/simple;
	bh=T0zII4Y8Mtuvfh+Px+xKPgp7KxtYO23EfAmBig1HwmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMGhRYaTbRlt8tCZ8DaKN25sbEFpYMzGcL9uRproyNmx4dII4thaF8tN6cxWF5iWWoBYprRU69ZRG8di9+KeD1WI43y319MOdVS0Xyc19uZ5v17zCKGG/alXs+KkRvIdMDwESx8uwfdC7n3jDBntjhdBGTZqgfuMVvLGu0dccpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYuklZCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYuklZCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002C3C116B1;
	Tue, 16 Jul 2024 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146136;
	bh=T0zII4Y8Mtuvfh+Px+xKPgp7KxtYO23EfAmBig1HwmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYuklZCCHq2kHI1rxb0wSACNgjYtqoDYcSWuRtUDrwsNCl+QgXI3mNBp5q/eD9cMN
	 w3+b5tqGXUZ6vH7ocOKhfob+u2z5XDgXRWdA0jp+DZWp4aOnC02b7tYB68tA49bJ/L
	 6eHxvUVxIVJqY9gEmhvwiH5LigurLCMvWLdSISMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <21cnbao@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/144] dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails
Date: Tue, 16 Jul 2024 17:32:18 +0200
Message-ID: <20240716152755.199662293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7f8bb7a1e5c5..fc67b39d8b38a 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -275,6 +275,9 @@ static long map_benchmark_ioctl(struct file *file, unsigned int cmd,
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



