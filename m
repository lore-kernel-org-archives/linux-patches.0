Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C4C503918;
	Wed, 30 Sep 2026 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787529; cv=none; b=szLoWnp291NbyxSQErlCrDu5iFKRwGPwedvcRyZLOfFH8fK6neiQKNBm0UWoN0Eg1emdzYPICP7kvJuiY7ss5nyY2a4J19/NXt+cX3TgInEoTsnUO0ahZb5JI42BSnWmHOS1Bb4WsPXhT2pgW7fI/4aDcVblF9wrk4OkmVz23CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787529; c=relaxed/simple;
	bh=gKrY6Q7j9iJrRd7aU1TQzIdLWGSqmslhA/ga/xKnbMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5WbTYvTlbos3IopuZzEDCcf/7UR+MaQJASWoFRB9y5WstZ7ILEDL9JOmyul34aeNmXViHcrPwETN/0Z5K2WA6Es1TzLJoJkLLXcYGownxyo86eXeIIbWu3X/AIi1SHa9ngXSqe/my30hKIgHZJhSoSxH2Ux9Pmvc8b4bJ/ee7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKlX7Ser; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKlX7Ser"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1E51F000FF;
	Wed, 30 Sep 2026 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787528;
	bh=k2OcJlqXes3a18gZRk1k9sxOG/BNRj3ks/0HZKKkU0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKlX7Serax8DIBEekmJETzGjCizSzBlwEGOwoJGBnB4U/JDR4lcIuSmX0pAuJMqPM
	 ZuWIAncX6HtxzK/7JDpfiqY9/KZXRL08nUOY2rIojbvlF5k8c8wgVmKZzaO6KtMVL9
	 ghWIwRozQ9h6wlmnnBQFCP2GUkao9p3bv/Y+YhLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 263/457] fsl/fman: Fix clk reference leak in read_dts_node()
Date: Wed, 30 Sep 2026 17:26:08 +0200
Message-ID: <20260930152351.722073559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


