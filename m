Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F233832ED45;
	Mon, 27 Oct 2025 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591263; cv=none; b=taYe/A4tSfje+My3xAdP2ZIZtnpSnta3J7KlQTtxBoVrgitquvvqBfHJjTTb+7JiWcSJhxGy7GscodsMTHC9tdQnx0ukv2MOC8+8Vw1z+/GxYNdn1wqGCZVRdNDxLjQrOEQVllF2yuHV+Rtf/B0Lse/Yf4LUZscw/R6mxwUpNXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591263; c=relaxed/simple;
	bh=4RRpqmgeayvP6US3HlBo5FbkXDdvG7+vlYm0BHc95a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC8jAl3fQKLeOtZ+ItrqDWpkc1BHb+f+VY4vynfJ8aU3H5vj/w2WQx4ab9RxoxfH2aMVQd0+cTYk33CCjJVXlFLfIKIPWJeAPezja1QJRepyH9X/1LCPnTtwdSubOXgNeYjLaHLYB52CTR4YyT7X5ENTLHJp+rjrRCvi4GmwamE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En28RIgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En28RIgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D29C4CEF1;
	Mon, 27 Oct 2025 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591262;
	bh=4RRpqmgeayvP6US3HlBo5FbkXDdvG7+vlYm0BHc95a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=En28RIgAKsh6A9lrvgCAEHEDt03BaebOeZgdFf6kwSaoXdLX8zIWSSpqDmcAGoQ/L
	 zjQn1feyc9qp86QyAdIt4O1xCLnbPCZk3JiEurFQ73dhZnHtXMUOpy3du9//itYCHb
	 pgqVZ22ypW9k5t+V9QIrjBwjTfSPOzwzVgf2J5TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.10 130/332] ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init
Date: Mon, 27 Oct 2025 19:33:03 +0100
Message-ID: <20251027183528.064924748@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 74139a64e8cedb6d971c78d5d17384efeced1725 upstream.

Add missing of_node_put() calls to release
device node references obtained via of_parse_phandle().

Fixes: 06ee7a950b6a ("ARM: OMAP2+: pm33xx-core: Add cpuidle_ops for am335x/am437x")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250902075943.2408832-1-linmq006@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/pm33xx-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/pm33xx-core.c
+++ b/arch/arm/mach-omap2/pm33xx-core.c
@@ -393,12 +393,15 @@ static int __init amx3_idle_init(struct
 		if (!state_node)
 			break;
 
-		if (!of_device_is_available(state_node))
+		if (!of_device_is_available(state_node)) {
+			of_node_put(state_node);
 			continue;
+		}
 
 		if (i == CPUIDLE_STATE_MAX) {
 			pr_warn("%s: cpuidle states reached max possible\n",
 				__func__);
+			of_node_put(state_node);
 			break;
 		}
 
@@ -408,6 +411,7 @@ static int __init amx3_idle_init(struct
 			states[state_count].wfi_flags |= WFI_FLAG_WAKE_M3 |
 							 WFI_FLAG_FLUSH_CACHE;
 
+		of_node_put(state_node);
 		state_count++;
 	}
 


