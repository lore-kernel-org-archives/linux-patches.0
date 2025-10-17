Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7605695;
	Fri, 17 Oct 2025 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713145; cv=none; b=PmjdeWJvuvtrU/MU0Lf06mMYJIzg7xOetL8UJR+0ClhIL4R7KkM1GdD7XiUMuOAVOIbkfDXS/UMQ6UaJ7fRVi9LA8NzQETRAbquLU4QZ+08/iRqyXlF8V+wK829702eR1Iv0nkRN9Hsm1aYPcVmb0O8vx1M/NlJ1HN+Jm/EUcAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713145; c=relaxed/simple;
	bh=B213RrO1cXTwr3yQ6aikYRiBeLBdxdt8duXJYMyLa4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3/aGLDzr5MYVduv5fsyKByKHxjZ1EVp0a3IA/Ray3nhmInFAg2dNutjPyYAFi0GKEzvez3EVKCdzJWb5bPy6bcqbrkDrlQjuM2qhNEjPMCGx9N4BUauB4RLL3N8q1SDpfQszJKiDuFL+GsWp8lglF53NMXfO063e4rtfBP/YSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqKlFdi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqKlFdi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16663C4CEE7;
	Fri, 17 Oct 2025 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713145;
	bh=B213RrO1cXTwr3yQ6aikYRiBeLBdxdt8duXJYMyLa4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqKlFdi4RB2aDJq3ZKqricmhx+48YZO5I2MplCoH85x0HJDAPo9OHNlqXdgTNKRtl
	 DjQOjsbB+hiZ76iHvhVl4tjfJz9pY42QZ1oUYCauhDp+aOAibILh7lKUn51NgY4vgA
	 WLUs1PRUnl9rTLmg5+x67r9UPvF5tQKGJPmUUHAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 064/168] media: i2c: mt9v111: fix incorrect type for ret
Date: Fri, 17 Oct 2025 16:52:23 +0200
Message-ID: <20251017145131.382040965@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit bacd713145443dce7764bb2967d30832a95e5ec8 upstream.

Change "ret" from unsigned int to int type in mt9v111_calc_frame_rate()
to store negative error codes or zero returned by __mt9v111_hw_reset()
and other functions.

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9v111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -534,8 +534,8 @@ static int mt9v111_calc_frame_rate(struc
 static int mt9v111_hw_config(struct mt9v111_dev *mt9v111)
 {
 	struct i2c_client *c = mt9v111->client;
-	unsigned int ret;
 	u16 outfmtctrl2;
+	int ret;
 
 	/* Force device reset. */
 	ret = __mt9v111_hw_reset(mt9v111);


