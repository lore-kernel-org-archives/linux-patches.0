Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF42115E5BB;
	Tue, 17 Mar 2026 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768382; cv=none; b=hcLwoeIoLHICcQBgmPCCNr2zzc4292vCd1qQ5/HCNcFMVDvO47ofzOU44Bp1E7N9/HLFPp7e+j2Cfp1lfq6BAoK21LZVAGZFf8cV8IdSDRmJuKY+N8oFRlN5VXwhDmNYbYx+1Y2Ov23qxo3GNQdbkIX+YfkEePo/XRwq5Ea9Kyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768382; c=relaxed/simple;
	bh=FSLqW76QMTKCqRLkfi82dXSDWEtmluESDLuGMMrd+AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+ljygDCUT/OXKQJ/eralOONTKmDbQMLKAFKh3ajBLAlrdoudLsLX+Rhh29y+c1dw7fU5g26SHRQPrGLvGXJ9ZbvD905i1TFAKwbd5YXA4T0oQx6zucsi4a0D+Aj98mZgSAN6/SloDFGmPg8ufB7eHeIE0HBlprHk8CXcMov5os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGTivhNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGTivhNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03FEC4CEF7;
	Tue, 17 Mar 2026 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768382;
	bh=FSLqW76QMTKCqRLkfi82dXSDWEtmluESDLuGMMrd+AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGTivhNdDA1Y3FA01kHdLkNBUr9160hQvfC8A15WbWckeUT5mru3X+Zn2MBRQi50S
	 RmYD7S08GLHasHD1T/n+IPDVWYCZ5U5QwH0O1OPUk2T3Kewi1dMobnCTMxhVpt0xuJ
	 yB6e4o01PUGq0+Xp01PewIZ5mljvPCgD7HtVQYpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 6.18 297/333] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Tue, 17 Mar 2026 17:35:26 +0100
Message-ID: <20260317163010.406648283@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Lukas Schmid <lukas.schmid@netcube.li>

commit 85e4614524dca6c0a43874f475a17de2b9725648 upstream.

The MCP4131 wiper address is shifted twice when preparing the SPI
command in mcp4131_write_raw().

The address is already shifted when assigned to the local variable
"address", but is then shifted again when written to data->buf[0].
This results in an incorrect command being sent to the device and
breaks wiper writes to the second channel.

Remove the second shift and use the pre-shifted address directly
when composing the SPI transfer.

Fixes: 22d199a53910 ("iio: potentiometer: add driver for Microchip MCP413X/414X/415X/416X/423X/424X/425X/426X")
Signed-off-by: Lukas Schmid <lukas.schmid@netcube.li>#
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/potentiometer/mcp4131.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/potentiometer/mcp4131.c
+++ b/drivers/iio/potentiometer/mcp4131.c
@@ -221,7 +221,7 @@ static int mcp4131_write_raw(struct iio_
 
 	mutex_lock(&data->lock);
 
-	data->buf[0] = address << MCP4131_WIPER_SHIFT;
+	data->buf[0] = address;
 	data->buf[0] |= MCP4131_WRITE | (val >> 8);
 	data->buf[1] = val & 0xFF; /* 8 bits here */
 


