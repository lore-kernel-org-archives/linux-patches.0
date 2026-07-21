Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05B1402428;
	Tue, 21 Jul 2026 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654217; cv=none; b=Zv7MT5eFGvde1CCgtpWEaPXTlrBlqGHtGUTlofhoZXIQAnt/tEYqg3he5/yGUMpo0vq2tCcK1RrmOtxcmi4nj6CBJ4Oyc2rK02cg/0pmQA28aHGcwcsD6V1HUKZy/FQoCePuLutWE80xs8nx4lzM7skdZUZKRxkqNST1d/XQ2Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654217; c=relaxed/simple;
	bh=R4q82uk+Ep52VxX86widHsCbpDznFWxKBJBzMt95v/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPcwOPnqr7AqzaY12hVbcEP5NP5MAm5HUUUL15VCxvbJeM13Xm4gMdWkIAxfSruuiX1eCxh7vmwRBNtqit+ItaOwjyXWUbw+tB1b3fy6/OZZ3hWxTyuaRq6VDejx7A59X2y5UvpsBUTMz/p6uIpEpRdi+xXc+TlanGhibM1pumg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCBGrdjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCBGrdjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420CA1F000E9;
	Tue, 21 Jul 2026 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654216;
	bh=OOUxEV2jrmuCum4ESsvuKV5WhfbwH0VAshDymecz6dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCBGrdjYHk4ykjHUvIqRqnA8LV+ARVzmsiWO+C04HbPfpOz1pSqBC/+Yjj5PXh/Fb
	 ok4xBceVR9tZ61kkbyYGsSn8qJemSColbArX/vhVXm1jYMID6t/unBcsmGW2UzEmyU
	 6EjttMinznd5mYW2QhpYWlG7292sI+zXaiU8KdNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: [PATCH 7.1 1622/2077] soc: fsl: qe: panic on ioremap() failure in qe_reset()
Date: Tue, 21 Jul 2026 17:21:35 +0200
Message-ID: <20260721152631.016439206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


