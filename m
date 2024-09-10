Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7AA1885A6;
	Tue, 10 Sep 2024 09:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961996; cv=none; b=nAgpofFEO1MtYBPVgp3Mp/xKQgol5ChxU3auTBz5QQH6I2saeKTIGhHX/iIS8mnYEjunXxeYp7iGblJCAWObIWe0+hmxRAg5ishT7u4mCeNjuu3CActgPXm0eFPtgxE5hoJJFLj3fuHH7LINHXGAMjObYCfSYUujVXDwEjfuY8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961996; c=relaxed/simple;
	bh=AlHI9sfNtYJHKIPBhYVrA+mb8rSiOcWkztyNOi+9gJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX8N0UWIwiKcekImOwshDVDXJFGjYj8CE8RlIoGLV3ZsrkbMxE3P+qt7RdsZornWN3BO+4z1nuC/lqN0vaPDUo4PnD1cKa1Zr3+a4nXfu/Ow+gpLz/amSi26uwHlAt1MY8yWuvq21K4RaNN8q6/EH2SgDx6+NAb9O9rCLpDyM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNDHKPd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNDHKPd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FE0C4CEC3;
	Tue, 10 Sep 2024 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961996;
	bh=AlHI9sfNtYJHKIPBhYVrA+mb8rSiOcWkztyNOi+9gJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNDHKPd+7FDVApPFRPFn9bUyhnzAagcUx7iArsocJA5Vj0d6Geg24+ZP6KqzUfzsS
	 KZ92fq3XvVJsvxDatVO4p7Wgka3SPoLHpFHWrvpW+oD1WgHv40qQ/FdgkQJQ5kY1yf
	 yWxgsBW0V8w8LdY11FLbRo/O42V7rg21w0mKgseU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 260/375] i3c: mipi-i3c-hci: Error out instead on BUG_ON() in IBI DMA setup
Date: Tue, 10 Sep 2024 11:30:57 +0200
Message-ID: <20240910092631.296144011@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 8a2be2f1db268ec735419e53ef04ca039fc027dc ]

Definitely condition dma_get_cache_alignment * defined value > 256
during driver initialization is not reason to BUG_ON(). Turn that to
graceful error out with -EINVAL.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20240628131559.502822-3-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 4e01a95cc4d0..1a96bf5a0bf8 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -294,7 +294,10 @@ static int hci_dma_init(struct i3c_hci *hci)
 
 		rh->ibi_chunk_sz = dma_get_cache_alignment();
 		rh->ibi_chunk_sz *= IBI_CHUNK_CACHELINES;
-		BUG_ON(rh->ibi_chunk_sz > 256);
+		if (rh->ibi_chunk_sz > 256) {
+			ret = -EINVAL;
+			goto err_out;
+		}
 
 		ibi_status_ring_sz = rh->ibi_status_sz * rh->ibi_status_entries;
 		ibi_data_ring_sz = rh->ibi_chunk_sz * rh->ibi_chunks_total;
-- 
2.43.0



