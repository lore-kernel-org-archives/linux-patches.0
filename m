Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC41226B097;
	Thu, 13 Feb 2025 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459447; cv=none; b=BKjw7UctYovyK38QD+OwwR1Yz2m9gfbRR9GdGzZeZWSy/1jnSI7vWuahPBqNYEAC0fnyf0iGQ3al9plJPU8eY9G+eJU6+eXRYDMRwMdXXY42a71fXsfvbEkchFXjqVAILdErVT/91I8fGbNB2AKsAKIhqSAE2GNlBahzyRDrcN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459447; c=relaxed/simple;
	bh=6CLcnrxM+PEogAm5McKX8Hqeq0gyHlOj7SJD3dS8T5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPGlhiTsMNC260Dzi6YFD9bvp13xhI+//y4Dj8B/WQTnUGWej/0iXob8EZ4dp2uPJCXY9GMKN1eMXD0RK5UH6S/LOLcaD8M27JBN1n9YBUHfDI/lIYH1LIBvA1VNVOUViWuXyF36bDvYs3pDsuvO6Z52zlrxV8fMIM3XIPcPIgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjCw+Hz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjCw+Hz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2211FC4CEE5;
	Thu, 13 Feb 2025 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459447;
	bh=6CLcnrxM+PEogAm5McKX8Hqeq0gyHlOj7SJD3dS8T5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjCw+Hz9n8H8A6cy9Z27sh8j/k2PhGqZAuWs2BinM5kJYXg1Z1On9tNUrnaIgy14b
	 /kA8dwUTaHxmZ7dSBZ/OA0scTuJ0YNL3oa0A5HI5aD3UdUy6NJ6CirbNVUunnYCw9v
	 e9hQWjPIvneFQ+AyzlTgdyHYNwtMLaCmePktXuBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 240/443] usbnet: ipheth: document scope of NCM implementation
Date: Thu, 13 Feb 2025 15:26:45 +0100
Message-ID: <20250213142449.877325332@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/usb/ipheth.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -218,6 +218,14 @@ static int ipheth_rcvbulk_callback_legac
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


