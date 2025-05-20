Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3592D1922ED;
	Tue, 20 May 2025 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749340; cv=none; b=oXcqvHGxaN4XKO0/8qkARKJ9QHHRh0dDY+McXwDx4Kc4DNbPLJsmrIHAa/8EqISWCvUs/6QKT6Q11Iu4nj4k0S5shzN+HPKJ2y5e2kf5gd9LbgFHtsPywVVL+X29IQzHVisD4yzok5DqDSw8PCST4EBjm53Tm/KbjSKi1RsbkFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749340; c=relaxed/simple;
	bh=A1ejblnv8Enq0/Qu+JM7yFZo6odELEdC9sxa6Dc1tjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8LmlRcqoEl4XMmDBMBhbsQjJdYcHEC5FYbsAfw+4YNREAuZSXjRqMx2me7+uKmMo9wXDl7QhrHBxffWuaUGM7S/6OXF35OLeNZFoTuw4BsDOaBdbvfzRAdHC71WP3aJfkrj504L801SMHNobZ4cH/czF1Z2/DXFjBpp3PNBgSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkA0BI2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkA0BI2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1275C4CEE9;
	Tue, 20 May 2025 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749340;
	bh=A1ejblnv8Enq0/Qu+JM7yFZo6odELEdC9sxa6Dc1tjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkA0BI2ugrRog5DDXrjCLijkWHlzq8Tx5ML7QEb4Zt2EJivQ3CTak2TfBxEP4g2vo
	 9EQocR7we3xdhWZ8PPgLMDZI4fH+P67huQlgjE1uyQYj8cuAZXQqNVyvwAVLzh9zFK
	 wl6ZJ/m5qPt83a72uoUyMxGNcPufBADBgV8oETGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/97] iio: adc: ad7266: Fix potential timestamp alignment issue.
Date: Tue, 20 May 2025 15:49:38 +0200
Message-ID: <20250520125801.186112064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



