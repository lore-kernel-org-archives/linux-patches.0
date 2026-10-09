Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6F3BD64D;
	Fri,  9 Oct 2026 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556088; cv=none; b=eGnCfpCNgHo5VWDxCk7T8SYah6r6iXf0uaAs6CdozoIwGOQsYKoTPAJUWbFr2ex4kcT2y3GFRkOWbbGhbYZqsUrJ4gGLZuPE+xgyAQFJM9iw2th67GhMIKETeJ1Tdk/grq88Tz0Hpi3Mx3w125ydU11MMOtN9u16Lf1ABbYKJTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556088; c=relaxed/simple;
	bh=3y15ago0hJGHb4l7tnZ2lCcy/M+Ka5imEVEmENp7O+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RShEfq+q8YwDza+KpH1SjJioRZ+lT1QqF+MLayA29vPzXzplEU7ECPhrMrKUhTEI18+BYXcLR4Usd0AaQKox+yaY45eWidptJuNuH7PJHmtd/JhAyHbD1o5LFl8ZTWeF8/S4kTnEA4I8BjE40q1MqlI+XwqcLNIQempzjfk4w4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAl8SAQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAl8SAQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC01F000FF;
	Fri,  9 Oct 2026 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556087;
	bh=jPAIC3hsnfhwfx4mi1kzSeduPJGxSP6JZ3zMM8FfXmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAl8SAQAzyjc2EZ0/pNOdgD9tgtmk1/B4r3LeSW+1WjRI6ZEUwNVuQX02WkzbDTdw
	 CpYTy9fVAeZyCJJYeAdKiCWQk0zZA+wrmT9T11XKLNjaAfJYGgadZXog4dgH31BqHF
	 +NB2Njnh+NFcX7R8ynQ03ePjbWRorVTFBGh9rJF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 172/403] usb: typec: anx7411 - stop the IRQ before destroying the workqueue
Date: Fri,  9 Oct 2026 16:08:53 +0200
Message-ID: <20261009140956.134570078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 469600d5d292b1482c90dd6853555821d11b8c5f upstream.

The IRQ is devm-managed, so it can still queue plat->work while
remove() is tearing the queue down. Disable it first.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260910011150.2966843-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1567,8 +1567,11 @@ static void anx7411_i2c_remove(struct i2
 	anx7411_partner_unregister_altmode(plat);
 	anx7411_unregister_partner(plat);
 
-	if (plat->workqueue)
+	if (plat->workqueue) {
+		disable_irq(plat->intp_irq);
+		cancel_work_sync(&plat->work);
 		destroy_workqueue(plat->workqueue);
+	}
 
 	i2c_unregister_device(plat->spi_client);
 


