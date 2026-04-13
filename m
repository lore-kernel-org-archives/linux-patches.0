Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA2E2EBBA1;
	Mon, 13 Apr 2026 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096496; cv=none; b=Z7b8TYdQ6VJ6N6Qgpidf2HmvAfzDJV1rp5wEIPmH2a50/59VQUPGkqNmxcBC6BqNcOZWDMrqi3ETKOv/VS1prbgjSBLynp4NR4SD9w5Iu/mu85Vwe2fafBnKqay6GwjcLDuLvyyVYklZIwW5agp3tfhGc8/DhW9nN+H8R5L8Ejw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096496; c=relaxed/simple;
	bh=BEJYDeoW8vN0gTbV9xTG1KjJKSbS83YV2LFunfnX/eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0h4UrgiC3PUEis/We6scUVzLSDZCAi8AtboYvlwkQosupSSXFdLCOu2+9kNlA6jmXcQ5iDN/EYyQ/egRDus+zWByuqO4UkeceImU/2DGxFH5qJsMBHlxpPb2LuJMYpmeo+95l7VgFkWmhPmHNHBjqqpViL2Za5y1nGPDMjgHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIYllkh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIYllkh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6EEC2BCAF;
	Mon, 13 Apr 2026 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096495;
	bh=BEJYDeoW8vN0gTbV9xTG1KjJKSbS83YV2LFunfnX/eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIYllkh5OnDemvCcTddWumOOgo4D8ENwxpozqohfzAFrkhIHt6ZLCGKsQ1wcgeJiw
	 XzZlELgxDMQuGmtLtrkVUMazum0sjVR2zh1OXLHaetHgWBjw89TstDqzMzm0Tqy82D
	 tSfsATyVcoi++3JNOqqvJ/ZV6FrsQJ1Q8mLdlRwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.18 33/83] arm64: dts: renesas: sparrow-hawk: Reserve first 128 MiB of DRAM
Date: Mon, 13 Apr 2026 18:00:01 +0200
Message-ID: <20260413155732.257560357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit ed8444006df9863ffa682e315352c44a49d9f4cb upstream.

Mark the first 128 MiB of DRAM as reserved. The first 128 MiB of DRAM
may optionally be used by TFA and other firmware for its own purposes,
and in such case, Linux must not use this memory.

On this platform, U-Boot runs in EL3 and starts TFA BL31 and Linux from
a single combined fitImage. U-Boot has full access to all memory in the
0x40000000..0xbfffffff range, as well memory in the memory banks in the
64-bit address ranges, and therefore U-Boot patches this full complete
view of platform memory layout into the DT that is passed to the next
stage.

The next stage is TFA BL31 and then the Linux kernel. The TFA BL31 does
not modify the DT passed from U-Boot to TFA BL31 and then to Linux with
any new reserved-memory {} node to reserve memory areas used by the TFA
BL31 to prevent the next stage from using those areas, which lets Linux
to use all of the available DRAM as described in the DT that was passed
in by U-Boot, including the areas that are newly utilized by TFA BL31.

In case of high DRAM utilization, for example in case of four instances
of "memtester 3900M" running in parallel, unless the memory used by TFA
BL31 is properly reserved, Linux may use and corrupt the memory used by
TFA BL31, which would often lead to system becoming unresponsive.

Until TFA BL31 can properly fill its own reserved-memory node into the
DT, and to assure older versions of TFA BL31 do not cause problems, add
explicitly reserved-memory {} node which prevents Linux from using the
first 128 MiB of DRAM.

Note that TFA BL31 can be adjusted to use different memory areas, this
newly added reserved-memory {} node follows longer-term practice on the
R-Car SoCs where the first 128 MiB of DRAM is reserved for firmware use.
In case user does modify TFA BL31 to use different memory ranges, they
must either use a future version of TFA BL31 which properly patches a
reserved-memory {} node into the DT, or they must adjust the address
ranges of this reserved-memory {} node accordingly.

Fixes: a719915e76f2 ("arm64: dts: renesas: r8a779g3: Add Retronix R-Car V4H Sparrow Hawk board support")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260324143342.17872-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
@@ -118,6 +118,17 @@
 		reg = <0x6 0x00000000 0x1 0x00000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		tfa@40000000 {
+			reg = <0x0 0x40000000 0x0 0x8000000>;
+			no-map;
+		};
+	};
+
 	/* Page 27 / DSI to Display */
 	dp-con {
 		compatible = "dp-connector";


