Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E39314EC4D;
	Tue,  9 Jul 2024 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523837; cv=none; b=W4oYll59BG7SHfl2bZEqaJSpBCMkY8B/gLVqg63u7gFClo1Ar9/ESrjPFi0S/gmbuIBjesqnfGEA2DEzJK/7kAOaW9MIyL7e7gajmdAqHLbHbn+hxl+qU8PrNSw10jgvVslhEkHzKPgsFkR5iD2BT8oPOECYS6Ti49nDpv8sgDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523837; c=relaxed/simple;
	bh=vb2HVLmwdV8txT9t19skYVj+IKr11ZpvoeDpKdiGofQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOFCnQYthCqG+XEpxYlR1b0Ldqvi+kw9HfE2hUWjGOYim1B6m1oXxKcgWyk7X1/GN0fMyaok00dy3PHUVGak4tk1QWLXVCNRsXUOCOVnH+uziIScTpRmrLpz8BTau1UU1Mo6mXHRUmLZwhO/dD+BAZEvdebN1qoSh4PmMip4+p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEJVEV0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEJVEV0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13B0C3277B;
	Tue,  9 Jul 2024 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523837;
	bh=vb2HVLmwdV8txT9t19skYVj+IKr11ZpvoeDpKdiGofQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEJVEV0S78PgIS/hzvtNnZri7R5qXhHoKilLuiFWx++O88htr2vWuW86kyH0l2Fbw
	 bGlcT+wjk9PdE4ukTp+4tyWKwiuFmyNnL5F39Wby2rsv8l6SvHk00k8iDqVoMCRaWr
	 Ibm83RvegA3NLjY8CWSXU56dkedAx4I84bqajGNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <21cnbao@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/139] dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails
Date: Tue,  9 Jul 2024 13:10:26 +0200
Message-ID: <20240709110703.039659518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f7f3d14fa69a7..4950e0b622b1f 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -256,6 +256,9 @@ static long map_benchmark_ioctl(struct file *file, unsigned int cmd,
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



