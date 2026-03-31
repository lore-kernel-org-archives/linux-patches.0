Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0562FDC5E;
	Tue, 31 Mar 2026 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976789; cv=none; b=MSqmlAqetIyHDbdnSMdlP5trzl2t2bv3jK7FLm9btYrZL+hn3uOOlN1dIfldlHnC7eH0ZELXJN+SF7KdbJhnauvtTPa1q6nBCCcKILna1pk9NGanxACFPBxLQOmUIq3yUexVfejhq4fQUXkF7reSH6+6GSGo7MM4r2mm3k9DdpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976789; c=relaxed/simple;
	bh=EXKvkDCQcFQ8KY+gY7KUkEmbBW5J5iW7LLJvYKFfe70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Va6GWU7rPp3S/mr2UjoUa9bL/D9+X/k4y4c4g9LYUINIdkjxeWYU171K9/jm/b928wX5CkY6oRTwQgHDNVXumabRXU/1va6DX7PSB3n5izFZd00kw6tWhM90n16sYYcm1WDJqp6csdxvZw7T7ZCa7ftLjQAM2PIJ18M7Yu+qVa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp7fXuMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp7fXuMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7167C19423;
	Tue, 31 Mar 2026 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976789;
	bh=EXKvkDCQcFQ8KY+gY7KUkEmbBW5J5iW7LLJvYKFfe70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp7fXuMrA/ur+yxJ2iLuqX4M8wPqBty5dz/HaOFRsdnxE4TSDN1/YkLlJl+4n8xFu
	 aa9dW55gxsgGKR1WAnsrasQZfGQIaGIHGvgwfmWU5oCvB/Ah+vSW68RgwJ89u4i6hD
	 qBRxXGadXduSDxQlCcsn0CTfkBZMqrOfBSwBy7J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 228/309] i2c: imx: fix i2c issue when reading multiple messages
Date: Tue, 31 Mar 2026 18:22:11 +0200
Message-ID: <20260331161801.838892142@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit f88e2e748a1fc3cb4b8d163a9be790812f578850 upstream.

When reading multiple messages, meaning a repeated start is required,
polling the bus busy bit must be avoided. This must only be done for
the last message. Otherwise, the driver will timeout.

Here an example of such a sequence that fails with an error:
i2ctransfer -y -a 0 w1@0x00 0x02 r1 w1@0x00 0x02 r1
Error: Sending messages failed: Connection timed out

Fixes: 5f5c2d4579ca ("i2c: imx: prevent rescheduling in non dma mode")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260218150940.131354-2-eichest@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1522,7 +1522,7 @@ static int i2c_imx_read(struct imx_i2c_s
 		dev_err(&i2c_imx->adapter.dev, "<%s> read timedout\n", __func__);
 		return -ETIMEDOUT;
 	}
-	if (!i2c_imx->stopped)
+	if (i2c_imx->is_lastmsg && !i2c_imx->stopped)
 		return i2c_imx_bus_busy(i2c_imx, 0, false);
 
 	return 0;


