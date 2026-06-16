Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5313CFF55;
	Tue, 16 Jun 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635653; cv=none; b=OqcGb9t4RBnRYkpZqIkKTIqyZjAOepz86QExCNdfg2/Qen/4Zang7TmsKdcHtt0wV/HHl/9J4LkrSB98pflDag74mGgV0zpdVt9k1U8mSqZU4MIQ0sJ6kg+V/fMvjyxaCG3sJosu4tO3XeoERdokUIub4DJsoJ9yzbYXhMgmEJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635653; c=relaxed/simple;
	bh=P08A05qP2+4RP6WfWNQnkum5VWJwD6HplLLNHiJLGVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JIP9L8ff9oZIXMQtQ2zosmLf3CsDMtI6EjcH/m2wHPWsRg2UCRDFJBFHEHWLtId7l/pjtjK2G8QlHadlOIvoaFbKUFR7gz4DYkDqyCw5JgZ564JknFZlt8AW/VcQskKV/R5Aixe7R/nP/sEEtCRB+NQnEtk9NjgHzC+6CGDXXkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoBj7Ksa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoBj7Ksa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57291F000E9;
	Tue, 16 Jun 2026 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635652;
	bh=2ouKp6d+wQMK3dDq9n/8ZDR9V5AForsZ2dyTcPlNSBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoBj7KsalSXhmK3nHBnH2R1VlIiw3PFavncILKNzYgf0kdl21a9qdJGdoGDcpCeFG
	 ibUtQ8gyIvO+jZVRdYKQfaUNbNAgru7tr8V5CanYc7BtaFqm8m0ZCndpdqB9Pv77Vu
	 qXAYOZsYcarKAMOdwDK6UTtWM7sDVOaQsrO/HhqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christofer Jonason <christofer.jonason@guidelinegeo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Salih Erim <salih.erim@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 056/342] iio: adc: xilinx-xadc: Fix sequencer mode in postdisable for dual mux
Date: Tue, 16 Jun 2026 20:25:52 +0530
Message-ID: <20260616145050.867955622@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christofer Jonason <christofer.jonason@guidelinegeo.com>

commit 852534744c2d35626a604f128ff0b8ec12805591 upstream.

xadc_postdisable() unconditionally sets the sequencer to continuous
mode. For dual external multiplexer configurations this is incorrect:
simultaneous sampling mode is required so that ADC-A samples through
the mux on VAUX[0-7] while ADC-B simultaneously samples through the
mux on VAUX[8-15]. In continuous mode only ADC-A is active, so
VAUX[8-15] channels return incorrect data.

Since postdisable is also called from xadc_probe() to set the initial
idle state, the wrong sequencer mode is active from the moment the
driver loads.

The preenable path already uses xadc_get_seq_mode() which returns
SIMULTANEOUS for dual mux. Fix postdisable to do the same.

Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Christofer Jonason <christofer.jonason@guidelinegeo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Salih Erim <salih.erim@amd.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-xadc-core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -770,6 +770,7 @@ static int xadc_postdisable(struct iio_d
 {
 	struct xadc *xadc = iio_priv(indio_dev);
 	unsigned long scan_mask;
+	int seq_mode;
 	int ret;
 	int i;
 
@@ -777,6 +778,12 @@ static int xadc_postdisable(struct iio_d
 	for (i = 0; i < indio_dev->num_channels; i++)
 		scan_mask |= BIT(indio_dev->channels[i].scan_index);
 
+	/*
+	 * Use the correct sequencer mode for the idle state: simultaneous
+	 * mode for dual external mux configurations, continuous otherwise.
+	 */
+	seq_mode = xadc_get_seq_mode(xadc, scan_mask);
+
 	/* Enable all channels and calibration */
 	ret = xadc_write_adc_reg(xadc, XADC_REG_SEQ(0), scan_mask & 0xffff);
 	if (ret)
@@ -787,11 +794,11 @@ static int xadc_postdisable(struct iio_d
 		return ret;
 
 	ret = xadc_update_adc_reg(xadc, XADC_REG_CONF1, XADC_CONF1_SEQ_MASK,
-		XADC_CONF1_SEQ_CONTINUOUS);
+				  seq_mode);
 	if (ret)
 		return ret;
 
-	return xadc_power_adc_b(xadc, XADC_CONF1_SEQ_CONTINUOUS);
+	return xadc_power_adc_b(xadc, seq_mode);
 }
 
 static int xadc_preenable(struct iio_dev *indio_dev)


