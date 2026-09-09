Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39080477984;
	Wed,  9 Sep 2026 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961685; cv=none; b=XGe+MoSMyzFDHKb0NaMPTixE+tLhz6t1/5hXip+usWNclnESocke3qRI27B5FhUUyqf7/M++3cYw/5bwAL+JPG3CAdzoSI1/f6zqCAjdiSZbQspjUdukthLsVsc9bwI4cPHzzLSAzBSVkaiRm5ncEdwfugk2deCj2UNf0pgrvsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961685; c=relaxed/simple;
	bh=eINbZn5Do9JaZb2EDDCIQZ1b3PvQUDNEyaBqFCNH7CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdVDsM0xsIyFMocwahU2B0XYCubb5zjd+U4HCx9hTO3KHmBUV41iY/jQN73klZFcrpDrlqs4prnFe6/cDuPGARvSPWoqPCxYpsBIFSY4bTnhH1tMj4QKu+5YZ26nYEdcgAb9cmvHa4j7fhKJ3+NcSZ7kP+UX7Jt4xIGbvcncQM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNrgufZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNrgufZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BC51F00A3A;
	Wed,  9 Sep 2026 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961684;
	bh=EN5qnHr+jQYDI52qMYR1RDZBeOgpdP2qZokqCUHqK40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNrgufZ3lrWvJg48SN1/DKwr+hlYM6dkOkZ2OZbTxNBb41D+dfCSwjdRmRvsXo8Sj
	 9voZfLWuv2tDSBfxDYrdvZXbf3AsexDKiQPU0Yt0SVGBNwhNM3zZt/rPYvxtwRkh6A
	 0OaxmikWYdaWXDkyr2l/s8H2jABw4xqEXuaUFTY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.2 032/556] usb: dwc3: google: Initialise probe properties with DWC3_DEFAULT_PROPERTIES
Date: Wed,  9 Sep 2026 15:35:12 +0200
Message-ID: <20260909134231.633300552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit 6b2a674fcc953378e5e750d47a888bbe51229de5 upstream.

dwc3_google_probe() zero initialises struct dwc3_probe_data and never
assigns its properties member. The unspecified state of gsbuscfg0_reqinfo
is encoded as DWC3_GSBUSCFG0_REQINFO_UNSPECIFIED (0xffffffff), not as
zero, so dwc3_get_software_properties() reads the zeroed field as a value
the glue explicitly requested:

	if (properties->gsbuscfg0_reqinfo !=
	    DWC3_GSBUSCFG0_REQINFO_UNSPECIFIED) {
		dwc->gsbuscfg0_reqinfo = properties->gsbuscfg0_reqinfo;
		return;
	}

Two things follow. dwc3_config_soc_bus() programs GSBUSCFG0.REQINFO with
zero on hardware that never asked for it, and the early return skips the
walk over the parent devices, so a swnode or device tree supplied
snps,gsbuscfg0-reqinfo would be ignored.

Assign DWC3_DEFAULT_PROPERTIES so the unset fields carry their unspecified
sentinels and the controller is left alone.

Fixes: 8995a37371bf ("usb: dwc3: Add Google Tensor SoC DWC3 glue driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260819182158.1351869-1-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-google.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-google.c
+++ b/drivers/usb/dwc3/dwc3-google.c
@@ -442,6 +442,7 @@ static int dwc3_google_probe(struct plat
 	probe_data.dwc = &google->dwc;
 	probe_data.res = res;
 	probe_data.ignore_clocks_and_resets = true;
+	probe_data.properties = DWC3_DEFAULT_PROPERTIES;
 	ret = dwc3_core_probe(&probe_data);
 	if (ret)  {
 		ret = dev_err_probe(dev, ret, "failed to register DWC3 Core\n");


