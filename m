Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B49273722;
	Mon, 29 Jan 2024 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548534; cv=none; b=Yu3akYgpcr+nCoZB6wSfqRl4avhpkidbuDwUt7qFtE3dE+PbhQudUIa4GK11nuQSAm7CYAUDqe3i5KbNH1ASsEpPg3boSABy4VHG60g+ARV86VCixAWzWnhBL6vh0i1OBt35gi7iOZdq9J14BiH46TCIngilMHnsCxQIqAyApG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548534; c=relaxed/simple;
	bh=LNx7qKJmfE+jxcdsR1Bc4XtbSpZgrJzDn8JVAUFFJeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjgZU5XD/k5ayfV1yI1db4MXyhfOQZ7frgonzL0Tf1/HPtPe8GaKl223ZYrNOuxcIVZZfMFtZW0apOHN+ASXf7xlQKsAlRSDqzfA1nLVFsA2HxT9LQk8E+aLFnpUgfl3q1vYOPridcZjZIkh7TbXQHCjMPZcX/alCah+dXKX24Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPo5VOgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPo5VOgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5327EC433F1;
	Mon, 29 Jan 2024 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548534;
	bh=LNx7qKJmfE+jxcdsR1Bc4XtbSpZgrJzDn8JVAUFFJeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPo5VOgKsHdYGOtuK0vn6KkbhUJ4xovynjnbbvkrV1Aq5vJpWr1xEuiA/e31/R2Tq
	 E5Fpg5GWdGcLq7QMQGW/DR37k1LV9tPnFcWNJPpYkmmpIJzywDVngq07LBI4sYnww+
	 GaDio9za7TsFYGTUzJGF6HtgNNiRnSTrz60ymUoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 136/331] serial: sc16is7xx: improve do/while loop in sc16is7xx_irq()
Date: Mon, 29 Jan 2024 09:03:20 -0800
Message-ID: <20240129170018.925046627@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit d5078509c8b06c5c472a60232815e41af81c6446 upstream.

Simplify and improve readability by replacing while(1) loop with
do {} while, and by using the keep_polling variable as the exit
condition, making it more explicit.

Fixes: 834449872105 ("sc16is7xx: Fix for multi-channel stall")
Cc:  <stable@vger.kernel.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-6-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -782,17 +782,18 @@ out_port_irq:
 
 static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 {
+	bool keep_polling;
+
 	struct sc16is7xx_port *s = (struct sc16is7xx_port *)dev_id;
 
-	while (1) {
-		bool keep_polling = false;
+	do {
 		int i;
 
+		keep_polling = false;
+
 		for (i = 0; i < s->devtype->nr_uart; ++i)
 			keep_polling |= sc16is7xx_port_irq(s, i);
-		if (!keep_polling)
-			break;
-	}
+	} while (keep_polling);
 
 	return IRQ_HANDLED;
 }


