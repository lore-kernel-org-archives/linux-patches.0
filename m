Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C0C330B08;
	Fri, 17 Oct 2025 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715542; cv=none; b=Qz6gPiNoISZ+5wjzi6xxjfQDNQfiianBblTLjw5anTCzklq1u2yAElLmKs/fOO4vuZ0+E3ndn6IECosU2dXwlDqw/pnBSCxOe8vxt+fHXRpr0pn0a86AGnWJzyfnjKNhzXS9e3XtQcDpL46jnU3udIcEMggojsd+XYOAUtbKaVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715542; c=relaxed/simple;
	bh=P0zpcXLWbbsM0qI/ChZKnF0NR0eFHJaKdztxZbp+6cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/CvjC8oMiiTnjUXPRLngziulBoN+DcAiIt1rmYNrMdqkZbZ/p+TuV8dg6y+8L6jjrzsivvtIZ4ZCzc/w15+vyKqUN2O5Qq6cDYArssFoJmclebGEqTu5ph3BHAogcd1RUHek1e5xtyNy3hxHOgHbGX8pIHn/HotsRMDm8cm70U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZ+iWgVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZ+iWgVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B6EC4CEE7;
	Fri, 17 Oct 2025 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715541;
	bh=P0zpcXLWbbsM0qI/ChZKnF0NR0eFHJaKdztxZbp+6cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ+iWgVEhv3qwxOPjTxKKWildir7xFdXYGOv60dLqooV6gRtNIOo1VR8BilhvIb3q
	 NJLsM9/sXcaXYl7JHraj8EbGv2mYGcm+vH2OcONakDMPOxwVyNDV4zKvcgopAFg9OE
	 sJDy/L1RzwJ4eLfWDjWxx9+hw3PrkxC6eW8QdBlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.17 252/371] pwm: Fix incorrect variable used in error message
Date: Fri, 17 Oct 2025 16:53:47 +0200
Message-ID: <20251017145211.197159025@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

commit afe872274edc7da46719a2029bfa4eab142b15f6 upstream.

The dev_err message is reporting the incorrect return value ret_tohw,
it should be reporting the value in ret_fromhw. Fix this by using
ret_fromhw instead of ret_tohw.

Fixes: 6c5126c6406d ("pwm: Provide new consumer API functions for waveforms")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20250902130348.2630053-1-colin.i.king@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -276,7 +276,7 @@ int pwm_round_waveform_might_sleep(struc
 
 	if (IS_ENABLED(CONFIG_PWM_DEBUG) && ret_fromhw > 0)
 		dev_err(&chip->dev, "Unexpected return value from __pwm_round_waveform_fromhw: requested %llu/%llu [+%llu], return value %d\n",
-			wf_req.duty_length_ns, wf_req.period_length_ns, wf_req.duty_offset_ns, ret_tohw);
+			wf_req.duty_length_ns, wf_req.period_length_ns, wf_req.duty_offset_ns, ret_fromhw);
 
 	if (IS_ENABLED(CONFIG_PWM_DEBUG) &&
 	    (ret_tohw == 0) != pwm_check_rounding(&wf_req, wf))


