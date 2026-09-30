Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C764E3245;
	Wed, 30 Sep 2026 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786743; cv=none; b=RSSNEPcuw1zE/mwOuKgVOiswaAwvT9Q7QbniqRet6HfhAIRLKZUCEdJk7uf8XnBN4KCZ2IyVzk2RQOteWuIGYb1OysspPZojUghzCvpEONaywvxbTz/pj4hY1rKkjTMcQ86skp41fS5iacLfXfi3C/grMgcZR0SBtRcOegnJM4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786743; c=relaxed/simple;
	bh=aGip81jcnodsCyR+NDB+c18pd4F24UO+/vmcbVzhvaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da2sZ4ESxrNmDP01zH8V22H3UZb5RBDfNNdethzQfsAzF5y3WJ9HP/lnPpuRmM9j+53mcqnX6ba/80EpP8/bgFqBpYgmegLlufBuQhRoSG+1zcbcweXkMhif++RUGqMj+SOSRAKhgHSGRTBsrramGAh3qrYFGH5V7JumDnUdZXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEK8KOek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEK8KOek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250191F000FF;
	Wed, 30 Sep 2026 16:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786741;
	bh=CGsXWCiGySU5/P3rXbSJ0TDmSUkwx170crnHT+OObk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEK8KOek3o+OpGQjKd1LstaT7rLGHkmt/erBrPcTgDLq39J8d4Of2u6Yl6xcfaj4W
	 kPeUsFDWQdUCn+JWujdyXJyOd0gSitBjzLAk8WF91mH2Dep85BSu6AB5g+o0zDbg3e
	 dSHJYLZRhFOD6ibXf1TprmKPtqRIWAWp/Df+3Kmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.1 967/982] pinctrl: single: free the IRQ on domain creation failure
Date: Wed, 30 Sep 2026 17:28:23 +0200
Message-ID: <20260930152437.512375777@linuxfoundation.org>
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
@@ -1631,7 +1631,8 @@ static int pcs_irq_init_chained_handler(
 					    &pcs_irqdomain_ops,
 					    pcs_soc);
 	if (!pcs->domain) {
-		irq_set_chained_handler(pcs_soc->irq, NULL);
+		pcs_irq_free(pcs);
+		pcs_soc->irq = -1;
 		return -EINVAL;
 	}
 


