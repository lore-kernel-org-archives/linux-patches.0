Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5C46C4C0;
	Tue, 21 Jul 2026 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658533; cv=none; b=kkJIM0rtJpQ7BoOXFe+g5L3scaah1ViuXyudFHYVpkB1i1+p7WBb7pJuBWU7HauF0aag9+CHS3+jrqTsTOjKGw1aAcn15EGG+h8tqliTb0HMxW3jWDomlzTS5O04OWZv6f1ztrSkAy61LiZPoU2T1OHoyKJQ2buxNJi5uUKImCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658533; c=relaxed/simple;
	bh=CmNfOjUmdA1ZB98mDSLkGddyFGA3LUqVz8gn6qjhXE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0zWAPiej+Pyppxf0yPyUGnNMNrBG0sne+PnR8N7vwBZCVCgCXAtnDm8M9xnsvKs8gRHMqU4hfer75g34lcGstU3g7fRzkXT/fhkSBkjgr2uCHkHwfPatz7NE8tRF9EX7J3tGQtPg5r/KF2Kc79F+sDIMXnXvWR1E2kmQv5Cj5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPb7CLl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPb7CLl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819501F000E9;
	Tue, 21 Jul 2026 18:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658532;
	bh=5sRP/VAY1V2OHrofC5CsT/MHkc4n0LsCEJlW6WHF/4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPb7CLl/2Yfd6iHz/rMVdxH/XpAkY197eqemjBqJ7X7GV7wsQfSY+AXkZpKkL0x6A
	 E+bEeCXSmLZ5xWgTkqTco71+IxeiCx0nt/95nQrGQw3mRIyI5Xg0iRTBZDZ9uVgSr0
	 6G4IWyNGOnjl0XRD+dI2g7fgGYIGCslxFvYsfsjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: [PATCH 6.18 1179/1611] soc: fsl: qe: panic on ioremap() failure in qe_reset()
Date: Tue, 21 Jul 2026 17:21:35 +0200
Message-ID: <20260721152541.951110645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wang Jun <1742789905@qq.com>

commit a0fe29d20e7822182e12324905af5115c1b3aed3 upstream.

When ioremap() fails in qe_reset(), the global pointer qe_immr remains
NULL, leading to a subsequent NULL pointer dereference when the pointer
is accessed. Since this happens early in the boot process, a failure to
map a few bytes of I/O memory indicates a fatal error from which the
system cannot recover.

Follow the same pattern as qe_sdma_init() and panic immediately when
ioremap() fails. This avoids a silent NULL pointer dereference later
and makes the error explicit.

Fixes: 986585385131 ("[POWERPC] Add QUICC Engine (QE) infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Jun <1742789905@qq.com>
Link: https://lore.kernel.org/r/tencent_FED49CF5331CC0C7910618883332A08E2606@qq.com
[chleroy: Rearranged change to reduce churn]
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/soc/fsl/qe/qe.c
+++ b/drivers/soc/fsl/qe/qe.c
@@ -89,6 +89,9 @@ void qe_reset(void)
 	if (qe_immr == NULL)
 		qe_immr = ioremap(get_qe_base(), QE_IMMAP_SIZE);
 
+	if (!qe_immr)
+		panic("QE:ioremap failed!");
+
 	qe_snums_init();
 
 	qe_issue_cmd(QE_RESET, QE_CR_SUBBLOCK_INVALID,


