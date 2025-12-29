Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E633067B;
	Mon, 29 Dec 2025 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025800; cv=none; b=BT/H5FpPob+FW1nC1VksPDq2hhcAmEb17htLgu1NKhv5CsQN60wZ8ydDnF3xtQ2F1dOSPFLX3Ri50Q38xI2mbVN6dBpdQmyyKpp7q5ibEIOvXuzNkViRAcwsO/HDMZlyjm9uGYT+DrAGnsU3kl+5k74i+sdfGvY17Jhl2Obve/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025800; c=relaxed/simple;
	bh=V+D87Bo7oXl92AcWfU/WgpXc9YNj5uuPbI0TxbQF+cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZyOwycyNXbXFRg7XLiN3pFp8pSOz0gQkRDOFJFKP8MiwhFL0KaNozF1yEFuDmCqfaY12bCufRtzAb07DhnMiTYb6M02gIzA8cbLur0zFCxXTBULX2aNfCzADVJ2GNFdf9GQx4nIimUK8JBA0runLxbFMptAqrlxwhiXxk3LLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XHBdjTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XHBdjTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC2FC4CEF7;
	Mon, 29 Dec 2025 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025800;
	bh=V+D87Bo7oXl92AcWfU/WgpXc9YNj5uuPbI0TxbQF+cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XHBdjTc7mpWO+CakFvmkgbL9PQqAHDRsA9bKI0LL7UR5PY1J36foiLJ57opd85PU
	 dJY8GT7cBzoE6eWb6HjbeM500ED83ZMqx54X5etBq4YsSwHCj6GGRl5qiOKncKSlbh
	 9JcY3lVyzoVeVWnpRNAp0d49Dh91uBdug5yphWj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuqiang wang <fuqiang.wng@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 340/430] KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
Date: Mon, 29 Dec 2025 17:12:22 +0100
Message-ID: <20251229160736.840812945@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: fuqiang wang <fuqiang.wng@gmail.com>

commit 9633f180ce994ab293ce4924a9b7aaf4673aa114 upstream.

When restarting an hrtimer to emulate a the guest's APIC timer in periodic
mode, explicitly set the expiration using the target expiration computed
by advance_periodic_target_expiration() instead of adding the period to
the existing timer.  This will allow making adjustments to the expiration,
e.g. to deal with expirations far in the past, without having to implement
the same logic in both advance_periodic_target_expiration() and
apic_timer_fn().

Cc: stable@vger.kernel.org
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
[sean: split to separate patch, write changelog]
Link: https://patch.msgid.link/20251113205114.1647493-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2972,7 +2972,7 @@ static enum hrtimer_restart apic_timer_f
 
 	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;


