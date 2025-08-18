Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C377B320CCA;
	Mon, 18 Aug 2025 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524383; cv=none; b=RA6vnZ9658UWSDc0lj8UcSiXf6Juqsx/pUn5H1llBwHLVGiL8bcr1qJj5/rNG9nYsNMkxfGpPsapES9z/Dthy08d2z7C9XVCyWnls5u9lri3mKALea9hXjG2V7VytdqVw8rEQTLmOHlbsZLHxErsCcBlQsAiL6oiEM15jdGBDLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524383; c=relaxed/simple;
	bh=lD/Sdhhm70yXgoXMzZv71x9j1Px/P1srssI/I/oRx5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNtHIIY1HZdA6u00vfh0k4CuSl99r19jXsmYQ+d26p79Joe4IvWQe8oIY8Ophua5dLwcANElMv9bCWHoUOuZ0FTJViirX+ilsBdIiQBBOT27Wo9lMMj1V/w1JpbWMlFwBo8RGE8avw4tgvpEjAujEo3jjHmZNmIzSlocwjZIzm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuRCyxir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuRCyxir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9C3C4CEF1;
	Mon, 18 Aug 2025 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524383;
	bh=lD/Sdhhm70yXgoXMzZv71x9j1Px/P1srssI/I/oRx5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuRCyxirl4yMYT2OxwNnAwkSTHNnPPJVj+dcn8j5s9v1hls/mWOgy/6BdATkwlJMf
	 7VSl9k+WwBuIrSCYwAoPG9Rxv7B6Y8P3m34n2jA6eKIPqpfea6b7RF9xKX8xxqTDYB
	 Vcuyf6nGriiTovDIBkMbgCINpoa11fYAMNv8KTpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.15 455/515] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Mon, 18 Aug 2025 14:47:21 +0200
Message-ID: <20250818124515.935176046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


