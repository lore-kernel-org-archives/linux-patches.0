Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620DF23A9BE;
	Mon, 23 Jun 2025 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685090; cv=none; b=DQ12nITBmBbc76WTSUM91NQlTXZWOkjWnbnSqYoGhQ2TwuPHwt7xnKzjTj/5kuQuwZUkr7c/9PduD93GVddOAWr/tC/PiGmxTzFBF3TZYJqEpKaZyZJ/eUypIkqvJPqoTorpVXrSiO6++h3yvyIlp6pVkeJCX0S8zMVQu3uCN/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685090; c=relaxed/simple;
	bh=KCCMsxCi/ZH2ct8NE2l4UwKcnQXgU1FOsEan3koPNr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHnCSJ2pMqDalJomzMUwOcx+InnfAvrAKjWWJWaVhKV8JceoUlVfiea+NOMCONBl4a8EwTBkAnyAvsLHME4L/NqqvN5G75QL/dpJXWW7+ePsiIlT52/8+EQiEq/JrF8HNvHK6Jovlj217iDC6pyU/BeMq02zVpRglW0yz6yTHdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/1o0WeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/1o0WeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDEBC4CEEA;
	Mon, 23 Jun 2025 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685090;
	bh=KCCMsxCi/ZH2ct8NE2l4UwKcnQXgU1FOsEan3koPNr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/1o0WeEQNlDxEF2ADOEyGIV7L1bqTGZRk9Isw6CjwxrG9pPG726fyjjEXEREHMup
	 Jq3wzSFGp5yyI6QRgmOg7fvWwBxpTPdvWCmx0RFhInVRFY1FXAeVhBxIJLERQVI0YU
	 4Gtw4QrVIC1AXJfkC4/SSbfNtIkaB9rAnSzXRf8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 007/508] rtc: Fix offset calculation for .start_secs < 0
Date: Mon, 23 Jun 2025 15:00:52 +0200
Message-ID: <20250623130645.436620345@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Mergnat <amergnat@baylibre.com>

commit fe9f5f96cfe8b82d0f24cbfa93718925560f4f8d upstream.

The comparison

        rtc->start_secs > rtc->range_max

has a signed left-hand side and an unsigned right-hand side.
So the comparison might become true for negative start_secs which is
interpreted as a (possibly very large) positive value.

As a negative value can never be bigger than an unsigned value
the correct representation of the (mathematical) comparison

        rtc->start_secs > rtc->range_max

in C is:

        rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max

Use that to fix the offset calculation currently used in the
rtc-mt6397 driver.

Fixes: 989515647e783 ("rtc: Add one offset seconds to expand RTC range")
Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250428-enable-rtc-v4-2-2b2f7e3f9349@baylibre.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -323,7 +323,7 @@ static void rtc_device_get_offset(struct
 	 *
 	 * Otherwise the offset seconds should be 0.
 	 */
-	if (rtc->start_secs > rtc->range_max ||
+	if ((rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max) ||
 	    rtc->start_secs + range_secs - 1 < rtc->range_min)
 		rtc->offset_secs = rtc->start_secs - rtc->range_min;
 	else if (rtc->start_secs > rtc->range_min)


