Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E351F757B;
	Tue, 17 Dec 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455856; cv=none; b=mmdaAMKTJ0tzhTDXPQt7X5v2fWuFngP1i8hm4Jw8/sT7unyV4zJ/UrhYYTaVvcfaBZfOtbNm1/z4FS2ICVaIGovvDD3ov8+74THvm6CZCEUmNSJNoj9WAPI9I3yS3UxgIcwJd3Eojq4pkDZU8hHUnnRLd6fQ0bUEjD8hJ++7FBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455856; c=relaxed/simple;
	bh=9kcD7CdzqRwENBPKPLpVxc+/sXVvg6wVzhB2jFfzVKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGA8/eu54CLGXY3hb5LGOOZ7IJNgrhV+SXcxaAOqI95EKCPUsdDIgyT6fXRmHnJfrsa6djGZW04Vav41XnQk+QLVF+0IqiSOH/hHiuJSjlZQLOx93BsW+d1Fj3vT/0b0SCvvhR0Hg+O6qlLOEKWWFO/OKspHDaUcBNlBL9kyBNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2BLVCrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2BLVCrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B5C4CED3;
	Tue, 17 Dec 2024 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455856;
	bh=9kcD7CdzqRwENBPKPLpVxc+/sXVvg6wVzhB2jFfzVKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2BLVCrm6Nf/kzJ9sgpei2g2B+t1RDjN029lZAFGkesSg7ocHuo6Oyf3PuS8jPT7x
	 tf86QAwOjcZxg1QDENu3nPz4GANeEKdcgIwanpPRfJ+NPqiyf8M4ESbJZurJyOapLq
	 bzOvKJy9GO4qBkNtDilG9SiX4yZbe3A7Aci6zR6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Frager <neal.frager@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.1 15/76] usb: dwc3: xilinx: make sure pipe clock is deselected in usb2 only mode
Date: Tue, 17 Dec 2024 18:06:55 +0100
Message-ID: <20241217170526.883498744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Frager <neal.frager@amd.com>

commit a48f744bef9ee74814a9eccb030b02223e48c76c upstream.

When the USB3 PHY is not defined in the Linux device tree, there could
still be a case where there is a USB3 PHY active on the board and enabled
by the first stage bootloader. If serdes clock is being used then the USB
will fail to enumerate devices in 2.0 only mode.

To solve this, make sure that the PIPE clock is deselected whenever the
USB3 PHY is not defined and guarantees that the USB2 only mode will work
in all cases.

Fixes: 9678f3361afc ("usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode")
Cc: stable@vger.kernel.org
Signed-off-by: Neal Frager <neal.frager@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/1733163111-1414816-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -122,8 +122,11 @@ static int dwc3_xlnx_init_zynqmp(struct
 	 * in use but the usb3-phy entry is missing from the device tree.
 	 * Therefore, skip these operations in this case.
 	 */
-	if (!priv_data->usb3_phy)
+	if (!priv_data->usb3_phy) {
+		/* Deselect the PIPE Clock Select bit in FPD PIPE Clock register */
+		writel(PIPE_CLK_DESELECT, priv_data->regs + XLNX_USB_FPD_PIPE_CLK);
 		goto skip_usb3_phy;
+	}
 
 	crst = devm_reset_control_get_exclusive(dev, "usb_crst");
 	if (IS_ERR(crst)) {


