Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66513218CB;
	Mon, 18 Aug 2025 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522671; cv=none; b=bMsPXy9Hn5yHsoJCK3mpjkT3bLkB5GlhvupPcRv4ylvKQX2CdOj8AqLS9y5LlVGt1ltpFMf8oSBb3BbL8aXVSjh+mPQnDUOYMuB1hDsoGmrvk2An3ux9mlYkGs6ILFv3B2R3giQyOblL+qhIzr3/L/YhlCXNuoNWqvckcNvKlVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522671; c=relaxed/simple;
	bh=EQIP4gmv6Igu7VWVChjMvIR0bPWtah+htM0hegIZK54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKCXzYQ4L3/TGZdC3if2rj+lz6sIb1U1DZTI83DCOSnKYrWe5kNz6itDbNQfZE8xjzGlNr0nzyXrwSnCTTODIbf3L8UyHbuZvt75Re6FlA5tawxihIzz7YNreZwQTumaOoPPmC0ywzG/SkX+xa/L/XF+XJF/dfNwr7BlpjzdqvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrgNoVYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrgNoVYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC11C4CEEB;
	Mon, 18 Aug 2025 13:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522671;
	bh=EQIP4gmv6Igu7VWVChjMvIR0bPWtah+htM0hegIZK54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrgNoVYzS4FwYf2pbEc7ERdxkzbqbQC6tQRQ3FvBBpOKZ96h7hkSALbFy1k0DchfX
	 C+HBUYHOh5pVBwsOLZQqPIR013e03aKTmUvrCN9c2krAbXWPMyLPNjXVeWshDoHig4
	 jm5zAA6AiG1IyUIq2Xwg5mh+rM0XwmdsenD7kNkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 385/444] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Mon, 18 Aug 2025 14:46:51 +0200
Message-ID: <20250818124503.336035316@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


