Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F2430DEDD;
	Mon, 13 Apr 2026 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098269; cv=none; b=Oov6r1GPIfk8yqqVWgIjiWaCPcCjfqdsQ+p3n3yz9WnWPzjzxhVbILYRD0xMSOg2V9rkgQhZ/HbMPsikQQ68MhdW7CtapyLHs723Da/s8e8zIKFzoqrE3DQ/t687fcLwd+iVhF6KTK1iZ9AmHxCsu1ZM8rYddvsBiWP08tQRdDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098269; c=relaxed/simple;
	bh=nGimfaP2+iI9wbO6mm31W1ruTpjofjE7baQlSUtMTFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JN9xoWNtTjkXJb1HZZnD6AS3wvoNvGVomwB3zD+xIuD2TFK50VoiavUF0ckfW3zQ/0LzyDakCnOEiJJ/vsPCI9dkOu2Mfh/cjVeRNf4JYnvXSzGsWwTDs0KFE6uUdQ+TWFQfLoJAfx025MrpqSt25j+YvYkjaF6IlpxtWJaCpGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndxxpAzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndxxpAzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3751BC2BCAF;
	Mon, 13 Apr 2026 16:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098269;
	bh=nGimfaP2+iI9wbO6mm31W1ruTpjofjE7baQlSUtMTFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndxxpAzg9lgJ9tXBLaa+OMjR3ez9FJI+q8qxJiybdgW7DkUEElW4QYHf8ykVmCqKO
	 X9WFEHNsjgvlYvm1LiskaUKc+2EJ07vB/cNNpL5eFvN9y+Bx9TVkEpYORELcFE25JY
	 Y9RrC6gkpSeNXwJxUjgZfuNh5pMTEfivbyoV9HSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 459/570] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Mon, 13 Apr 2026 17:59:50 +0200
Message-ID: <20260413155847.663911589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


