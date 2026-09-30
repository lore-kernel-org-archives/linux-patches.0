Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6DD521886;
	Wed, 30 Sep 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793573; cv=none; b=vFBal1TS0bvee1+fb+kdqjroMwE8Hly3uaIzc/o10il8B9y/PFXl9anIA0ceIJ9cyhtdcSKzXNrnwpHHPsizbxxFUjjcOJJzovrnDto8AVYEB/Z1fnHvK6Yi42rTA+L3+a31Q1LtsULriqDa8tHB5AJxwAtQ523XJDg1V5mNqWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793573; c=relaxed/simple;
	bh=i5E0yMg/GK6eTYDDUAwVJxG+T4VJvK7fEk0SlqJMvlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXqXldjJxTL7R3CrCpPGDKYYjW/3V/smOUSoi2srzuouNZAy5yme89cimCF28lwZaKN/bEWJbrive82nlPjtWt1OI4ghArBuT8gsZz5mdiglBF5K5HtNNQPMOXwMFIzu+UyUdWcaHjh3ACiEGTW6spZfk+joIiXrEg0TWcHoqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgMMmNGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgMMmNGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8EC1F00898;
	Wed, 30 Sep 2026 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793571;
	bh=crR4GrZpYTK7OGljaLGGRf2T8lXy6xwWSUc3FtmAff4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgMMmNGs3gw3BVqUDknvR2kZy31gW90/yMZa2cGFhTinxhl4B5FARj2wk1tm5tDdv
	 vlS0TJVlKnCK89UfZRoDlld+1v5orm7RdD7uAG8OKrPPtsKDA5JPnGHINuZC8HTTIU
	 k8Rn5XLJC+QP3JGsm3Gkscgi2mJzN5ftQ14tGR6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 301/395] pinctrl: single: free the IRQ on domain creation failure
Date: Wed, 30 Sep 2026 17:29:23 +0200
Message-ID: <20260930152347.185118704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 1d9bb9c870632adea249cfdec49ac37e6f069164 upstream.

pcs_irq_init_chained_handler() requests a shared IRQ on affected SoCs, but
its domain creation failure path only removes a chained handler. That does
not release the action installed by request_irq(). The probe can continue
without interrupt support while leaving the shared IRQ action registered.

Use pcs_irq_free() to undo the appropriate type of handler registration.
At this point pcs->domain is NULL, so the helper only releases the parent
IRQ handler. Then mark the IRQ invalid, as the other initialization error
paths already do, to prevent another release from a later probe unwind or
remove.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 3e6cee1786a1 ("pinctrl: single: Add support for wake-up interrupts")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-single.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1627,7 +1627,8 @@ static int pcs_irq_init_chained_handler(
 					       &pcs_irqdomain_ops,
 					       pcs_soc);
 	if (!pcs->domain) {
-		irq_set_chained_handler(pcs_soc->irq, NULL);
+		pcs_irq_free(pcs);
+		pcs_soc->irq = -1;
 		return -EINVAL;
 	}
 


