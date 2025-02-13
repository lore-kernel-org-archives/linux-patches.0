Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BC726B096;
	Thu, 13 Feb 2025 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460652; cv=none; b=qGaHsW7tG15f0Yt8hKsYOIRgwxRfAJ8a0kyVU9T9G0iNwIIssnP09lU0zwAyMI4zOO9IUC/6ITEWSD/uakPc2I7fNUPmXGH+ioINa8/ql09fC3bL5Sqelh+07Zw9IjUiwTJeDwpIBLBkSogUy0I19a62FAXoE363v03Uhr5HKuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460652; c=relaxed/simple;
	bh=1Mo/ZpwpBR3bMQ8YqUZVvWQf1gQERpfgL4xvR8KivP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrfSz/XNVzjqNQbQwpL/gLJ40Tw3lPCMZrKBYbnrroVKgh78MxaqpLh2+0BaBmDvDyk81Yyd6u4L71XosokyveMAVloaJGG6BU0OWM17N9lVK0VBR4b8/uqHMwCLw0f0OGV0nXHRSc15PaY1u2zQ8uh68FI34yn0gjEzMTjSrOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4c6Jysj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4c6Jysj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4303C4CEE4;
	Thu, 13 Feb 2025 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460652;
	bh=1Mo/ZpwpBR3bMQ8YqUZVvWQf1gQERpfgL4xvR8KivP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4c6Jysj2REuf0gwu/3UJfvTsiQwzbGhFvC8xQlyjJQew3+Q/zLLXz9JL66Zjw4Xo
	 9dKrLPvooiZkMYGDOa5J1fiX5/6Gy4jV50fU9DMaXVvgqzJgrJePltKTPjpertA8WA
	 1vQWa4YUpxjzapk5JfsaSp/RHlghkXcph+w3kvc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 142/273] usbnet: ipheth: document scope of NCM implementation
Date: Thu, 13 Feb 2025 15:28:34 +0100
Message-ID: <20250213142412.947045636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Foster Snowhill <forst@pen.gy>

commit be154b598fa54136e2be17d6dd13c8a8bc0078ce upstream.

Clarify that the "NCM" implementation in `ipheth` is very limited, as
iOS devices aren't compatible with the CDC NCM specification in regular
tethering mode.

For a standards-compliant implementation, one shall turn to
the `cdc_ncm` module.

Cc: stable@vger.kernel.org # 6.5.x
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 5347cd7e295b..a19789b57190 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -218,6 +218,14 @@ static int ipheth_rcvbulk_callback_legacy(struct urb *urb)
 	return ipheth_consume_skb(buf, len, dev);
 }
 
+/* In "NCM mode", the iOS device encapsulates RX (phone->computer) traffic
+ * in NCM Transfer Blocks (similarly to CDC NCM). However, unlike reverse
+ * tethering (handled by the `cdc_ncm` driver), regular tethering is not
+ * compliant with the CDC NCM spec, as the device is missing the necessary
+ * descriptors, and TX (computer->phone) traffic is not encapsulated
+ * at all. Thus `ipheth` implements a very limited subset of the spec with
+ * the sole purpose of parsing RX URBs.
+ */
 static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
 {
 	struct usb_cdc_ncm_nth16 *ncmh;
-- 
2.48.1



