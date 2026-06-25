Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2031F03DE;
	Thu, 25 Jun 2026 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393115; cv=none; b=mx7ZeX6tQYlFvoXXnMsJpDKtmkWaa5WexlOwFYxnJ65d6fPAeQhspzcoJVgaBxdGh2dbxjTsTY5twGWLXg7UtYzEDLZFW94GtRmyLL61hwDU9ROWBFPixeP4JHGa8vZUP9vVpSH8migdjB8neE/2H5ysHRfvj2lFm+NqgKhGeg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393115; c=relaxed/simple;
	bh=olCU519ZFrropJcCoLXyGBuvp7p5Gbbw2rlPrX/d/PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq7x+76+jnhOtAyevx28gQJycxfSh+l+Cs5NaWdb9nUfeedeNCu26JGsnPXl0Teu5NQhVh2xooxx355HnBdJuFDvj5PHvhpeG/qAqPwS0VlMjXgqh8bXyhR37fjK6sX65SBsveoTN3Z2R6RMTeAvub7YDLl7+7f1/8SfwjNbqKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5CR3+pI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5CR3+pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF191F00A3A;
	Thu, 25 Jun 2026 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393113;
	bh=8zYMXJlIj56KeRDk3l35s/Byz7O82w8n0yzdix7Hzvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5CR3+pIhRZtMelBlHWsJeogjCyzIyC7ernoflZoFq16M9au/A8iPhc0/V8Q+fMDY
	 EJNphDSYG9ebcxHZX6OirZq/A1WoDycLuO1TrnjDRob55eRNynGQI+Qo0/lT6Q32+y
	 jRRvyt5rSai7diGFDgY+YdyHnTPxINBnfvPzKEhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 11/21] Input: rmi4 - fix memory leak in rmi_set_attn_data()
Date: Thu, 25 Jun 2026 14:04:03 +0100
Message-ID: <20260625125614.810059617@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a55a683a8e2bddb5467baab3e597a93022d4ee05 upstream.

kfifo_put() returns 0 if the FIFO is full. In this case, we must
free the memory allocated for the attention data to avoid a leak.

Fixes: b908d3cd812a ("Input: synaptics-rmi4 - allow to add attention data")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-5-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -183,7 +183,11 @@ void rmi_set_attn_data(struct rmi_device
 	attn_data.size = size;
 	attn_data.data = fifo_data;
 
-	kfifo_put(&drvdata->attn_fifo, attn_data);
+	if (!kfifo_put(&drvdata->attn_fifo, attn_data)) {
+		dev_warn_ratelimited(&rmi_dev->dev,
+				     "Failed to enqueue attention data, FIFO full\n");
+		kfree(fifo_data);
+	}
 }
 EXPORT_SYMBOL_GPL(rmi_set_attn_data);
 


