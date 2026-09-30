Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC6546AA9C;
	Wed, 30 Sep 2026 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797095; cv=none; b=KJaNvXc2zQ5BD3ARjIj1jjCjl8Mi/vb6fYD56UgLox1ypKLkwgBuofrGSfmXfzwJrqJsyFHga5oyMYwA2t4E522zeSLMxpZcNgrGtRvq8b66Lm8KSU0PXmcWJDYsQ23SyMnOZ0xBhq50tH6uhzdLX+kjLjHftrvBpgbBm1XD/fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797095; c=relaxed/simple;
	bh=iTIT/INscBhkLdPgoT5lrYVMloGZYQFTGipqz8hl+V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlgeqXrIixQwfUnGAPEYRxZMKIorMN48lFBdxdRMVVGLnsqxVRLmyWzZFw3lmu6tCQ9/r52Z4bfNXQlvVRjwcQp2pkMKM5NnqfEX8g2ypoor0iqDY1YZXYFmGy/txVP38fOZAueQ3CcskmJJm2m9PDWXi+Y1ogHw9+xTj8mchkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBAVHPG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBAVHPG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00551F000FF;
	Wed, 30 Sep 2026 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797094;
	bh=95YmBAxjTaRoEORySv0bzgE+bq/LgQ9GmnTV2m70RoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBAVHPG0nCEDCEwYK5brO4PD3PxdPjubEHyszXzXNteel90+XoUAPOLCK2dF97cnY
	 idYD10yzQKKuLsD4GrY9n2ooG2udkFpUfc5ldcHhH8uGlG2m7n1MTqBqaFudVng+IA
	 qA7Nu+eykOxE2lnljPLeHRPjUcPrSr7ddgM6e78Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1100/1193] fsl/fman: Fix clk reference leak in read_dts_node()
Date: Wed, 30 Sep 2026 17:29:44 +0200
Message-ID: <20260930152458.672214216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit a644f09b2090ad22a13fbcf9d141084f573108ef upstream.

of_clk_get() returns a clock with its reference count incremented, but
read_dts_node() only uses it to read the rate and never calls clk_put().
The clock is not stored anywhere, so the reference cannot be released
later either.

Release the clock once its rate has been read, which also covers the
error path taken when the rate is zero.

Fixes: 414fd46e7762 ("fsl/fman: Add FMan support")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260917110135.2148068-1-vulab@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fman/fman.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2747,6 +2747,7 @@ static struct fman *read_dts_node(struct
 	}
 
 	clk_rate = clk_get_rate(clk);
+	clk_put(clk);
 	if (!clk_rate) {
 		err = -EINVAL;
 		dev_err(&of_dev->dev, "%s: Failed to determine FM%d clock rate\n",


