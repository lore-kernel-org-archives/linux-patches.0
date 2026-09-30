Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9AD4D37AF;
	Wed, 30 Sep 2026 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793522; cv=none; b=bwSs1/8VB8lO5BRRT7iOcpQFx2ATkQwLKlnJP4D2e3Bw5gLX1q5F4qBPs/5lV63ZYouogB7yBgpjyYLi41wVYOp9h/FyNwSDa/QFTV+itC8r2mY2WVzOHDzXFhYHxG6nWH4Q4QiVgzUnZ32Aios9eLS9/3ao1oREk7yZwMTwmcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793522; c=relaxed/simple;
	bh=LMhDxcsc7hfcZaLqLaVe9OyJ73QewENdJ2q6792CYYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk5OnqBgL3xEEQFyP9JBNQCsqFoT/7/vEiGd+JgRbKQyreuBEsNoJsdsKH7MEykbkq/p8D28TytvybqG4loOBPzg3KJG4wscloFF4jdxbSLrZ3lf9bJv0xRkGW1kg2QiJdLUWU6UgiyBpGJfIAQNFD5yH9SKLItBiVJLu+yS/hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZLp2E+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZLp2E+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88BC1F000FF;
	Wed, 30 Sep 2026 18:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793520;
	bh=Z25eIIEREFy7vE9qoqY9E39R2b9HHCqL7qmHNnU/zMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZLp2E+KFywVUwBJGojwHJkvK4k93tuS/N+Itd2WVxeuNmggJopKw8PtMAQbsyYob
	 87JR9pKxrQrY5L3t19IZ1Y/Jl+lXLJRbJ4Shcj2Xo3j4I+k5w2BrXlIwvPwmXbS3w5
	 ae4mUiu4I9x2pGv2C588Jn87UnAgd26jc5S/UBYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 285/395] net: ena: fix MMIO read buffer leak on probe failure
Date: Wed, 30 Sep 2026 17:29:07 +0200
Message-ID: <20260930152346.843583575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9476b4468862927297c94c440863cd8ed1e7cc83 upstream.

ena_device_init() initializes the MMIO read mechanism with
ena_com_mmio_reg_read_request_init(), which allocates a coherent DMA
buffer for MMIO read responses.

The normal removal path releases this buffer through
ena_com_mmio_reg_read_request_destroy(). However, if ena_probe() fails
after ena_device_init() succeeds, the error path destroys the admin
resources and eventually frees ena_dev without destroying the MMIO read
request, leaving the coherent DMA buffer allocated.

Call ena_com_mmio_reg_read_request_destroy() in the probe error path
before releasing the remaining device resources.

This issue was found by manual code inspection.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260921154202.471662-3-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4127,6 +4127,7 @@ err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
 	ena_phc_destroy(adapter);
+	ena_com_mmio_reg_read_request_destroy(ena_dev);
 ena_devlink_destroy:
 	ena_devlink_free(devlink);
 err_metrics_destroy:


