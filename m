Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16184439325;
	Tue, 21 Jul 2026 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670962; cv=none; b=OPGj+X7LfrySm3H3UaTQHoY04YXwbB3fEBNqvoi7fnc+Lw2ij4ane+aycK5zjP17ogCPbTgzfEnM/uj48QyjlZTKOvQJeRpOABSmXmj54/guQD2cqrzzitfPh2duE7mhQZd+jbp0iiW9CMqY2eQCQ0Pex7Tkp++uspsuHPZUO44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670962; c=relaxed/simple;
	bh=o00N3nhaRT/C2ktahEZo9pDVVSyHXF2mElEShrhv1JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1LkBjHI/FNWuT1EeV1a07UcQN1oOrkDQGbm9ZQDQdNTq5uHNAuQxbO9+gplorAuD9k1slfaKpgCgjor2jRdwNWQhLUAmmSbQ8U9MzTx50H9DrazwK9ESdlGhRpSx7C+901Mn+9JJNXYPz5ctr87/YIY6w59GiUiARGL8Ttpe4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SPabVur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SPabVur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14EB1F00A3A;
	Tue, 21 Jul 2026 21:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670961;
	bh=NTrTY4qzJsJ7hFHmaX60scedfVFbC6ZVMxzH02Q9FLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SPabVurqr1tps6fVfrsPgEmOYbbbon6GrSRW0sxxcf8HSUa82akyDq973bxlwYrf
	 jypjIwWj0mM7InIR5RAKDUhRgQJctolmaDFxdqxgP7TWelwd8Du6FGsM/Tuvw06E8h
	 knelwFXY16GKNpoLsR56akdYgF5JUXVhVvsWDWj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 065/843] iio: temperature: ltc2983: Fix reinit_completion() called after conversion start
Date: Tue, 21 Jul 2026 17:15:00 +0200
Message-ID: <20260721152407.451039770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Liviu Stan <liviu.stan@analog.com>

commit 5cb9fdb446bfc3ae0524496f53fb68e67051701b upstream.

reinit_completion() was called after regmap_write() initiated the hardware
conversion, creating a race window where the interrupt could fire and call
complete() before reinit_completion() reset the completion.

Move reinit_completion() before the regmap_write() to close the race.
ltc2983_eeprom_cmd() already does it in the correct order.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1147,12 +1147,11 @@ static int ltc2983_chan_read(struct ltc2
 	start_conversion |= LTC2983_STATUS_CHAN_SEL(sensor->chan);
 	dev_dbg(&st->spi->dev, "Start conversion on chan:%d, status:%02X\n",
 		sensor->chan, start_conversion);
+	reinit_completion(&st->completion);
 	/* start conversion */
 	ret = regmap_write(st->regmap, LTC2983_STATUS_REG, start_conversion);
 	if (ret)
 		return ret;
-
-	reinit_completion(&st->completion);
 	/*
 	 * wait for conversion to complete.
 	 * 300 ms should be more than enough to complete the conversion.


