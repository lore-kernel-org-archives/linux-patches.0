Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794991FA859;
	Thu,  2 Jul 2026 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011681; cv=none; b=qvp42Y/CUNGmIfLv9phWb+qGxPa1Ks6DkQq/fCin9GzTTlp4HCU6d0v/4Z6FKhdWuCmYpvL6J7O1ny60pI8j5jWnOzW4aRmFB7tgMM8msdmeyBi21Z32O5HERr3qiUW+QyqU4PETh0MjenaYry8wViVij08Dsm0OmPOvu2UuGHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011681; c=relaxed/simple;
	bh=ifwUEELtEdjf/DUE2IsyUgvUQvRyAYE/M2YIgZHddvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEhJ+8sQjLBRcPkmLRQ1xwOaFChY/tuJcaoSEYCbPqck3VX4QPHq3PbRgN7vkSMeLGC0pDcxX4AdytaCP1GTaJwElCKkLv5+CSFpdX+s8H7GUKRuzTdOhLwIX4zh/QQadc1DkKoxF5aHP5cnKtiHDQXfeVnAM5PYi5cC4xCFhdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8asmDWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8asmDWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8B11F00A3A;
	Thu,  2 Jul 2026 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011680;
	bh=DAJ0SATjVtrdIm1DJWVQy7jssgN2MxXAsCp21Bz61Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8asmDWqOlufTy4Hi5rsbujndTfHjZtr1Fmj/RpI2Ph9YFp4WZ192ftN2QVoEpZYY
	 NrAxsNEWXvVrUbKQHCurhHYpPnV0iNO5GAYAc0oVyZYiUCnIHlEG7Nvhl91cCOVBJK
	 xohzMPEfv77IVdw9WZwmT4Xad848gfaFnulFB2XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 7.1 090/120] rpmsg: char: Fix use-after-free on probe error path
Date: Thu,  2 Jul 2026 18:21:26 +0200
Message-ID: <20260702155114.820542435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

commit 1ff3f528e67d20e2b1483dcaba899dc7832b2e6b upstream.

rpmsg_chrdev_probe() stores the newly allocated eptdev in the default
endpoint's priv pointer before calling rpmsg_chrdev_eptdev_add(). If
rpmsg_chrdev_eptdev_add() then fails, its error path frees eptdev while
the default endpoint may still dispatch callbacks with the stale priv
pointer.

Avoid publishing eptdev through the default endpoint until
rpmsg_chrdev_eptdev_add() succeeds. Messages received before the priv
pointer is published should be ignored by rpmsg_ept_cb(). Flow-control
updates can hit rpmsg_ept_flow_cb() in the same window, so make both
callbacks return success when priv is NULL.

Fixes: bc69d1066569 ("rpmsg: char: Introduce the "rpmsg-raw" channel")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260601183247.1962010-1-dbgh9129@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/rpmsg_char.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -104,6 +104,9 @@ static int rpmsg_ept_cb(struct rpmsg_dev
 	struct rpmsg_eptdev *eptdev = priv;
 	struct sk_buff *skb;
 
+	if (!eptdev)
+		return 0;
+
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
@@ -124,6 +127,9 @@ static int rpmsg_ept_flow_cb(struct rpms
 {
 	struct rpmsg_eptdev *eptdev = priv;
 
+	if (!eptdev)
+		return 0;
+
 	eptdev->remote_flow_restricted = enable;
 	eptdev->remote_flow_updated = true;
 
@@ -490,6 +496,7 @@ static int rpmsg_chrdev_probe(struct rpm
 	struct rpmsg_channel_info chinfo;
 	struct rpmsg_eptdev *eptdev;
 	struct device *dev = &rpdev->dev;
+	int ret;
 
 	memcpy(chinfo.name, rpdev->id.name, RPMSG_NAME_SIZE);
 	chinfo.src = rpdev->src;
@@ -502,13 +509,17 @@ static int rpmsg_chrdev_probe(struct rpm
 	/* Set the default_ept to the rpmsg device endpoint */
 	eptdev->default_ept = rpdev->ept;
 
+	ret = rpmsg_chrdev_eptdev_add(eptdev, chinfo);
+
+	if (ret)
+		return ret;
 	/*
 	 * The rpmsg_ept_cb uses *priv parameter to get its rpmsg_eptdev context.
-	 * Storedit in default_ept *priv field.
+	 * Stored it in default_ept *priv field.
 	 */
 	eptdev->default_ept->priv = eptdev;
 
-	return rpmsg_chrdev_eptdev_add(eptdev, chinfo);
+	return 0;
 }
 
 static void rpmsg_chrdev_remove(struct rpmsg_device *rpdev)


