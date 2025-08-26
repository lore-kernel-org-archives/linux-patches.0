Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AB918DB0D;
	Tue, 26 Aug 2025 13:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213317; cv=none; b=DcFJGKLYTx5czgj0xAg+QlZCYrOLSgVheu4hCbAs3Q1R/2Ga7nF6aVW8v8Iz1yWhbceYB8plVgJM3ptl2ph0yv6eif0/2XoHq2nXrQ8HMsEv9Yh8kMVJ64smtfb7t+pGYDY3kvZeOFTfwAgLzdJjW074Dw13ejB1xq+N8BDF8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213317; c=relaxed/simple;
	bh=GCdWiomQ+vbw4toiZcsEMjecAzW5siMUTN0JzfEo6HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hitOSQo0rEtpcuaL6Ab1M7YHAAOsiDlkJ0ps1pISKMZ9MXflT79Lblf/PuogoRaMa58FjulmQQWlN/oBBGhNoBZ91sS3qwjw/wcEdk9kGHCyRny3UPgCKqnNSVDEFu8HpLSDx9I1njq3bfHa46SGQlndL2hp28iD8HFZDrMVoCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfQau1bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfQau1bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BE3C4CEF1;
	Tue, 26 Aug 2025 13:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213317;
	bh=GCdWiomQ+vbw4toiZcsEMjecAzW5siMUTN0JzfEo6HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfQau1bkXRzzo4eCd2rO/bkk7+LtS4PBGyToVXUuN1UGfrURA65NTq2TPygScmXG7
	 hIzPTX9TH6dcQCfqMY/kEsYKzRi4sUYP2XbhKUruwZas36E1o4ujFxTH7gSULgzpl2
	 XIzbNyzpfZXBKI4cslEmQ0YNIL0HdOJENDUJDxGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 303/587] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Tue, 26 Aug 2025 13:07:32 +0200
Message-ID: <20250826111000.631748029@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
@@ -81,8 +81,14 @@ static void usb_parse_ss_endpoint_compan
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


