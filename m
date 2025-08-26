Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB17341ABD;
	Tue, 26 Aug 2025 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216601; cv=none; b=lllVYTMYeaAGVSrr9csOqCK8/bde2A7nS5stkB6Pb4PqVVyA/c3qhdoAlkkLkbWdsybHC6Dclc8RZQd0LyMo9Va1lOUFQcfLgVSPWYAGVRpX9i2VWECLPNOzspSPdXRSAD0Lnwh5o7B7Prir37jCJSycWLRqNX/iAMWZny/RQLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216601; c=relaxed/simple;
	bh=zUWVstwPpLdGYzWgcytuyTpbVjyrQaYahBwficoCETU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYFen4NRn9VbeaDiVnFGZQdzr9jeedmmSI4Qiljj4YcBE2lbikiWK+z0JCS2gVFCqvOfLZSRW5+k942lFFPpbDS19OOF1Ux1sCDzG0XYWvxU0Zk1LMU2GgQD0YqMMfTIFd7U0My3Wuim+2AwG58WCzhmloh9XAtGVDQcN8xETEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIEZyXVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIEZyXVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D0BC4CEF1;
	Tue, 26 Aug 2025 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216600;
	bh=zUWVstwPpLdGYzWgcytuyTpbVjyrQaYahBwficoCETU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIEZyXVlirYfmdsuze2Tzoh5/gIppWSRLB4u41lqdOh01RczPvGI9OSDyjmmYpFZR
	 jUJJ/lsJMBnhkW0SEOLRa6maC/6nTab+Q+C3EhtfBnUL5UhEV7x4Z4WhFjkDjt03mo
	 PQfVHU6Kpqq+QyHC0VQg/Lomt1VEqOwvBuzi8dtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 441/644] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Tue, 26 Aug 2025 13:08:52 +0200
Message-ID: <20250826110957.394823414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


