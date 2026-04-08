Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03E53176E4;
	Wed,  8 Apr 2026 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674749; cv=none; b=SoGLe09kaAMQCZdnHe79ps29boA7LwMOAl3jajtRQA1YfRgnezzXxhwFRsMV5lDPjJLzUzYg8UCuiLRlUYlYA9pE1LU+l/kvobhJQqfy7URuLaB0l1yfPaVnorvGk8eS593F+l+4XRacaj3p1ukySRFssTion4DPtBFEbS7F9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674749; c=relaxed/simple;
	bh=dx/3QpkysTvB1UhZSykH0cv+cwItnyvKbHuiw5qxVCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv/uUMOBrY2ZLFeuC3Gm2t/8Z9gU5VxzC7G8VGxounVH+/3N1b+mzS1c2VfLph2J8X3K0KI00BApYvKTA1vg/vDFAV2RZFFW4SZdRucYpCnDQMndDOhnvmBn5p4DxL63JH01pb/Jll9eMeRDoBZxRPdD73J1Hqahd4BZhEmhYOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feKbji8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feKbji8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A08C19421;
	Wed,  8 Apr 2026 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674749;
	bh=dx/3QpkysTvB1UhZSykH0cv+cwItnyvKbHuiw5qxVCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feKbji8APaE7ovQQyJHxLbdaTwJUSECMmpBjkRt4jjaKjXxGxsQkO+DzIJ6XB9dyS
	 tZj9I2nsLUjJTEmwZHBI6nnuglQypWl9OtksBT839RY9B4mH9gmwH00z7QUvo7YhZK
	 YgCrl/d+OU0t9ECA4spd+DsxKRsE++slL/+x301I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 219/311] iio: adc: ade9000: move mutex init before IRQ registration
Date: Wed,  8 Apr 2026 20:03:39 +0200
Message-ID: <20260408175947.581035683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 0206dd36418c104c0b3dea4ed7047e21eccb30b0 upstream.

Move devm_mutex_init() before ade9000_request_irq() calls so that
st->lock is initialized before any handler that depends on it can run.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -1706,19 +1706,19 @@ static int ade9000_probe(struct spi_devi
 
 	init_completion(&st->reset_completion);
 
-	ret = ade9000_request_irq(dev, "irq0", ade9000_irq0_thread, indio_dev);
+	ret = devm_mutex_init(dev, &st->lock);
 	if (ret)
 		return ret;
 
-	ret = ade9000_request_irq(dev, "irq1", ade9000_irq1_thread, indio_dev);
+	ret = ade9000_request_irq(dev, "irq0", ade9000_irq0_thread, indio_dev);
 	if (ret)
 		return ret;
 
-	ret = ade9000_request_irq(dev, "dready", ade9000_dready_thread, indio_dev);
+	ret = ade9000_request_irq(dev, "irq1", ade9000_irq1_thread, indio_dev);
 	if (ret)
 		return ret;
 
-	ret = devm_mutex_init(dev, &st->lock);
+	ret = ade9000_request_irq(dev, "dready", ade9000_dready_thread, indio_dev);
 	if (ret)
 		return ret;
 


