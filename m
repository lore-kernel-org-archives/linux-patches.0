Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F51A76AB;
	Tue, 30 Jul 2024 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360208; cv=none; b=LquwC0xrVLQujLx9F1usgXoHTjMKvQuuOMHvbfnZ6rHHabLp2AZsOVxGATc0Mum2kw0ICC1Y6LnTlenxGlnkSX9dUu7qy7TMIfpLpHUJR8j0O8Put6MqkOjoVKIf/vGrfFRoi7EcX2DMgtbhPZp/Zgr4VoSULGkRcItJDJBZjUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360208; c=relaxed/simple;
	bh=bWc724DrjUrb2KLticBYE0xMmEqBZXYUNbSvMNZRfZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSaGYdFRWuCGAycyoLT2TQ61BOh5mmoqmvAQIJdrAGZCocrmTQWDlkQmK0T+49WjegYINvF0eZydnRnVt1rFGQClZxbcgoqxxJsgxWgULjtI6o+TkJ2eeEZZ7delWMvaBUXMc3WoWikBFpW4DnInyqUneTcCutwNx49m8LNbVws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFoYxpDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFoYxpDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4360C32782;
	Tue, 30 Jul 2024 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360208;
	bh=bWc724DrjUrb2KLticBYE0xMmEqBZXYUNbSvMNZRfZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFoYxpDDDRl5K8E4DnLGYS9sBgfM4/3+roHGnWezAWZZGSpEq+OotiLH4lDmCGwUw
	 AXmNvH1wtG7Da5ZhWdLgBFLKkMDavsqjjjxL8DkkQIR+6aBdaizBBdbP+gUyZiXytX
	 CCeCozLD/XvEbE4GvHbuk170XW6HRbGPVpY1s08c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Seyfried <stefan.seyfried@googlemail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kerel.org
Subject: [PATCH 6.10 598/809] genirq: Set IRQF_COND_ONESHOT in request_irq()
Date: Tue, 30 Jul 2024 17:47:54 +0200
Message-ID: <20240730151748.449682777@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c37927a203fa283950f6045602b9f71328ad786c upstream.

The callers of request_irq() don't care about IRQF_ONESHOT because they
don't provide threaded handlers, but if they happen to share the IRQ with
the ACPI SCI, which has a threaded handler and sets IRQF_ONESHOT,
request_irq() will fail for them due to a flags mismatch.

Address this by making request_irq() add IRQF_COND_ONESHOT to the flags
passed to request_threaded_irq() for all of its callers.

Fixes: 7a36b901a6eb ("ACPI: OSL: Use a threaded interrupt handler for SCI")
Reported-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: stable@vger.kerel.org
Link: https://lore.kernel.org/r/5800834.DvuYhMxLoT@rjwysocki.net
Closes: https://lore.kernel.org/lkml/205bd84a-fe8e-4963-968e-0763285f35ba@message-id.googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/interrupt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5c9bdd3ffccc..dac7466de5f3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -168,7 +168,7 @@ static inline int __must_check
 request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
 	    const char *name, void *dev)
 {
-	return request_threaded_irq(irq, handler, NULL, flags, name, dev);
+	return request_threaded_irq(irq, handler, NULL, flags | IRQF_COND_ONESHOT, name, dev);
 }
 
 extern int __must_check
-- 
2.45.2



