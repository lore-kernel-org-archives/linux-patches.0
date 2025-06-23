Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A81253F2D;
	Mon, 23 Jun 2025 13:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685013; cv=none; b=JBBVeQzkzdulkPYd54vHtrrRS+EOm0lyZPAGGbTXnWEXdcKHaMhdBbaX4D5NOqxmtiXff6pVyEy+bQO20BxT1mN9E1iuigrx0TeEYX/qm62vj9GHgjRjEqYP1I5OWDb8FnXdbwwHBUunKXwNfmMrAIL7LREYesZtS3Pqsdm36uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685013; c=relaxed/simple;
	bh=99WlCNPA5r2f6EJSsqUmEzwYyPmoHMYj5QQcWJv8QWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8xJVUcRhBnDHDVJ0345HsqL9lErCYycPVJN0Jvec6/eoPkfFP93swWDmhUTlvUb9VwBJCGODlakAs8B/6gbH+k+SQkPXDxYlQBX+dh5CC7sMJ8t28xX2YZcNtbDg7iW2sQ5DnhWzUrd2P1jd/MAJmfexqmWzkEL+VF7FpIz5OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5+3pEmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5+3pEmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA0AC4CEEA;
	Mon, 23 Jun 2025 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685013;
	bh=99WlCNPA5r2f6EJSsqUmEzwYyPmoHMYj5QQcWJv8QWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5+3pEmH4iJhw2UDlX2HOBF6x0zMPWKBWQyJDSwZn91yXRyfYmzV+xKCaUSYztHiI
	 RGEpHaOp/Ea923cw5LBr+fYsElg8ZfI04M7ZTglB59qZnAJUO4vd0MyGceqRk7cowJ
	 KJnHw05bLbIkc1wPALYOMPEwS4Vv8Mo+FsLpZBM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 201/592] iio: adc: ad7944: mask high bits on direct read
Date: Mon, 23 Jun 2025 15:02:39 +0200
Message-ID: <20250623130705.070217678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 7cdfbc0113d087348b8e65dd79276d0f57b89a10 upstream.

Apply a mask to the raw value received over the SPI bus for unsigned
direct reads. As we found recently, SPI controllers may not set unused
bits to 0 when reading with bits_per_word != {8,16,32}. The ad7944 uses
bits_per_word of 14 and 18, so we need to mask the value to be sure we
returning the correct value to userspace during a direct read.

Fixes: d1efcf8871db ("iio: adc: ad7944: add driver for AD7944/AD7985/AD7986")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250505-iio-adc-ad7944-max-high-bits-on-direct-read-v1-1-b173facceefe@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7944.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ad7944.c
+++ b/drivers/iio/adc/ad7944.c
@@ -377,6 +377,8 @@ static int ad7944_single_conversion(stru
 
 	if (chan->scan_type.sign == 's')
 		*val = sign_extend32(*val, chan->scan_type.realbits - 1);
+	else
+		*val &= GENMASK(chan->scan_type.realbits - 1, 0);
 
 	return IIO_VAL_INT;
 }


