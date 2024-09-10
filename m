Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7291817BB0C;
	Tue, 10 Sep 2024 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965199; cv=none; b=GEMizoRq/QZMeb97kEDWcQz/Uq2WBwhtPRxKh4Q3fpoyEVJJGprGJ6OGpatKGsVYNFZO7Y6nJwMXLHFahVNOcx5pYMGxum3Iejhhxq6Wra3pz/MmDGFlEgCnilzeEfK88whP6bydLN2kifPOEbXQCnLx5QcivSDEDEPAGEusx4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965199; c=relaxed/simple;
	bh=fJtLaUtRKB8sGLVpgmAYLRHkFdV6ZxAkB1S+D4l+260=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGTKePDQNvN0tylosbjM+yd23/SnS7jHYajKPsycUwONM4rTRSa1nHIcic3HoTUTqezKVOf+YqhK7XibgPT6l870imhi1Imso+ckfvvRpGvDbhQ46gRgrAOunt5nJX1dd3KN0aRbs6T7U6J4ulMkYuS6ZzwS/Z/b8nupyodYrcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFSE0MYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFSE0MYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF52C4CEC3;
	Tue, 10 Sep 2024 10:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965199;
	bh=fJtLaUtRKB8sGLVpgmAYLRHkFdV6ZxAkB1S+D4l+260=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFSE0MYt/t80dRjrjJ+/7WVQCSRSe91LNoBWXJHSKo4+AEJ/OoavxlQoLRJpq92M8
	 09HGeqTr2dsnA7s3I+/07f6zpcQfFGFeB3teHDqpiGM9p7WRvgWcRP+/FhlU/AsfNW
	 /MGvl+uiMisJlq8k6zP3gbfzH8fOOz6Tgu0ckaQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 170/186] clocksource/drivers/timer-of: Remove percpu irq related code
Date: Tue, 10 Sep 2024 11:34:25 +0200
Message-ID: <20240910092601.628295020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

commit 471ef0b5a8aaca4296108e756b970acfc499ede4 upstream.

GCC's named address space checks errors out with:

drivers/clocksource/timer-of.c: In function ‘timer_of_irq_exit’:
drivers/clocksource/timer-of.c:29:46: error: passing argument 2 of
‘free_percpu_irq’ from pointer to non-enclosed address space
  29 |                 free_percpu_irq(of_irq->irq, clkevt);
     |                                              ^~~~~~
In file included from drivers/clocksource/timer-of.c:8:
./include/linux/interrupt.h:201:43: note: expected ‘__seg_gs void *’
but argument is of type ‘struct clock_event_device *’
 201 | extern void free_percpu_irq(unsigned int, void __percpu *);
     |                                           ^~~~~~~~~~~~~~~
drivers/clocksource/timer-of.c: In function ‘timer_of_irq_init’:
drivers/clocksource/timer-of.c:74:51: error: passing argument 4 of
‘request_percpu_irq’ from pointer to non-enclosed address space
  74 |                                    np->full_name, clkevt) :
     |                                                   ^~~~~~
./include/linux/interrupt.h:190:56: note: expected ‘__seg_gs void *’
but argument is of type ‘struct clock_event_device *’
 190 |                    const char *devname, void __percpu *percpu_dev_id)

Sparse warns about:

timer-of.c:29:46: warning: incorrect type in argument 2 (different address spaces)
timer-of.c:29:46:    expected void [noderef] __percpu *
timer-of.c:29:46:    got struct clock_event_device *clkevt
timer-of.c:74:51: warning: incorrect type in argument 4 (different address spaces)
timer-of.c:74:51:    expected void [noderef] __percpu *percpu_dev_id
timer-of.c:74:51:    got struct clock_event_device *clkevt

It appears the code is incorrect as reported by Uros Bizjak:

"The referred code is questionable as it tries to reuse
the clkevent pointer once as percpu pointer and once as generic
pointer, which should be avoided."

This change removes the percpu related code as no drivers is using it.

[Daniel: Fixed the description]

Fixes: dc11bae785295 ("clocksource/drivers: Add timer-of common init routine")
Reported-by: Uros Bizjak <ubizjak@gmail.com>
Tested-by: Uros Bizjak <ubizjak@gmail.com>
Link: https://lore.kernel.org/r/20240819100335.2394751-1-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-of.c |   17 ++++-------------
 drivers/clocksource/timer-of.h |    1 -
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/clocksource/timer-of.c
+++ b/drivers/clocksource/timer-of.c
@@ -25,10 +25,7 @@ static __init void timer_of_irq_exit(str
 
 	struct clock_event_device *clkevt = &to->clkevt;
 
-	if (of_irq->percpu)
-		free_percpu_irq(of_irq->irq, clkevt);
-	else
-		free_irq(of_irq->irq, clkevt);
+	free_irq(of_irq->irq, clkevt);
 }
 
 /**
@@ -42,9 +39,6 @@ static __init void timer_of_irq_exit(str
  * - Get interrupt number by name
  * - Get interrupt number by index
  *
- * When the interrupt is per CPU, 'request_percpu_irq()' is called,
- * otherwise 'request_irq()' is used.
- *
  * Returns 0 on success, < 0 otherwise
  */
 static __init int timer_of_irq_init(struct device_node *np,
@@ -69,12 +63,9 @@ static __init int timer_of_irq_init(stru
 		return -EINVAL;
 	}
 
-	ret = of_irq->percpu ?
-		request_percpu_irq(of_irq->irq, of_irq->handler,
-				   np->full_name, clkevt) :
-		request_irq(of_irq->irq, of_irq->handler,
-			    of_irq->flags ? of_irq->flags : IRQF_TIMER,
-			    np->full_name, clkevt);
+	ret = request_irq(of_irq->irq, of_irq->handler,
+			  of_irq->flags ? of_irq->flags : IRQF_TIMER,
+			  np->full_name, clkevt);
 	if (ret) {
 		pr_err("Failed to request irq %d for %pOF\n", of_irq->irq, np);
 		return ret;
--- a/drivers/clocksource/timer-of.h
+++ b/drivers/clocksource/timer-of.h
@@ -11,7 +11,6 @@
 struct of_timer_irq {
 	int irq;
 	int index;
-	int percpu;
 	const char *name;
 	unsigned long flags;
 	irq_handler_t handler;


