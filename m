Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CA112F581;
	Tue, 23 Jan 2024 01:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971727; cv=none; b=WmUaM3CDlhbPRq4v8PXuI5rCHrTzD2hHgcQHQHwkyK0z0ND8byH23pbGoXbxC0lFXlhv/4E1JmUo1vjwoEt2WzMy6+Eu43GfHA1vCKV5q/WbE8mOqY3SgWZyklaINv/aAF/6SRi6B13kwoz4MUkzuWl9xukmGsue/eA0MRsV5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971727; c=relaxed/simple;
	bh=l04qzBxT8b5YkdKn0xnnbiOdTBkghPPu9oMY20m3LdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fU0WUg+7rRof0XuTdeiS98KaAUPG3z0oA5jXd7kc/fd+9/lTsQUMACoioaP6aOl9+S4KCQqPn0tFIlyFuOC7YN4TbdCW8kWs4+el7j5V11EIMx4xjm1j6ZvgLfx+ugPs7kur5/1ggPI59gFiVfUU7xqmT+8ifB+TE0xjDs7gnrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWOQicdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWOQicdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC6DC433C7;
	Tue, 23 Jan 2024 01:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971726;
	bh=l04qzBxT8b5YkdKn0xnnbiOdTBkghPPu9oMY20m3LdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWOQicddMEsgTRwCD5ZUya5/EihGsslDRECm18CLxWMgvovKS0+WHa3v/JlRxanI/
	 Mht5JEYWlIEWecZXbG0j8blrH3HK8Qt+XfQmcDpkS5xLIWqaZ3hiOIUvYPHQztlVdw
	 WRT68mGGW19nUF0Gl4y9n70v2tvdbEnVKgk8vEH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Li Jun <jun.li@nxp.com>
Subject: [PATCH 5.10 215/286] usb: chipidea: wait controller resume finished for wakeup irq
Date: Mon, 22 Jan 2024 15:58:41 -0800
Message-ID: <20240122235740.362143762@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 128d849074d05545becf86e713715ce7676fc074 upstream.

After the chipidea driver introduce extcon for id and vbus, it's able
to wakeup from another irq source, in case the system with extcon ID
cable, wakeup from usb ID cable and device removal, the usb device
disconnect irq may come firstly before the extcon notifier while system
resume, so we will get 2 "wakeup" irq, one for usb device disconnect;
and one for extcon ID cable change(real wakeup event), current driver
treat them as 2 successive wakeup irq so can't handle it correctly, then
finally the usb irq can't be enabled. This patch adds a check to bypass
further usb events before controller resume finished to fix it.

Fixes: 1f874edcb731 ("usb: chipidea: add runtime power management support")
cc:  <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/20231228110753.1755756-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -516,6 +516,13 @@ static irqreturn_t ci_irq_handler(int ir
 	u32 otgsc = 0;
 
 	if (ci->in_lpm) {
+		/*
+		 * If we already have a wakeup irq pending there,
+		 * let's just return to wait resume finished firstly.
+		 */
+		if (ci->wakeup_int)
+			return IRQ_HANDLED;
+
 		disable_irq_nosync(irq);
 		ci->wakeup_int = true;
 		pm_runtime_get(ci->dev);


