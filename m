Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFFF3375D9;
	Tue, 26 Aug 2025 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214730; cv=none; b=nh3j4OP/NraEd7Hk82Y8kw7IpXbe1extVNNcoIEqWJRoE899qNI6IKmLwPC/Ess3W7thPDAOjXp+qSrKlIc7sa46euJhFPF2OIcIikR350C9uo0bjhCevyhf6bf1L1Pj9zu2AcalZJ8Od7k7qSk5Kn1CpObbTg4RTh32EfHG80o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214730; c=relaxed/simple;
	bh=zclSNOYDwNQ2rxlynHAR8HliFpJxwOoinKoWyh5Rzsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyRM5d+AJ5hk8mY2ka+/xy05suKWTGCy1SjKTUodjyMLM7I6UqS7DxWlqO/6CH1N/uHFuAfTBHyBrrmhQ72q4/2Q1J9VYgiE865ZDwTlIJN0QLoR1S0yzVHJPLw6X5MjqjKcIGN7TbEcHXfHwGwTvbl4d4tYZhRYfV5kDE+5akw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fad3fOoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fad3fOoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D0C4CEF1;
	Tue, 26 Aug 2025 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214730;
	bh=zclSNOYDwNQ2rxlynHAR8HliFpJxwOoinKoWyh5Rzsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fad3fOoe5MxQaVGKiwa0GLMczLrOFUXMoJpa7A1+E2V885i7AtdbairRQuhoIgtD/
	 6+/3oJzKWxOgRY0ecB80lmkOI+kAp4mKpiyVbsY09WIpxmQCY+ZNL2Q2qvIGfqCG2a
	 ykCp3TZhbR/ElO0ZIoyh+PRLFc+WYhDa5ETYRb1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 246/482] usb: core: config: Prevent OOB read in SS endpoint companion parsing
Date: Tue, 26 Aug 2025 13:08:19 +0200
Message-ID: <20250826110936.846718814@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


