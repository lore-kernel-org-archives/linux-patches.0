Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC86B12F58D;
	Tue, 23 Jan 2024 00:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969000; cv=none; b=fK/s+fl6IgLeFFERTS5e5IclF+osoaBhl46+SHO3a2TvdpNfPlZCG6AyficfIM5JKkl3Su/i7c4KQv5Q2TnKpMb0RpcMEJOU5BXuJwX6DTidNgf9h0HEhgTEpbFzij5ITxXxd4XqYvTa5nBuUWxWG+YNWn4wbXW5lKyH28XiFVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969000; c=relaxed/simple;
	bh=mrlG/8eLZmtcXc7BM7Y0ICKqxSKanF4ZMiF3/W5t7S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7fi0F2Gr0mTwQ3W3wHysQfm7vDzp5/p2i9Qzk5qVSgXCtALl+8sl3fdsaFNRuy8YkP4JfFnEe6aMj2kiLNUSSk/iEpoLyPvixokNEfIGVrgUIQ+9oFVOLMpsWKUguTQoTBT7dgFLlzvUReyyBRNG0yQbv67a6/FesGDmJIcDzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFfD5iri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFfD5iri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87F3C433F1;
	Tue, 23 Jan 2024 00:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969000;
	bh=mrlG/8eLZmtcXc7BM7Y0ICKqxSKanF4ZMiF3/W5t7S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFfD5irirSIXV+sTEHmcbkPc6YSpBcHcL8wwvsh2wfcHxDyzWXAg626Oor5iynrVP
	 R3AoaySn6F0JYDqNJJIXsnKNZLBMfoXnTHSELI3g7LLcmJXhZIL4d0J/5tyx5iN0cA
	 6/HmYpmyrVnrCRhaOhwexhipawfBGP70vVoOEO3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Li Jun <jun.li@nxp.com>
Subject: [PATCH 5.4 151/194] usb: chipidea: wait controller resume finished for wakeup irq
Date: Mon, 22 Jan 2024 15:58:01 -0800
Message-ID: <20240122235725.677398881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -541,6 +541,13 @@ static irqreturn_t ci_irq_handler(int ir
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


