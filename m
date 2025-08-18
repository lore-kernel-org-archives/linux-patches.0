Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B428B2E22B0;
	Mon, 18 Aug 2025 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526269; cv=none; b=KvcZo5rWF1ck95aN46a2yaewOT0e2JPdDr9JeMn7b0tHjEbZCG3xzSFzYSEXb6jFBff4Xnw6XsVobKRX8FC53gPEa77OObbv3+cFlegiLoqRa2uFoPk9rKYg4RlfDlNFR3S2RyhXM2yROP7SQqQK9gMdi/vPSykv6q36Hp+LCQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526269; c=relaxed/simple;
	bh=jFfADVRw6EeStPOFMmEOezp5AMuOAnP6mOesNiYrZ+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqQIxuO0l45c9NKZs+SKFb8ZIAl2FM0vjnJHZ685bUYbdQuBad1FM2ZDgGq6m8odBn43a8FIJc2zKvwliKEAZ8DD9i6L75qZZZDuMmMgDtMwPj9hXKq6Uf2R50kV8C4+RrsWZevL84nUrcpruCzHjkx1zya/NSpywSGzL8kAuLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLTcviCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLTcviCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CBFC4CEEB;
	Mon, 18 Aug 2025 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526269;
	bh=jFfADVRw6EeStPOFMmEOezp5AMuOAnP6mOesNiYrZ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLTcviCgjxB3zSHwmj03zcIG85SJc2TzsCbyeoe7QpSMW8CAnY1hzYfEmrXLjjEv2
	 tnfmejNBkRZ38+qPtW1jaV6OMc8qrruoh/U0wU4FQhLvD71pveNXQMs7GpYwVVMRM5
	 hDVGzWhjHAggLNRjpJlgSIFCK0/G3jyw+2cel2no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.16 505/570] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Mon, 18 Aug 2025 14:48:12 +0200
Message-ID: <20250818124525.311369232@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinyu Liu <katieeliu@tencent.com>

commit cf16f408364efd8a68f39011a3b073c83a03612d upstream.

usb_parse_ss_endpoint_companion() checks descriptor type before length,
enabling a potentially odd read outside of the buffer size.

Fix this up by checking the size first before looking at any of the
fields in the descriptor.

Signed-off-by: Xinyu Liu <katieeliu@tencent.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -107,8 +107,14 @@ static void usb_parse_ss_endpoint_compan
 	 */
 	desc = (struct usb_ss_ep_comp_descriptor *) buffer;
 
-	if (desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP ||
-			size < USB_DT_SS_EP_COMP_SIZE) {
+	if (size < USB_DT_SS_EP_COMP_SIZE) {
+		dev_notice(ddev,
+			   "invalid SuperSpeed endpoint companion descriptor "
+			   "of length %d, skipping\n", size);
+		return;
+	}
+
+	if (desc->bDescriptorType != USB_DT_SS_ENDPOINT_COMP) {
 		dev_notice(ddev, "No SuperSpeed endpoint companion for config %d "
 				" interface %d altsetting %d ep %d: "
 				"using minimum values\n",


