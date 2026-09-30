Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812B5172CF;
	Wed, 30 Sep 2026 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787807; cv=none; b=Xr0pPEsXHggJF21bk2YoQQSM6c8pyjgZA5UUiYp0quDZK7kXP56tZj81aNodMgLWTyjBwRnMCKuUpnypkJQDPJ4314s5V3pEgk8OLrN/OHZKO6EjLS5kknrQYPIR3y4dU9YSAQPZPAHLQdzCNBiG2rKKfldNg0yrVSfmMRWEYuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787807; c=relaxed/simple;
	bh=bBPeJ6VOTOKBSvX+qfUZiKim90/bJC0N1ujsxDfKByA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSx9lsIc+tf2qIFdp9Swy7UbfkVy784HwX/bg1Yt2kKzStsiEWA9q/7iTZGS7wYhJkW34YPGaFke2SbJD9HMxnOAM4oxKPvRC/xcajREM+COOFZM4tglf1Uq03VJd2JJNPYRXEqnl3PbW2f76/Iqn/HF8sZ4WDpraroV9NWd1P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWwz/VdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWwz/VdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3961F000FF;
	Wed, 30 Sep 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787805;
	bh=/RY9I6+U7C+fLDECIhDXjFGOWPWvYCyAs/UqdDU1qcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWwz/VdN3YeHgjtCSRsoiCd+w33lC2B0FkWRKgtUq/pPuEHExoaTBkQyCmfj21pJv
	 unjfMVpj5LELDYLOm+yb6U4GEvEBOGNGNFC5VLttaSiRn1uXO1G74wNtdw/afzSF7X
	 p84nsAOYDoDcBp08CaKvGfRhN8lCKBjeYyJTJ2NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Zhenghui Hao <zhenghui.hao@qq.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 361/457] parisc: parse early parameters in setup_arch()
Date: Wed, 30 Sep 2026 17:27:46 +0200
Message-ID: <20260930152353.797374832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenghui Hao <zhenghui.hao@qq.com>

commit 289e99e7a263c6fd6a5d07d6d8f2156b70f3a9d5 upstream.

parisc is one of the few architectures that does not call
parse_early_param() from setup_arch().  That was mostly harmless until
commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
zones and memory map") moved the consumer of several hugetlb command
line parameters into mm_core_init_early(), which runs before the
generic parse_early_param() call in start_kernel().

As a result hugepages=, hugepagesz=, default_hugepagesz=, hugetlb_cma=
and hugetlb_free_vmemmap= are recorded after they have already been
consumed and are silently dropped on parisc.

Call parse_early_param() from setup_arch(), after the command line has
been set up and the memory inventory has been taken.  jump_label_init()
must be called first because early parameter handlers may enable or
disable static keys.  Both functions are safe to call more than once:
the generic calls in start_kernel() remain in place and turn into no-ops.

Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
Tested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/setup.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index d3e17a7a8901..4d3015a411d6 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -132,6 +132,18 @@ void __init setup_arch(char **cmdline_p)
 	parisc_cache_init();
 	paging_init();
 
+	/*
+	 * Parse early parameters before mm_core_init_early() runs.
+	 * Several early_param() handlers only record data that is consumed
+	 * from there - for example hugepages=, hugepagesz=,
+	 * default_hugepagesz=, hugetlb_cma= and hugetlb_free_vmemmap= - so
+	 * the generic parse_early_param() call in start_kernel() is too late
+	 * for them.  jump_label_init() must come first, since early param
+	 * handlers may enable or disable static keys.
+	 */
+	jump_label_init();
+	parse_early_param();
+
 #ifdef CONFIG_PA11
 	dma_ops_init();
 #endif
-- 
2.55.0



