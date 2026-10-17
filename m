Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55663AA4E8;
	Sat, 17 Oct 2026 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256845; cv=none; b=lCnTNJkP2cTzw+n1rR9JCfvouhigL0p0yeVefX2KNb1+Ag4t13hBUZtA242a0nycR69ERzG+E0iODP3dg+oPpNufnfmUisq8sIhw5ntj0Sq8mGnn/BHfbRLCvDL55gVTbOQlVDUHxp+vK9EvhhJxMNknaSBEDodND+mYzzcsX3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256845; c=relaxed/simple;
	bh=txW67m7/7141P537uomRgI4XemOI9G10JQ+mgExYxSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIRrZyPsLkYp5ooU2a9B8BJvcIGxWXk9W4Htnm7LCj8paw0j6x0f1gj8LY3PvgQsyrfFB4fiAHpsBZ1qwV8ongxht7jlkLxuDE5tL0I3UxDqppy/EM+Mtn4L61srbdO9rGw/WSaJD+FMxAo40t7kNuZrD36s8rZjRVGP0jelMWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjU3ohje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjU3ohje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C43D1F000C4;
	Sat, 17 Oct 2026 17:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256844;
	bh=ZfZ35SykW+uk4WQuxAj/f8chNwX34qijpVAE8H5XGQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjU3ohjewOVn07VBbkg2nqdlyLQ6fq6f1Hkyd2+HppzfWHS0n8s6bgt1qklkkd7Y6
	 Ry1j1kjNF2LPl/tUMkfZfhohXrBm9MMObdlobwbtA/+0HC0cL/8sn5G4KvWPF/l277
	 XZMXnQUXqRUJcunffKk1SdUY588bdiP6uUSgnxEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0343/1674] iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()
Date: Sat, 17 Oct 2026 17:43:35 +0200
Message-ID: <20261017160439.932754451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit 2093236e886ad9446ec3285ba520e024dd1464e1 upstream.

admv1013_read_raw() switches on chan->channel instead of
chan->channel2 when handling IIO_CHAN_INFO_CALIBBIAS. The channel
field only ever holds 0 or 1 (see ADMV1013_CHAN_CALIB()), while the
IIO_MOD_I / IIO_MOD_Q modifiers are stored in channel2. As a result,
the switch always falls through to the default case and calibbias
reads always fail with -EINVAL, even though the corresponding
admv1013_write_raw() path correctly uses channel2 and works as
expected.

Fix the read path to switch on chan->channel2, matching the write
path and the actual channel_spec definition.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -197,7 +197,7 @@ static int admv1013_read_raw(struct iio_
 
 	switch (info) {
 	case IIO_CHAN_INFO_CALIBBIAS:
-		switch (chan->channel) {
+		switch (chan->channel2) {
 		case IIO_MOD_I:
 			addr = ADMV1013_REG_OFFSET_ADJUST_I;
 			break;


