Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F421C5F37;
	Thu, 13 Feb 2025 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460896; cv=none; b=SaDGJSPDmcvHky0OV+Wte4c07m1BG20GHJxoApDTpYCo+oUxldfeWpJaTrQyrn3tr9ClyIimJGW3A6f1dFF//d5X/giWeMbT6yNS1FppmmUEoJG/AUs0lWDJRQ6YzChfMfKnzjTTqHAAQ3YOKLECEvda6G2AgqiWLRGKLrgHQuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460896; c=relaxed/simple;
	bh=dcqYYKDMocP5SuugkfdqgKfUxHBljHCBCZAtz1WPmZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR2jos/PfyPkiPD8DpNIsUADreaAfh1JAyyrpmdaGzlgGBj9XRto2kT1mwlgJNmTM4xn+k83cK7SY9blqE7gJUhEMFtU5HFe4f5d7KJPzAsYp1ItPwusKU+yL7BHT1QunnNd9kCpcgkgzrLyYKGSIK9gRgdaJx0Ng9vkVdqajSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbB9Dgdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbB9Dgdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEE1C4CEE8;
	Thu, 13 Feb 2025 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460896;
	bh=dcqYYKDMocP5SuugkfdqgKfUxHBljHCBCZAtz1WPmZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbB9DgdpoKP+ecR94luljmf7FMSJOO2cv4GV+GnXiAq7YRUfWyjgXsmzpI+KWj+OU
	 CHYQmbgk3WaF8SgZ/dW20i2VgmbtaF7WHb+ft/bRK0mLzABRKretJytxFsyvE5H5Mo
	 qeC8yT6oh4G0DeUDCHSRr38st4W1YCK+pD79MXGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 211/273] media: i2c: ds90ub960: Fix UB9702 VC map
Date: Thu, 13 Feb 2025 15:29:43 +0100
Message-ID: <20250213142415.656509955@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 5dbbd0609b83f6eb72c005e2e5979d0cd25243c8 upstream.

The driver uses a static CSI-2 virtual channel mapping where all virtual
channels from an RX port are mapped to a virtual channel number matching
the RX port number.

The UB960 and UB9702 have different registers for the purpose, and the
UB9702 version is not correct. Each of the VC_ID_MAP registers do not
contain a single mapping, as the driver currently thinks, but two.

This can cause received VCs other than 0 to be mapped in a wrong way.

Fix this by writing both mappings to each register.

Cc: stable@vger.kernel.org
Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -2534,7 +2534,7 @@ static int ub960_configure_ports_for_str
 				for (i = 0; i < 8; i++)
 					ub960_rxport_write(priv, nport,
 							   UB960_RR_VC_ID_MAP(i),
-							   nport);
+							   (nport << 4) | nport);
 			}
 
 			break;


