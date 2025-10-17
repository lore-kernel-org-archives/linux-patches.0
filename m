Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641B9335061;
	Fri, 17 Oct 2025 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715620; cv=none; b=c7/GP0F4JMaXDDYZ5+9PXDkrx3Y86t7CsDbVI4cuzx80o4krd+NNvlcj8VD6HnywC/j20xVLq0fYWN/xqrSQjxZzAJVl6Uwj82mMIPYZ9oLU5TxDCwh+KzqB1n1WfaEj9rS3fw/LOOcJkJzO4xyktSUFlFP1dBcT3DqsNuaDux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715620; c=relaxed/simple;
	bh=C3DVdXiNWDXwuDYkHSMD4vcVuoxidNmj4f1fZi2OP1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLXkjFcPBNSCn4AVz44jAF2Hog0eWHgdGOm1Gi2ax4QoxkJWHQSgogbfzHrtDCSbftANJ2r/th6LeH+1n6WwmClUCjq/ML/KiCZKobN3XCOWCKjoWWs6XwJbJ4gjeF+4MrlHYO6z5s/ZYPp+A4ar8te5jwTzAihixdZcWXG38cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzl7PndO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzl7PndO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64D1C4CEE7;
	Fri, 17 Oct 2025 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715620;
	bh=C3DVdXiNWDXwuDYkHSMD4vcVuoxidNmj4f1fZi2OP1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzl7PndOlUUghDNpl8RRGbgQH5BTX4uv7NgV/o66xMwr2jGTgOM6lPJJazhPxT+gy
	 CFvS+viduB40mKx0xzx49XPXH+9eWOrH0Z8JPsLcWv2YgtrPkwMY1UHMUawsH6S8Ul
	 tIaODD1D5MWvon3R0HdsjQFZSHz0Ry6+c7rF6f/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rio Liu <rio@r26.me>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.17 280/371] PCI: Ensure relaxed tail alignment does not increase min_align
Date: Fri, 17 Oct 2025 16:54:15 +0200
Message-ID: <20251017145212.205318585@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 6e460c3d611009a1d1c2c1f61c96578284a14fba upstream.

When using relaxed tail alignment for the bridge window, pbus_size_mem()
also tries to minimize min_align, which can under certain scenarios end up
increasing min_align from that found by calculate_mem_align().

Ensure min_align is not increased by the relaxed tail alignment.

Eventually, it would be better to add calculate_relaxed_head_align()
similar to calculate_mem_align() which finds out what alignment can be used
for the head without introducing any gaps into the bridge window to give
flexibility on head address too. But that looks relatively complex so it
requires much more testing than fixing the immediate problem causing a
regression.

Fixes: 67f9085596ee ("PCI: Allow relaxed bridge window tail sizing for optional resources")
Reported-by: Rio Liu <rio@r26.me>
Closes: https://lore.kernel.org/all/o2bL8MtD_40-lf8GlslTw-AZpUPzm8nmfCnJKvS8RQ3NOzOW1uq1dVCEfRpUjJ2i7G2WjfQhk2IWZ7oGp-7G-jXN4qOdtnyOcjRR0PZWK5I=@r26.me/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Rio Liu <rio@r26.me>
Cc: stable@vger.kernel.org	# v6.15+
Link: https://patch.msgid.link/20250822123359.16305-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 7853ac6999e2..527f0479e983 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1169,6 +1169,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	resource_size_t children_add_size = 0;
 	resource_size_t children_add_align = 0;
 	resource_size_t add_align = 0;
+	resource_size_t relaxed_align;
 
 	if (!b_res)
 		return -ENOSPC;
@@ -1246,8 +1247,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	if (bus->self && size0 &&
 	    !pbus_upstream_space_available(bus, mask | IORESOURCE_PREFETCH, type,
 					   size0, min_align)) {
-		min_align = 1ULL << (max_order + __ffs(SZ_1M));
-		min_align = max(min_align, win_align);
+		relaxed_align = 1ULL << (max_order + __ffs(SZ_1M));
+		relaxed_align = max(relaxed_align, win_align);
+		min_align = min(min_align, relaxed_align);
 		size0 = calculate_memsize(size, min_size, 0, 0, resource_size(b_res), win_align);
 		pci_info(bus->self, "bridge window %pR to %pR requires relaxed alignment rules\n",
 			 b_res, &bus->busn_res);
@@ -1261,8 +1263,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 		if (bus->self && size1 &&
 		    !pbus_upstream_space_available(bus, mask | IORESOURCE_PREFETCH, type,
 						   size1, add_align)) {
-			min_align = 1ULL << (max_order + __ffs(SZ_1M));
-			min_align = max(min_align, win_align);
+			relaxed_align = 1ULL << (max_order + __ffs(SZ_1M));
+			relaxed_align = max(relaxed_align, win_align);
+			min_align = min(min_align, relaxed_align);
 			size1 = calculate_memsize(size, min_size, add_size, children_add_size,
 						  resource_size(b_res), win_align);
 			pci_info(bus->self,
-- 
2.51.0



