Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79914369A;
	Wed, 25 Feb 2026 01:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982916; cv=none; b=U+5IMowJWl/aoGEALOVxDJFldKDPl4xAnAuF/pm+E6t3EBNs+O/CbpnNppDlP5s7Xuy7R5uleRMFiUlOXwJyHTsJKguQBcmFCK7NRw8glhT34peQzYgf9RBifmkLZ/cHTYo4t9eM7Xc70+DxuuS9rp3mh+txl92nVSs2055olcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982916; c=relaxed/simple;
	bh=IpjhfUVwjnM0cAmCtRMkz2usyn39z5uQxywpBG/W0B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3pvsj6aIf2kneBXB6it8GSXjeO43WIuEvFtCTRFurDDVnJTFU45B7/zrn/Wo1Vy27tMPAcIaqlnElii+fcaAzT3Gh+xKNKgSOWVjwK3svSNAzQmMYqA8mGf3tbC0iGh+R5/MOGx28dvPj+yve3rMS/GDHloV9q2pGM1+1QzQAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smnTQmf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smnTQmf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7731AC116D0;
	Wed, 25 Feb 2026 01:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982916;
	bh=IpjhfUVwjnM0cAmCtRMkz2usyn39z5uQxywpBG/W0B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smnTQmf+khvYAsGZRY2tS/jBx/PhVCVut7O5As/eNavc+5GK1EWgDKYCULH35P0lU
	 Mv2hI9i5BrPaqPPsr/PTjXjT9bGFeU0DnJ2gQBp2JjFSeZvCwOWJwtMh2Thiwyd3xG
	 57vMBBKkKb79UzlVk8wkNLnzJ0oS4yUdzxXKtKEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 096/781] hrtimer: Fix trace oddity
Date: Tue, 24 Feb 2026 17:13:25 -0800
Message-ID: <20260225012402.045517056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 5d6446f409da00e5a389125ddb5ce09f5bc404c9 ]

It turns out that __run_hrtimer() will trace like:

          <idle>-0     [032] d.h2. 20705.474563: hrtimer_cancel:       hrtimer=0xff2db8f77f8226e8
          <idle>-0     [032] d.h1. 20705.474563: hrtimer_expire_entry: hrtimer=0xff2db8f77f8226e8 now=20699452001850 function=tick_nohz_handler/0x0

Which is a bit nonsensical, the timer doesn't get canceled on
expiration. The cause is the use of the incorrect debug helper.

Fixes: c6a2a1770245 ("hrtimer: Add tracepoint for hrtimers")
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260121143208.219595606@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0e4bc1ca15ff1..84c8ab2a0cebf 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1742,7 +1742,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 
 	lockdep_assert_held(&cpu_base->lock);
 
-	debug_deactivate(timer);
+	debug_hrtimer_deactivate(timer);
 	base->running = timer;
 
 	/*
-- 
2.51.0



