Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A318A27713;
	Tue,  9 Jul 2024 11:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524427; cv=none; b=s4SnBN6jAgaBZg9a+is35gnMZ/JDuKZ2nnuAGVXnFBYaqu/My7ogxPeOFDB/LfVX3P9yn+MIDjEPJqG10x3cyLWrLaX/dg2x6aGGg7wpqojWH8obRvnrUmj19fxA9yGETjvrZ9IVg7F/03+I2y++Is4WZTNOgxA+/NVkEH6bRxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524427; c=relaxed/simple;
	bh=jQZyh8Kd053Ep/Z0sDJfn7YQnGjmBOh5g89Qjhr2Qqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/6dmU+bI/rRLxLxG022VaoQVhWkXOalkwgu+Ls3miG607g6xojmTf7ieCUJXiLP6Ucmr4gKQ47CFOBKiy1rYCdO4iSd9ltzMtyONkAGLpDlgFsQatH+vYtmDJSP1iKV0HIArkafVtYiRgmw03eMf7E8PdaU7ChHw+1YzhnYJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abEbBFIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abEbBFIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E82C3277B;
	Tue,  9 Jul 2024 11:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524427;
	bh=jQZyh8Kd053Ep/Z0sDJfn7YQnGjmBOh5g89Qjhr2Qqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abEbBFIGEobUv0xjvz+8+4cYg10kGvwZUVcgRBwMncBaW5cTR3DIEqksr0CiNYavE
	 E1WI1/uNZ2qn5YlHgpE/4Fu1X9ZZ06WWwxWfbSExjd23nzE7UbHUM7FGFHGsasqMvK
	 SQyAtamWocQSCO2iSXJuIjwfTZDGSWUEyrbH5gwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <21cnbao@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 179/197] dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails
Date: Tue,  9 Jul 2024 13:10:33 +0200
Message-ID: <20240709110715.872718479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



