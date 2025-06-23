Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C0524EF8C;
	Mon, 23 Jun 2025 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685250; cv=none; b=r7rb/jIwrdSjPCwVYkCTWne/HX1asS/HpU+M6lDqCgIBfErpJ+2rzrTfa5lnkbf9YCyy7SoCQhRNyzZBlf6SFKBXYVYd2JnhNPmTdR1CGHQ/45uwWKObPa5a8zy7HmOQ/xUvOdcLJaOMaF+MHspUBSCZlA+m3cQxj4S5pmcZhjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685250; c=relaxed/simple;
	bh=OYUwpms9Dsap5deIkXdK+wsDPV8Asv2Coyhu0UZVUEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcZQggbDMy5ygMuZSvCgFRvvvcj4oBVtKyHafPTGc64kxvoYzBPlhG/YslfMhNbl2dy2CoKFGUoQlD/dPuH5FUdaffEr5bj3Nt/0hTh6c0Vf3ex5rphPsbi7LWRt5nnBNdQD3UTHZCjF4GHzS12+sDF3aWWy3XBsQy9KY0n9x0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0hl76ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0hl76ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5962CC4CEEA;
	Mon, 23 Jun 2025 13:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685249;
	bh=OYUwpms9Dsap5deIkXdK+wsDPV8Asv2Coyhu0UZVUEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0hl76wwVnFGS7EP+yTQhOjeA/6s1WRd+VY3hgm7Z+sZ7GJ8itEeHxv6+uPH9T823
	 OaPek5ojvIZ00jz/OWSEhoZvnd5GL6QWELk8iKKZXlTZfoaOqtN15gLmY9GxSZzNeK
	 Wmrsp3Cu6VVyoGBSQB74igmVf7vVMws4xO0jtiwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 006/411] rtc: Fix offset calculation for .start_secs < 0
Date: Mon, 23 Jun 2025 15:02:30 +0200
Message-ID: <20250623130633.184293373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -322,7 +322,7 @@ static void rtc_device_get_offset(struct
 	 *
 	 * Otherwise the offset seconds should be 0.
 	 */
-	if (rtc->start_secs > rtc->range_max ||
+	if ((rtc->start_secs >= 0 && rtc->start_secs > rtc->range_max) ||
 	    rtc->start_secs + range_secs - 1 < rtc->range_min)
 		rtc->offset_secs = rtc->start_secs - rtc->range_min;
 	else if (rtc->start_secs > rtc->range_min)


