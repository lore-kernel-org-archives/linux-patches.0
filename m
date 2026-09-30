Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967784D1784;
	Wed, 30 Sep 2026 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788598; cv=none; b=tOy6/+Z7EEUDU5REonjiJfCE4O+hFHFmXZf5akOxgsI+rQjMmQU7DKj9X1KCNvQizXrO75Cg0kBrZUt1gCN0tFGUjyRxH6cQbagdeAw5RJuDRuE9uUkRvG+a43Smc75eWYeXZ2Gll1S3yLa0XAvRKeC/ialQerl6ZeP+o81Kuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788598; c=relaxed/simple;
	bh=MMpkmO22mJLZkvXMrxPMP24QaQF4ktNmGiAldqcLs34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dq2xvbAfQDNXRypkJijV8dsw6hLpypQMFmLoZTVPccg5FSJHSTFzPyOM9Yb/cJW6Z0uwhP4TPqM/l66HaKPNb563dVGaGc0s6pC064Com/9IoMPBsH3IkfCmeeqXT8s2PWQzzj8vR4dTNke9ck1nIb+iL0+bx1B/rYQyv0xaADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsCGr00y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsCGr00y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD671F00898;
	Wed, 30 Sep 2026 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788597;
	bh=f3Rqq631Yhfvra7bXGUkqmR50mhcwXgsojPKqKDV+yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsCGr00yHqbbHnB1V35634lvtjTyxuMJhwBHm1wKVYzys7lSQCneoOKJT2qKy2IDS
	 w9GZczjZ5NBtc2eDdqwh/36Xp1gzbwYspTq9Wo4pQY2kptI6HK3bdWifo11xo4PSlh
	 lkUUYbcQ16gP/JqDmTdN1xQ+GbRQ6agcRoMprp+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.12 181/877] arm64: dts: renesas: r8a779f0: Set UFS lane count
Date: Wed, 30 Sep 2026 17:18:12 +0200
Message-ID: <20260930152418.634937912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -876,6 +876,7 @@
 			clocks = <&cpg CPG_MOD 1514>, <&ufs30_clk>;
 			clock-names = "fck", "ref_clk";
 			freq-table-hz = <200000000 200000000>, <38400000 38400000>;
+			lanes-per-direction = <1>;
 			power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
 			resets = <&cpg 1514>;
 			status = "disabled";


