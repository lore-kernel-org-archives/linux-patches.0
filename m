Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE91131191;
	Mon,  8 Apr 2024 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583499; cv=none; b=IGWSbCmuR7DOGtzLnRgaWTVdbyTIsa0sE7HwqCwss283Q6f8NE/U9i/qXs2MPt4wcmmNv5Nf70T07r8872KFHGjriEwm9eLCgHWVEHfoeB4CjVij7GEmDiTNAXiea+xlUNUxXCziE66+sVFhL+lldlAmwCour+jB9uJlnXwzDi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583499; c=relaxed/simple;
	bh=QowQnAWyvhEaAFHF73jGr8negnrZorYy70YHySnFtXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSu1mTSTQhjvkX6zD4oLqFkicwgfDcGfKJcI6cF5vPfhhmdXLgHtQkrpTAmVx/RCon8TGiede8ij8Tn8BiVUnbeELo2t265mDgVg9GcAK4Kf/89nXqD1g0cPPxP/PJyQf9z+gLWNdz/cIsasJx18sHEpj/FhNJWdvWTf2g/xZTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl2v7SZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl2v7SZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537B6C433C7;
	Mon,  8 Apr 2024 13:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583499;
	bh=QowQnAWyvhEaAFHF73jGr8negnrZorYy70YHySnFtXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vl2v7SZdRg0eBJvB/1UUnGrhGpYh0Tvb34FPUzpl0lxpjS/vpl31OGK3EKItbjOEJ
	 rctO2LK+GdDchfWe0YC1IRbTCILBRe3SUOU8XmhnUWdTbo4lWsnfQckHuk90Sf3Wys
	 1+QjNIPidQCFTxS1triPbIy8+2kiMwuxb3PaJmSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 6.6 202/252] gpio: cdev: check for NULL labels when sanitizing them for irqs
Date: Mon,  8 Apr 2024 14:58:21 +0200
Message-ID: <20240408125312.923918218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit b3b95964590a3d756d69ea8604c856de805479ad upstream.

We need to take into account that a line's consumer label may be NULL
and not try to kstrdup() it in that case but rather pass the NULL
pointer up the stack to the interrupt request function.

To that end: let make_irq_label() return NULL as a valid return value
and use ERR_PTR() instead to signal an allocation failure to callers.

Cc: stable@vger.kernel.org
Fixes: b34490879baa ("gpio: cdev: sanitize the label before requesting the interrupt")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/lkml/20240402093534.212283-1-naresh.kamboju@linaro.org/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1012,7 +1012,16 @@ static u32 gpio_v2_line_config_debounce_
 
 static inline char *make_irq_label(const char *orig)
 {
-	return kstrdup_and_replace(orig, '/', ':', GFP_KERNEL);
+	char *new;
+
+	if (!orig)
+		return NULL;
+
+	new = kstrdup_and_replace(orig, '/', ':', GFP_KERNEL);
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	return new;
 }
 
 static inline void free_irq_label(const char *label)
@@ -1086,8 +1095,8 @@ static int edge_detector_setup(struct li
 	irqflags |= IRQF_ONESHOT;
 
 	label = make_irq_label(line->req->label);
-	if (!label)
-		return -ENOMEM;
+	if (IS_ERR(label))
+		return PTR_ERR(label);
 
 	/* Request a thread to read the events */
 	ret = request_threaded_irq(irq, edge_irq_handler, edge_irq_thread,
@@ -2194,8 +2203,8 @@ static int lineevent_create(struct gpio_
 		goto out_free_le;
 
 	label = make_irq_label(le->label);
-	if (!label) {
-		ret = -ENOMEM;
+	if (IS_ERR(label)) {
+		ret = PTR_ERR(label);
 		goto out_free_le;
 	}
 


