Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D79377A8A;
	Tue, 21 Jul 2026 22:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672332; cv=none; b=Kl8mTOcK8/kc5vIZeVIK2Qzl02/M4dZCDNd0/fjP+1cl1Jk6zeeFhcT8c6HwoUgmo3wtRC4/oZHdnmgDekc2xWb4H4p2gzxK16bfqRqrYl9yN0J4NoNuGEGu+ntSKXrKHSbbHKxC3RSR8S0dzKwgCf8DqXzsIlUJb1ZCCXdK3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672332; c=relaxed/simple;
	bh=Vl8hibm4WVqhyy/21EIwWlXkpN0IRfucJiQ4aHAE3C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXlu5zQWhnmMuDVExEeGKgQyR15yrl17EzqdV/oz3c+pX3c2xllVbOUGPn8itG4dDAVTFMAGJ/T4wjcxDkoB2LTUbc1L2Kkt24Mh7/8iwMElm76GcyfbnbbxRQ0UKuAwF85k0fcGhuy0tj469kCffvlCWdW+eMJodwcroSh9hgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nn6FN/5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nn6FN/5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AD21F000E9;
	Tue, 21 Jul 2026 22:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672330;
	bh=QUFhOmkXPy5EqCDy185Ve4IyPB/7jHT50UTdvi9a5c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nn6FN/5+UVbJ+Bf+B5sfFuQIWPzPO8cy4kmNRPQu2WiQ5X499j50URVY/Pez+R72L
	 HCn1PWnqxwrwQl/WDnL0QsEVWcfB+xnqp5wTVBQFAvo28Mn1colZnbcnl7J4RkIgwK
	 jjgHgfgSYygSHIcYDZIhgr3kSvNx6bjz2THdn7rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: [PATCH 5.15 582/843] soc: fsl: qe: panic on ioremap() failure in qe_reset()
Date: Tue, 21 Jul 2026 17:23:37 +0200
Message-ID: <20260721152419.140020743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -88,6 +88,9 @@ void qe_reset(void)
 	if (qe_immr == NULL)
 		qe_immr = ioremap(get_qe_base(), QE_IMMAP_SIZE);
 
+	if (!qe_immr)
+		panic("QE:ioremap failed!");
+
 	qe_snums_init();
 
 	qe_issue_cmd(QE_RESET, QE_CR_SUBBLOCK_INVALID,


