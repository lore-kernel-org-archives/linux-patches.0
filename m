Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49ED2DCF57;
	Fri,  4 Sep 2026 05:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499681; cv=none; b=kCZU/3bK45s/INF3y2JomBcdp0+Zk1TIQKEtunv39S3H3e8qGs5KWQ4GyjWl3tlh2j9X39BKyiDmDmf94VVWLb2p+CmQrxnpOLZaHtubH7zLrx819u772TDFKxfxycIXSk8VWii64CtxdHs5+nH54w8mQw2E92lxFWT04dQ8aG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499681; c=relaxed/simple;
	bh=gM1x6DXEo+0WV/0qUb3LihcR0HNczq08Cg8reUMQGbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9GmcZ8FiLmLmmkxd5IxcaoftHccVmp7RWQ7Dl5Qf4TCeyY79+TfKJdjYKDY+pUuJZpSp3Gt3vWHTOLNsS2JBXNg+D5DaV64Qh83IyP7d9IgKe/QEvTUZdBiK0FTLAwdv4OkPuq81tK3cpQ9+tggCLjwTmxyx/alR7KuFy/fEWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHuzDwd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHuzDwd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4141F00A3D;
	Fri,  4 Sep 2026 05:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499680;
	bh=BXf8CvhT0k24qWITj/CSY+aZJpeef85hZyzWYYiIw74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHuzDwd48TSE0LpR0rHbQejCtl1Nk9xlJNW2z8Nolz1StwV/eWmDTD2SmE0BHf+sa
	 noLLSJg1wA4c0VS1ks73Ldve1d7uJEgoVvMiJhlRct7binWxW/pqQRy3wbYRr7g3zz
	 83g6NDaQgfsmyw/xBQAWlPH1/hKG2Zv7oE6j2Mug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 504/713] power: supply: lp8727: fix use-after-free in lp8727_release_irq()
Date: Fri,  4 Sep 2026 06:57:52 +0200
Message-ID: <20260904045815.120810808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit ceb6ac43b0f591722401922ceb958ce2616935e0 upstream.

lp8727_isr_func(), the threaded IRQ handler, is the only caller that arms
pchg->work via schedule_delayed_work().  lp8727_release_irq() currently
cancels the work before freeing the IRQ, so an IRQ delivered in between
can re-arm the work through the threaded handler.  After .remove returns
the devm layer frees pchg while lp8727_delayed_func() may still run and
dereference it.

Free the IRQ first so the threaded handler is quiesced and can no longer
queue work, then cancel the delayed work to drain the final generation.

This issue was found by an in-house static analysis tool.

Fixes: d71fda016102 ("lp8727_charger: Clean up the interrupt handler")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260807033520.8551-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/lp8727_charger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/lp8727_charger.c
+++ b/drivers/power/supply/lp8727_charger.c
@@ -280,10 +280,10 @@ static int lp8727_setup_irq(struct lp872
 
 static void lp8727_release_irq(struct lp8727_chg *pchg)
 {
-	cancel_delayed_work_sync(&pchg->work);
-
 	if (pchg->irq)
 		free_irq(pchg->irq, pchg);
+
+	cancel_delayed_work_sync(&pchg->work);
 }
 
 static enum power_supply_property lp8727_charger_prop[] = {


