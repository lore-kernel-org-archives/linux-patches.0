Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B8D274FDF;
	Fri,  9 Oct 2026 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557641; cv=none; b=st9il98NcBVgldJ9uALtUNHFQFFM0yB/zvB1U5hi2YPnYNVAUVGMetTL0MCwqHobU4msjR4GtuB2BCG3OQLOnno8xbtcBAfNFXv1e4GxOXaPzodLswinl1ex/15oyAagvpHC8bgZW015D6kP2WLdD/VgVJoQY7pKCPK3FL2weqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557641; c=relaxed/simple;
	bh=RKmoOMN6ZYgYciejv0GLRZ7L0XIwHmdKwWJsXToDHzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUT2uleuYjiYNy4ukQkGBkZJftb4BO4z7OUloFI6Ove/1/5oK/zwle60XTY7XDCFldXSvuiRPQomvjGsP750F1ar9ae/PFMbSqyU/CEkauY+R5Go7ZmvzFxchAaI4IyYUO8PuYiuedC/6GedTXXNOhJ44vvdsssUY2Idfsu0zO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s6MwJeb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s6MwJeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B031E1F000FF;
	Fri,  9 Oct 2026 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557640;
	bh=0TTkqH94I5Sdsn8nQefD3/LhtAvUAs1+8Go4IA9agw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2s6MwJebqDB4tElVt0GIkDtuSlxaEfwqSEiveNZzLFmTzIX4PO14L8QTRsfxsDn/8
	 bR21gaDoLG+Zer65my09+qbfiQqfnHpO3KlDCv0e13c+MI7rQea/6FSrRPjbdoU7QI
	 iZPbSbhPyH/+AeBh7zB0Z6Ykyhhf1VPaoTUCKURA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 394/428] iio: admv1013: initialize callback mutex before registering notifier
Date: Fri,  9 Oct 2026 16:12:11 +0200
Message-ID: <20261009140954.863136687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit baf7e43b7fb5afb777353bf265ddf9d909f72b9f upstream.

admv1013_probe() registers a clock notifier whose callback takes st->lock
on POST_RATE_CHANGE. Initialize the mutex before
devm_clk_notifier_register() so the callback cannot observe an
uninitialized lock during probe.

Use devm_mutex_init() so the lock lifetime is tied to the device and
cleanup stays paired with the rest of the managed probe resources.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -601,11 +601,14 @@ static int admv1013_probe(struct spi_dev
 				     "failed to get the LO input clock\n");
 
 	st->nb.notifier_call = admv1013_freq_change;
-	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+
+	ret = devm_mutex_init(dev, &st->lock);
 	if (ret)
 		return ret;
 
-	mutex_init(&st->lock);
+	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+	if (ret)
+		return ret;
 
 	ret = admv1013_init(st, vcm_uv);
 	if (ret)


