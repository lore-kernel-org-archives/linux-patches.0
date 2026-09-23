Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824795372DE;
	Wed, 23 Sep 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174965; cv=none; b=n8gr7mdUGfM8pajPKh/gG0fGZMzF0JIeR1p0HMoXiydj5ylVwxUZwu3okuZcvSM12IiX9YJbNaIctLI0uTaRnLzG8abawu7kXT+f1CS+y3AKl3Vn8R7jp03VzRBraw7k5vzWjUHUZXmY9LRNk0CUyWT1MscHpvyG/l7UqO2o54o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174965; c=relaxed/simple;
	bh=z9rsGtZ8naP7BNsIj4Gmy8R4pGxfDkiZSLDzYjdB6/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/I+6dJUegtMfg2S1AzAqS0EcjuFHjpo5lb69xPWc2ZUjKHhT6+MPz3agxGzWuzGpiSL1UEoxxAjPWShSgHnUtnpgLtWF5GdoHSsuW8pjTawwij0RWMs56x6xQzK6dvoEZebcunCBukui6Kg5fATjgU4+cfY3r9J1i3Yd2g3TVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiS3PCJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiS3PCJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4FB1F000FF;
	Wed, 23 Sep 2026 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174964;
	bh=0Z0WDYi+kGlbo1H6er5EgD7xQhlDQPvK4sdzsgxbGNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiS3PCJO9dWRewVOMcyS9Go1UoCiUwlKGzv5yq2yxRB5Gw/tqPAyiLFbRZuppb10b
	 Lkr8gtCaXsHVvcc/lShJ5ztaEog0w8+C2zEWOdHlB86AMDJdVX7lPUfsha/cb9dikw
	 XtPznV5MhO/O6eANCdaZYEgOc2F8gajYIoC2lHaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 244/398] net: lan743x: fix RX checksum use-after-free
Date: Wed, 23 Sep 2026 16:05:18 +0200
Message-ID: <20260923140649.736398025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Amirkan <markdamirkan@gmail.com>

commit a9ce4053dc945c5372dedba5017ee675b30dc0c5 upstream.

lan743x_rx_process_buffer() adds each non-first receive buffer to the
head skb's frag_list.  On the last descriptor, lan743x_rx_trim_skb()
linearizes the head and frees the fragment skb metadata.

The checksum-success path then writes ip_summed through the local skb
pointer, which still points to the final fragment.  This causes a
use-after-free write when a packet spans more than one receive buffer.

Set ip_summed on the surviving head skb instead.  Multi-buffer receive
can occur after a live MTU increase because existing ring entries keep
their old buffer size until they are replenished.

A KUnit test invoking lan743x_rx_process_buffer() with a two-buffer
packet produced a one-byte KASAN use-after-free write before this change.
The same test passed after the change.  The driver object also builds
with W=1.  This was not tested on physical LAN743x hardware.

Fixes: cd6910501cfd ("net: lan743x: Add support for Rx IP & TCP checksum offload")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260913-b4-send-lan743x-uaf-v1-1-73d563d08ba9@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2588,7 +2588,7 @@ process_extension:
 							rx->adapter->netdev);
 		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
 			if (!is_ice && !is_tce && !is_icsm)
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				rx->skb_head->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 		netdev_dbg(netdev, "sending %d byte frame to OS",
 			   rx->skb_head->len);


