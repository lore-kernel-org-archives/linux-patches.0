Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D12494F0;
	Wed,  8 Apr 2026 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672672; cv=none; b=afYLIZ7nHoVe7GcJzQN4r+o8PoOmSDZmLoS6cIjcM4izHdhJqi/woYicHjMvsfJK46b7hjNXIdqEHusHQkoVETAdY9Jj6/EHEnxnWYjkm8T5FZnIGui/qaECqQUXtKw8Sd1c1L+lfzmJ4yEm5pBP9HEs/N+buF5appdlOPUY+DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672672; c=relaxed/simple;
	bh=JwfdKG4odwZmyayD1hRQnzMzxeQHe+l+ijpBM3Ucuho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYLkTJgyVATYzrH/lAmavvvbSHNE8+z9IMumE4Iln5T23sGcPhCqp/w2cU1w8k01dG0kQmfEqD3A0Gs4vhs2Ybqx/gltkfYYnQWlq/Et80vVi2GqpHccXIMrELFkh4K010MtPVGRBbbeiKA5pKgD3Zx0edss2zohPjmoOnflD6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQsBYhZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQsBYhZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB24C19421;
	Wed,  8 Apr 2026 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672672;
	bh=JwfdKG4odwZmyayD1hRQnzMzxeQHe+l+ijpBM3Ucuho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQsBYhZRbeyaH3s2IZC+cI2nUAFkiFM0EfVAXKZ3EbcnnawlK/9svh6j1S2BUWxcd
	 bgyw8cVvsB1sKQK04XB/QL6Xm9f+vs70oFdUT2QEF+VwMifb2k3qEd/wIdGbKCIDFE
	 TzqA+uY7ZaIvfO9BCFTNleHuNtY5S8FdJCocwB94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 096/160] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Wed,  8 Apr 2026 20:03:03 +0200
Message-ID: <20260408175916.773600415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c354521708175d776d896f8bdae44b18711eccb6 upstream.

Return the error code from regmap_bulk_read() instead of 0 so
that I/O failures are properly propagated.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -323,7 +323,7 @@ static int ad5770r_read_raw(struct iio_d
 				       chan->address,
 				       st->transf_buf, 2);
 		if (ret)
-			return 0;
+			return ret;
 
 		buf16 = st->transf_buf[0] + (st->transf_buf[1] << 8);
 		*val = buf16 >> 2;


