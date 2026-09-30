Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232CB263F4A;
	Wed, 30 Sep 2026 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789418; cv=none; b=ByRPFtzrLhn4D5PZk4/8xtjYJFD37jGNRCsm5ht/w2dq/5CJrakwXtIYLKfH4kyIwfr0Ny2XrcSkX2L4BfdzHDcQb26oC9dgJoyIFVjtq57NFZr9AKzYc+cRuCLLojYYkjqwETt+/6KnhgBSvTd/1uoBuT5Lt9fG5x69QC9Txrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789418; c=relaxed/simple;
	bh=rBom4iOBUf6yzBxqIZgC7RFcM0CJBqWZkT8ABvRSNPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og10evbK4rgnQ0mAb5DTnA2qi75KIsAc/3cIVHRhv8pYGn+N5d3CkTmfIxgSZTmV6jOA5wjQc0yJ4xzXTGp02AqvavASizET/C4GRIlH+AqHenTMqWJ0qKz1mV/01ze2NherI0KtgkMby8gP7aLi959jmIm4JnbZ7bUMNbhkryo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+uKWS2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+uKWS2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF61F000FF;
	Wed, 30 Sep 2026 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789417;
	bh=MwwmSgwOz2PaYJACENIYI/3Ydis6icz7yvUidXd9Cqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+uKWS2xOp/Ha2L8eRSIrLSv9p0YIc148zejDC2RCDT74qjtr5SK7QL5CAD5RpLAN
	 1U3vRiKc9NWB5F4vfStdgkNnOGs94J0rajlV4wKJh/+NDDZAIQeamxDCLYE1Gu8hLG
	 0hzXvWjPLQcbKZr87OffNlvlTQfgT5l4Sq0xCET8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 470/877] fsl/fman: Fix clk reference leak in read_dts_node()
Date: Wed, 30 Sep 2026 17:23:01 +0200
Message-ID: <20260930152424.818316850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


