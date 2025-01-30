Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD11E522;
	Thu, 30 Jan 2025 14:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247004; cv=none; b=ZyAM5njWkl3/JtF4lyJV6s10VMtFXre2tLF2K4GQlb1irc9hrk58CW2DFkBgTynIrayHbgRq1GdremuR0G9LdVG5PasDGA/nlz55PdFTjmzMPoZu0l6JWzDW25BxKrf0jluNkssKu8uN8srvWOz0pkDHZ0Wupk1c5wNl8U8DL9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247004; c=relaxed/simple;
	bh=I0JMaR4vRt4kqFxFvDotLmmJ/T0HKwEEO8ra3AmEpIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/aBtMq/d8ZgXWsNAIk9Z6pBOHqU3zvQR/uccq653rJSMhwgvFs42JzLXEV4y5j0D0Qnjt7giz2DgDd9xlIYs7rO1sD3cJBnAfH8SLukY3VjXGudTOu7xkqCPQcYjd2WthzHjcYWemIWyV7T1XbT8R2vIHvHh4UfzmgOpuNCAX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTTJsByE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTTJsByE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CE7C4CED2;
	Thu, 30 Jan 2025 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247004;
	bh=I0JMaR4vRt4kqFxFvDotLmmJ/T0HKwEEO8ra3AmEpIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTTJsByEaCzCB4dcr/Gy/c5IVx37SMG5N/EGDUjPK4oQRGoVstLehO+A0xUQgu8KS
	 zTYT2AnKyqqlH2jfiFnCJua+zLldZ65Fhk3xkMw6ULRgsStPxyaS7/o99h/hBz6+LV
	 ysgmttqPvNebUKZJBaYDzmtxvOPVySMGFdfVvEdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 049/133] iio: adc: at91: call input_free_device() on allocated iio_dev
Date: Thu, 30 Jan 2025 15:00:38 +0100
Message-ID: <20250130140144.496245449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit de6a73bad1743e9e81ea5a24c178c67429ff510b upstream.

Current implementation of at91_ts_register() calls input_free_deivce()
on st->ts_input, however, the err label can be reached before the
allocated iio_dev is stored to st->ts_input. Thus call
input_free_device() on input instead of st->ts_input.

Fixes: 84882b060301 ("iio: adc: at91_adc: Add support for touchscreens without TSMR")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241207043045.1255409-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -1139,7 +1139,7 @@ static int at91_ts_register(struct iio_d
 	return ret;
 
 err:
-	input_free_device(st->ts_input);
+	input_free_device(input);
 	return ret;
 }
 


