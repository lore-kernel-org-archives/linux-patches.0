Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0AC288D6;
	Tue, 20 May 2025 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750018; cv=none; b=DJFwQDf649aUVWKLRRRVOiYRZiQ1Pb23EvRCpyrTaQ8rKHrewLB0cAOfdseqkfxr14yaKg63Y+HTLN1qmAQOq9wvLIRBkvPJdO+NHj9vzQ7esqS/+qq92IHHreNr3Dx3uktV5SZpomZwni10TKKAIOu9nBJ8oCOofbqW9g1s80Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750018; c=relaxed/simple;
	bh=LRZ2PAzQ6Sa+6gOyVUAC+1tTbGB9IdjXDG8gNwC4kNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oj32RdKqrNzTbFdapTWhZ89kc+Lk33RB9YfgC8/KyBRuLXVLqx4cVQuE2M8j5URIC6HcZ6RERVzJlLjkqZLa6oZnsHcE9dpNDZw6hf6hQ0vCnE+xwan6TAt+2A6AObRPJKrZ3RghXHvtIeVTr2LfRVNDEx0RWiiwfu1Z8H0mFsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbNFT26N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbNFT26N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EB7C4CEE9;
	Tue, 20 May 2025 14:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750018;
	bh=LRZ2PAzQ6Sa+6gOyVUAC+1tTbGB9IdjXDG8gNwC4kNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbNFT26NKolWu3GQuNi0zCHv21gvVPRN2hsB0B5DbDz+zW8X9h9JEYAWrq2nZyiiN
	 2cEJGyoXEGnx+eQRrwPa9G664lRAZOJnH+QqeCetZyG54XlDwVpd066ObY79DS0Bv2
	 QYFGmnNGCCW7sLpPrauYsovGDqcJK1yt5YikQT0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/143] iio: adc: ad7266: Fix potential timestamp alignment issue.
Date: Tue, 20 May 2025 15:49:31 +0200
Message-ID: <20250520125810.698675484@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 52d349884738c346961e153f195f4c7fe186fcf4 ]

On architectures where an s64 is only 32-bit aligned insufficient padding
would be left between the earlier elements and the timestamp. Use
aligned_s64 to enforce the correct placement and ensure the storage is
large enough.

Fixes: 54e018da3141 ("iio:ad7266: Mark transfer buffer as __be16") # aligned_s64 is much newer.
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-2-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7266.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7266.c b/drivers/iio/adc/ad7266.c
index 7949b076fb87e..d4c9b85135f58 100644
--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -45,7 +45,7 @@ struct ad7266_state {
 	 */
 	struct {
 		__be16 sample[2];
-		s64 timestamp;
+		aligned_s64 timestamp;
 	} data __aligned(IIO_DMA_MINALIGN);
 };
 
-- 
2.39.5



