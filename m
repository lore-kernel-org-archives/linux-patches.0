Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E625218B2;
	Wed, 30 Sep 2026 18:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792722; cv=none; b=pBNY/a6Vvny0GzBY1/ih54EdU92g5ff0L+PK35MoSCN1WpIkp8imCfnpxGbe/ODLgMllkUHIP2V/jUYCiuqHSmMh7E7XhaJJO6/Vq5Ay+Ik+8jIctBJ+GeOiJZ+OVgTHMcdYQzVSQFvZ5yLFUfvOP1yCWRjxV7rXtBYh80TR6gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792722; c=relaxed/simple;
	bh=vVHruRzJFryP+Ia7PREWpvAQkC1T9h/HdBPuWf1SjCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNSmc+jigA1vhRxy4PyGoyc5AXy9gVp0jZoFCq4U5ik6tXyGt5m84xPAG4fvdyNF8tf1TrbJWwUc9vsrH/Lxt3yL2G2WIl7PAMlBx0LO6bf9thY+tDbMoL1xetimTKVL2lSTeoiYMvJRj5PhqKvr4ue7ohVdHsTouPORQyPqWdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPPVzX4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPPVzX4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AED1F000FF;
	Wed, 30 Sep 2026 18:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792721;
	bh=NSAlsEroJahW1Z5CJ1elFPlevH5BEc8lTLsa96hG5fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPPVzX4j4RdIVgHXqPQeeTYfnTOUqkt8Fa58BgoyMSg8C7gx2aekuNzpH4b9bqnoT
	 EltlV0DC2i1QhoIU2Jgj6MGkyYsMfbthBZZfgrWs3wsxA0jjyZDmZx97nJ+glvVzYF
	 tBNZukUVIXC2fyDeaM6N0WDy0JxCZIDzQkkeuq/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 701/752] fsl/fman: Fix clk reference leak in read_dts_node()
Date: Wed, 30 Sep 2026 17:29:31 +0200
Message-ID: <20260930152413.403516229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2778,6 +2778,7 @@ static struct fman *read_dts_node(struct
 	}
 
 	clk_rate = clk_get_rate(clk);
+	clk_put(clk);
 	if (!clk_rate) {
 		dev_err(&of_dev->dev, "%s: Failed to determine FM%d clock rate\n",
 			__func__, fman->dts_params.id);


