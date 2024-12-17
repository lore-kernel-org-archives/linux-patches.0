Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E53F1F76A1;
	Tue, 17 Dec 2024 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455984; cv=none; b=szAqy7DoWu1VOKb2gaJPt9PVQOcx5nVtavJXK554JrdkUgy1Lj4wp4A+qEZ4SPlTC9JTb3XEgmOyvWstjcpDtvt4l+ICdABCwVIRdJq35KoM96xxK8EpaHlOT4ybvmQ3w45WRhykExL/vcTy4SeZhWeDzMrzDl71ZgJMcIpAFaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455984; c=relaxed/simple;
	bh=A+8b1x9nWRv5Zg8NTr5aRbtu10/QfqdgdqJbI5AIf6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSuX1IY9LUMwrHUuco7IueQPmdj0lzqTLccpEnd40ie9b4arST1doc51SSALjDLZO5A8J4MMlTdovUXbyfyE84kKh7h9u3VccWDQImR9Dd1+/keS1Vx+T6a/c8c1GTVg5gRZHYO/zpX5/Z90Mc4OOPB4BKARlpBVb0f25rHHU8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZm78Qc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZm78Qc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4B5C4CED7;
	Tue, 17 Dec 2024 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455984;
	bh=A+8b1x9nWRv5Zg8NTr5aRbtu10/QfqdgdqJbI5AIf6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZm78Qc7XiQiSWGt4isvEUh0DhDDA9POUfb9RvunJnMXLi0mUQovMMg2PssO84jy1
	 VmDOzLlxcpTRWC9IJtgyzxKTArUjs2AImKuQ4/7S5ZmbbClUDuHp0gJprSm+FG/mQZ
	 h8u/QYg16Z70uQKlCFgChawfFBPFUcvm1rMILYp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Frager <neal.frager@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.6 021/109] usb: dwc3: xilinx: make sure pipe clock is deselected in usb2 only mode
Date: Tue, 17 Dec 2024 18:07:05 +0100
Message-ID: <20241217170534.250374414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,8 +121,11 @@ static int dwc3_xlnx_init_zynqmp(struct
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


