Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BEE422550;
	Thu, 16 Jul 2026 13:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209051; cv=none; b=OCPlfbgdMBHgdcjj/JauO0Nb53mQ4uvQ0ndRgbYAg44UGjlpyaCaslvm04+BlLSvR+ogLzsCaQpWo55VSgONLhmRnOMa9GUy4fzBd5/btPmWXo9fIN/NdTzI74gIuWKfnqj4IxK0tKIaiDWbYi2Iq0cOfdW9UX6/a7rcnSAn01A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209051; c=relaxed/simple;
	bh=gnuAPOXHX0T0koqQKBBrTpYvTL1WthgGNCVJ4Y7hVrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5chkiVV6IK3TuMUWhtNeBMOKGWu9kmn76mkc0f58xszgZDSsTWiRSZl2JqbbLicE9iDItLv8wvBKPQsOK/Z7SbDFWHtEItCZ/ECr7l+rz+YNBirmPaegX13wmu0k3Wy7QvT983y+ZgCt/uI+nObZpPHI/gfKsZ0MkEUAvGk1Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcSmd4o4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcSmd4o4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B691F00A3F;
	Thu, 16 Jul 2026 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209050;
	bh=k/n/jFPQ+CES73yDpw7KHkO1q0m6Lnn1WjH+tj86770=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcSmd4o4vto/j07UhhUeowcF5t0Zm2B9tH3P7cTdkRuud5zmpfoozp9NQpVV0Ex+8
	 t2ei24Tkm/flmcQ7Ci4B9klCTHoAgwwwLVnlrQrz2eEwXIHP3fH2aidceDaRi5IiGP
	 ema7PCKtC2970KiJzelof7gCzOkc/z5+QMRzVz9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Sabau <radu.sabau@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 039/518] iio: adc: ad_sigma_delta: fix clear_pending_event for registerless devices
Date: Thu, 16 Jul 2026 15:25:07 +0200
Message-ID: <20260716133048.634800086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Sabau <radu.sabau@analog.com>

commit 91bc6767a4f55dc470d8a56b55b9f2ea09094efe upstream.

ad_sigma_delta_clear_pending_event() falls through to the status register
read path for devices with has_registers = false and no rdy_gpiod. For
such devices, ad_sd_read_reg() skips the address byte entirely and clocks
raw MISO bytes with no address phase — making it byte-for-byte identical
to reading conversion data. If a pending conversion result is present,
this partially consumes it and corrupts the data stream for the subsequent
ad_sd_read_reg() call in ad_sigma_delta_single_conversion().

Furthermore, with num_resetclks = 0 on these devices, data_read_len
evaluates to 0. If the clocked byte has bit 7 clear, pending_event is set
and the code attempts memset(data + 2, 0xff, 0 - 1), overflowing to
SIZE_MAX and corrupting the heap.

Fix by returning 0 immediately when neither rdy_gpiod nor has_registers
is set. This is safe for all current registerless devices: ad7191 and
ad7780 (with powerdown GPIO) are reset between conversions by CS
deassertion, so there is no stale result to drain; ad7780 (without
powerdown GPIO) and max11205 are continuously-converting and cycle ~DRDY
at the output data rate regardless of whether the previous result was
read, so the next falling edge fires naturally.

A future registerless device that holds ~DRDY asserted until data is read
would be broken by this early return and would require either
num_resetclks set or a rdy-gpio.

The same heap corruption is reachable on any device with rdy_gpiod set
but num_resetclks = 0: if the GPIO indicates a pending event, the drain
path executes memset(data + 2, 0xff, 0 - 1) regardless of has_registers.
Add an explicit data_read_len == 0 guard after the pending event check;
the stale result is then consumed by the first ad_sd_read_reg() call in
ad_sigma_delta_single_conversion().

Fixes: 132d44dc6966 ("iio: adc: ad_sigma_delta: Check for previous ready signals")
Signed-off-by: Radu Sabau <radu.sabau@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -262,11 +262,25 @@ static int ad_sigma_delta_clear_pending_
 
 	/*
 	 * Read R̅D̅Y̅ pin (if possible) or status register to check if there is an
-	 * old event.
+	 * old event. For devices with neither an RDY GPIO nor registers,
+	 * ad_sd_read_reg() transmits no address byte and clocks raw MISO bytes,
+	 * which is indistinguishable from reading conversion data and would
+	 * partially consume a pending result. Skip the check for such devices.
+	 *
+	 * This is safe for all current registerless devices: ad7191 and ad7780
+	 * (with powerdown GPIO) are reset between conversions by CS deassertion,
+	 * so there is no stale result to drain; ad7780 (without powerdown GPIO)
+	 * and max11205 are continuously-converting and cycle ~DRDY at the output
+	 * data rate regardless of whether the previous result was read, so the
+	 * next falling edge fires naturally.
+	 *
+	 * A future registerless device that holds ~DRDY asserted until data is
+	 * read would be broken by this early return and would need either
+	 * num_resetclks set or a rdy-gpio.
 	 */
 	if (sigma_delta->rdy_gpiod) {
 		pending_event = gpiod_get_value(sigma_delta->rdy_gpiod);
-	} else {
+	} else if (sigma_delta->info->has_registers) {
 		unsigned int status_reg;
 
 		ret = ad_sd_read_reg(sigma_delta, AD_SD_REG_STATUS, 1, &status_reg);
@@ -274,12 +288,25 @@ static int ad_sigma_delta_clear_pending_
 			return ret;
 
 		pending_event = !(status_reg & AD_SD_REG_STATUS_RDY);
+	} else {
+		return 0;
 	}
 
 	if (!pending_event)
 		return 0;
 
 	/*
+	 * With num_resetclks = 0, data_read_len is 0 and the drain sequence
+	 * below would compute memset(data + 2, 0xff, 0 - 1), underflowing to
+	 * SIZE_MAX and corrupting the heap. There is no safe way to drain the
+	 * stale result without knowing the data register size; it will be
+	 * consumed by the first ad_sd_read_reg() call in
+	 * ad_sigma_delta_single_conversion().
+	 */
+	if (!data_read_len)
+		return 0;
+
+	/*
 	 * In general the size of the data register is unknown. It varies from
 	 * device to device, might be one byte longer if CONTROL.DATA_STATUS is
 	 * set and even varies on some devices depending on which input is


