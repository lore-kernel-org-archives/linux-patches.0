Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAEF3AD539;
	Wed, 30 Sep 2026 18:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793481; cv=none; b=q5X2ZsT7enJgt+D8moa0Lo665xuz4q6EJlHdI5mTX+CxNe5PbJQ79qyaboFGb7Inn2/JmDhbHFCKfMtYuY/0WsCtAy3sAp2aH3uL9MQsmnhHU4fMj3wRae+um+GZx10uKQqAkGrper1ha3R4byr1GtFiRUBaAninqbzI33q0xgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793481; c=relaxed/simple;
	bh=MuxARrRBuqIzMNjVMq2kGENRP+aGoPEVlYXcrPfXqjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJPieHaungC9krvwtrTgs9UzjZHcyH+hfiQK5hn9QZBMX9qycnoTSI0rA9dHLEUA8Hs2HhfrwsJO8FoNOgvJe2wtEd5DGyA79CtdX7dsAWbzdtiyM76uY2XV1hrzaAiHYuWRYTtAuauyIkoj/WLjgPvf5Qce48Xj2fdU8jnhj2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSvNT1wo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSvNT1wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3378A1F00898;
	Wed, 30 Sep 2026 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793480;
	bh=etc/h06m+oda1XaeTFCcrYGsAaeCXydnHI1GFJLJpQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSvNT1woMOUzSVC/XI+G1juLBwQOsTqpin1JKBdNNhOwuhvk1CHNxOOFT+gYCHOTe
	 yBlMhNxQ6jITvUKLOBhiiHyikH3/jUio1GdBLRXdVM7vwaMjhJfXNTwJOtF26g3hJr
	 Aa1vQvx4WBvzrSss+3M8p4NqqdQFUxZX+ZA8ig38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 225/395] fsl/fman: Fix clk reference leak in read_dts_node()
Date: Wed, 30 Sep 2026 17:28:07 +0200
Message-ID: <20260930152345.541547381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -2734,6 +2734,7 @@ static struct fman *read_dts_node(struct
 	}
 
 	clk_rate = clk_get_rate(clk);
+	clk_put(clk);
 	if (!clk_rate) {
 		err = -EINVAL;
 		dev_err(&of_dev->dev, "%s: Failed to determine FM%d clock rate\n",


