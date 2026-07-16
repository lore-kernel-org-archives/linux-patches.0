Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392D41F7D5;
	Thu, 16 Jul 2026 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209191; cv=none; b=PeFSTV9wtcRwtBBflhwCqFMfWyXhlYylJY9J+G6J94N4CsRnCmkP3YFOB7CtprEHnI4C5SpBpNByaIVyQt9NV1qNZYFnNHhVRS5s/rYCya2X9K2HdFxMC5vreMel+WIYC0maKczx5egHRuHjlhZ2MiT4wZzHpsOBmEqgvtUhWRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209191; c=relaxed/simple;
	bh=pQ847XG6XD/s0F5pShDECYo67fhPdq8ssFjycOsK7Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lneLEhNYEQGsZRErfbxd+wK1Mc9tiJ59wUroRWTMz0jiMzkzSDJFD6MgvWcR85FnKMVR4QVoE6Mwo3q9L0V73bolVrTvoyZlIdAFStW9retFKT07aU3XE3rQ8O/gDndAxL3ZzBd0gy4XW4uOccgrJjO5IFFLrmALaXiZ1+K1ABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gD4XdzTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gD4XdzTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2FA1F000E9;
	Thu, 16 Jul 2026 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209189;
	bh=x5DxWwW6bKoMUpRCHpkcqwbbEMFV6qV0ulmsX1vWsCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gD4XdzTU50oRzaPi0yokq0kMs0mvdUbnJxdGLdjGjTs/LJokyGEgWh02IOznvxBP2
	 HRVOg3/A5azF1ljvVOEEqbe+LKtoA/YRBN8IfiFGSiEH3gy7WCZVVn7pyJiILl4l+r
	 9oO9F5MNAfxTq0hwk5lgX04s9TaCDe7E/FhybEtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 074/518] iio: resolver: ad2s1210: notify trigger and clear state on fault read error
Date: Thu, 16 Jul 2026 15:25:42 +0200
Message-ID: <20260716133049.406108348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit 70247658d0e783c93b48fcbc3b81d99e992ff478 upstream.

ad2s1210_trigger_handler() walks several scan-mask branches and uses
"goto error_ret" to land on the iio_trigger_notify_done() teardown at
the bottom of the function for every I/O error -- except the
MOD_CONFIG fault-register read, which uses a bare "return ret":

	if (st->fixed_mode == MOD_CONFIG) {
		unsigned int reg_val;

		ret = regmap_read(st->regmap, AD2S1210_REG_FAULT, &reg_val);
		if (ret < 0)
			return ret;
		...
	}

Two problems on that path:

  - the handler returns a negative errno where the prototype expects
    an irqreturn_t (IRQ_HANDLED / IRQ_NONE), so the caller in the
    IIO core sees a value outside the enum;
  - iio_trigger_notify_done() is skipped, leaving the trigger
    busy-flag set. A single transient SPI/regmap error on the fault
    read then wedges the trigger so subsequent samples are dropped
    until the consumer is detached.

Convert the error path to "goto error_ret" so the failure path goes
through the same notify_done() teardown as every other error in the
handler.

Fixes: f9b9ff95be8c ("iio: resolver: ad2s1210: add support for adi,fixed-mode")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/resolver/ad2s1210.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/resolver/ad2s1210.c
+++ b/drivers/iio/resolver/ad2s1210.c
@@ -1334,7 +1334,7 @@ static irqreturn_t ad2s1210_trigger_hand
 
 		ret = regmap_read(st->regmap, AD2S1210_REG_FAULT, &reg_val);
 		if (ret < 0)
-			return ret;
+			goto error_ret;
 
 		st->sample.fault = reg_val;
 	}


