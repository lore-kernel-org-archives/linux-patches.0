Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC7D242907;
	Tue, 20 May 2025 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749764; cv=none; b=diOoR54SUOtdxWhdXNiPi8L3pPi0Xvk6VhIFkkKd9kkKxqF1c/j4ZdOVZXcQ1AXXPK1jOjzvsQLFUBdtihRV5h8MHP9E9xRrTSK250OrU31BuIiRLz1pX5YHC+flJ/OGGJX8dSthmVJT2KSwRBWYwOfPm5ZqiOVXzjT1c+3na0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749764; c=relaxed/simple;
	bh=qAxhrlehMoBkHmTyzm7RhHncUMelum2T2M1X9NFD6yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZnrmFU5xG9bY24o9eqI+U2570N4EY5eiyBFLGf0OvqWkJDsgdmDkom8XoKyL7t8w+/ld4jXTW8FFvhoMESxHmE7lFyhbaI1LwQ/WkMi57JVUnXIR3PPGbqc/IZOfFAEUMWXF65QWCqE13g7wAlarAsN9G7T+YpOFNOaTcRPaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CseVsbes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CseVsbes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0999C4CEEA;
	Tue, 20 May 2025 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749764;
	bh=qAxhrlehMoBkHmTyzm7RhHncUMelum2T2M1X9NFD6yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CseVsbesTX+iGjz4pi9VhftgfmwTt0WIEJglZFfmTyWoREs8LIS9zWYT+cMwi65aJ
	 /h5M7MrFsUxrRaJ9pk0NPRu/s+2/1cdENH1/KdIQv/FIT3E6CE+FneJT4ZgcMzJChq
	 e8A6rDrm7RxlWgWtl3dfczgCjzkCJGGl3LawJAUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/117] iio: adc: ad7266: Fix potential timestamp alignment issue.
Date: Tue, 20 May 2025 15:49:47 +0200
Message-ID: <20250520125804.861504669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98648c679a55c..2ace3aafe4978 100644
--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -44,7 +44,7 @@ struct ad7266_state {
 	 */
 	struct {
 		__be16 sample[2];
-		s64 timestamp;
+		aligned_s64 timestamp;
 	} data __aligned(IIO_DMA_MINALIGN);
 };
 
-- 
2.39.5



