Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EF218B495;
	Tue, 10 Sep 2024 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962137; cv=none; b=eqY/uHMJxBWhTMnjSpb1KHZFIiSfYQ89P8TMYreavYLBVKcr37lnfM5Hx7Wq16a73Npw49r78A90/keVxAOfdsnAv064ulkltne+SylWcJB3fT18UgnGCijg4CRPffL/JmFf4Qmd2K+LaF2s+2uTtNnbh7GmsWVn1k+bu4SIvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962137; c=relaxed/simple;
	bh=qw5kh8V+/e5T1IieJXs4BA+UDaSlzaMxdkw/vbNkEXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XhYTv29J2FGKKw4U9n7y32Ng4no9yOj221ck7v0Xj+YNPOwHWF0gkrww8xJ6iIl0Mk87SA3RNLfCGgXiTv8urF7CvUsuRJTKlwAjk+lFKKJJWwawCmy6w4D0UKeItxW9CgBjzJhVypf+0YPrHBfE28oZH9rvj2ORI+Y19gvVJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1duEk4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1duEk4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C72C4CEC3;
	Tue, 10 Sep 2024 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962137;
	bh=qw5kh8V+/e5T1IieJXs4BA+UDaSlzaMxdkw/vbNkEXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1duEk4RfN0HD/GhJK8L3slonA8GWtNqYsjOZE2aOjYbgU4PU9YGgYnUaEo676FaW
	 xBAbIX4QVW6XTSj/NR7rocGNvIinyQudFHargetUSbKNme+Zof/+b38kvJ7U7gBMaS
	 bKXv3SwcgheJpJF2wZJQCt8TXVGBsW0Vc6BDXqfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.10 307/375] clocksource/drivers/timer-of: Remove percpu irq related code
Date: Tue, 10 Sep 2024 11:31:44 +0200
Message-ID: <20240910092632.881465441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


