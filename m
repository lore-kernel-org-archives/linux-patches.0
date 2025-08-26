Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E9C352060;
	Tue, 26 Aug 2025 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218044; cv=none; b=DKBF8/fqx8k8msv7q1JJJ7k8f5MDmcB3OHoVtHo82HF3fbAQnAqSo6r//Qgavb8P6ztTRAohx59Y+H0EGp5x/9IO2ARaSeyvcg88cW2LsAoJUmHE3hJ9S27gA5xHcydEh9vD7mCSOLQAsga5JG7cVF4gJR6L8grtcFZ1HArH158=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218044; c=relaxed/simple;
	bh=nPquoF8xUsXDPt0JpTMB021AuModGs1/g8pQpYBQuf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIngwiWhaw6BuWwttivfvjIXlfO0KWYwKw1R8taYrwxIFFhHMBYnQgJLYmKmzEw2PUEOCEFjVz7b2M8Th8gLYE0IwAPaU9h5bI8nzEHl3Eoh9vOeTMcHoY8apvw/Q7eVc99t1lOeou+fdDPUfE72Ae2RUJ7WTabZlyX1VGVRr4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncRmq0WA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncRmq0WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBBEC4CEF1;
	Tue, 26 Aug 2025 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218044;
	bh=nPquoF8xUsXDPt0JpTMB021AuModGs1/g8pQpYBQuf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncRmq0WAp+F9Spla8Gerwrm7KQRwIeSB0vP8785DlAbdcJG6YkM5nzvCEs+FELp49
	 HjNg1TS49tltewkmdRWoqZycXaBh8+eu2KkHeU27gz+uGrXmwBNBOaplUjHPKbm7va
	 PtcEET8pGkeOO6D0y4NNTuia+yzOS4RVPpTkOl7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 341/523] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Tue, 26 Aug 2025 13:09:11 +0200
Message-ID: <20250826110932.881332957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


