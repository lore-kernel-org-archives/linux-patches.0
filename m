Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F0447A0DD;
	Wed, 30 Sep 2026 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785998; cv=none; b=OWu7VAETEt3xJbrd8Rtaq5kUEnXZhHEAS/pR4sJozgaBOUV21etK8/n/lMmepqgNCqMgDMeb8m/U+j0uMozmnS6S9XQpPSGDEo6TpcHnEFt9l3/giXvzcKb/fMZcbNNzhiZAJsn9USb4Y+r9LQeyfQ+djrHRXVC4azNiRUlSxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785998; c=relaxed/simple;
	bh=EDFatmvhQ0O1bD11/8r5SwLU1UY5M5IcSkE+hBpLnx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUP9fDzvY9fP9I/LzFwZo+H6hCexnkYK9DOXg5p+8DAKjjcVKifRWJmxs935/C4M8B70XpFd3gSdveT0asxSfDXfJg03yU1hoks7goDXlpFUr8ji7akRHaJVzj7XPWaUVovGfGWqpwjs0Kw1MiPeVr6PFoVjpXwgiGoiFGEBwac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJq4GsKk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJq4GsKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE291F000FF;
	Wed, 30 Sep 2026 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785996;
	bh=OBBBelnPYqQPm6X3TSQgZ1MFdl0xXdLoyD3VfX4tQv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJq4GsKk2GJZ/NbVN6kex9k3gNvWAAw8wdsOprhDfmcT1SbXEFEQ8Zocs9tSd7XgE
	 5vfU9BRDF76ovPTgPCM1PJnGOwWuKoLi6sw7gIeWo2gtxjhNbqd5Os2H/lt5r7HYIG
	 Iut+7Wwpd7X+dy4oSjGGmUJ6hjIER0Oc6OgmBIAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.1 706/982] arm64: dts: renesas: r8a779f0: Set UFS lane count
Date: Wed, 30 Sep 2026 17:24:02 +0200
Message-ID: <20260930152431.923029691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 8dc2615d5702059b2b71fca6f93c0d7d10ae54cb upstream.

Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
during link"), the following error is observed on R-Car S4:

    ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
    ufshcd-renesas e6860000.ufs: link startup failed -67
    ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
    ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67

R-Car S4 has one UFS lane per direction, as described in section 152.1
of its hardware manual.  Without lanes-per-direction, the UFS platform
driver defaults to two lanes.

Previously, the core used PA_CONNECTEDRXDATALANES and
PA_CONNECTEDTXDATALANES to configure the link without checking them
against lanes-per-direction, so the missing property did not prevent
initialization.

Explicitly set lanes-per-direction to 1, now that the validation is in
place.

Fixes: 5235d551779d ("arm64: dts: renesas: r8a779f0: Add UFS node")
Cc: stable@vger.kernel.org # 7.2+
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260911073058.253000-1-den@valinux.co.jp
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -646,6 +646,7 @@
 			clocks = <&cpg CPG_MOD 1514>, <&ufs30_clk>;
 			clock-names = "fck", "ref_clk";
 			freq-table-hz = <200000000 200000000>, <38400000 38400000>;
+			lanes-per-direction = <1>;
 			power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
 			resets = <&cpg 1514>;
 			status = "disabled";


