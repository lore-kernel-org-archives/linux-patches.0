Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F01D49DB9B;
	Wed, 30 Sep 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783889; cv=none; b=W3xpLn6cXmHOZh+UFl7cWJHrS+zoxW5WUq6uSfYJwiSKKTSwwEu1VLDgVzWuLP278sCG5cL4Emtd1LCDjUAk7cbwGTp0xOyrkhd0XzpupULZ/KbJajmbHodgtuGHu2bwzMQDcJOgPKiPDUOz4vcxFh2AB35VkqbR3JzL/A7H5PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783889; c=relaxed/simple;
	bh=vENXy3y1uUYiPiuFjPTh4WHyFBMMSj0DmoRNV5v56bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqFyhy/iBkNbHs2f5oQAbmeqnQhLTEZlfqg2JB4nlz42iany1Op+KSMClDT52LkcaYH++j2a2bLF8fQylgSgz/fnIGniJTQps7KYWdeHEyrBzbbkWAqwWRwcLlFuTVOjYYcGrMj/YKu0cvvMfrhmbJGXGqYkxcImjpst2trXebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npgZQIsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npgZQIsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E951F0089B;
	Wed, 30 Sep 2026 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783883;
	bh=r8JEMpi7YHDcPGp9H26qhSCJLAi/+VDych0bM5DNtrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npgZQIsxmbWYGvrgdpPOlI4OE2E0Vgd7YqaRQuAxebf/VDivuJcDbSqMStT2Aav7H
	 +2JaPjIG812dt6RqNyqxCe++LEoPcSIIizuA2JqmdU5ZErYu++do0g8C9Krsl6QRGk
	 gskfQNDZDR/gkdXYGIzNz+pGD91HDtrxf5f9lnJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 557/595] fsl/fman: Fix clk reference leak in read_dts_node()
Date: Wed, 30 Sep 2026 17:27:30 +0200
Message-ID: <20260930152359.698892054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


