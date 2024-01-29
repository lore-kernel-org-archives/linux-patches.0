Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C31972242;
	Mon, 29 Jan 2024 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548510; cv=none; b=uXROWwCC4ML0V60utGitngXlOACzVpiUReb7Yv7mBJxtPg0EcP66jRiqYhE7OkKJsgXZOOJDkUkqayMJk2EWWYky/OYPmf6Fn7ooI1q7mIuiuYoY2PpoyciWHiQrKIfGkIi3nFWRk91CXCK6dEUIE/ISioWR2lhwWp+39uDkVzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548510; c=relaxed/simple;
	bh=h2VQISnyDB+5ZKAeHKGUYy0iuS34quGl2YKO9NKj2WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oN7RQ/LmYMdrrhEhHa5GMFYBtpxPsyxZyiLsA01T6oxGzWCamlTIUgQ63MjevYbZWnRKT6kaN1RbHZ1KBvOYtr6jaMQkjph0n+8REbhmWUyNbgKxFE/TN3oP//DdUSEedYaB74rctonMKz7Y/YiVlpZGJQjnu/XdZabBz+d+eNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiAwJLnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiAwJLnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148E7C433F1;
	Mon, 29 Jan 2024 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548510;
	bh=h2VQISnyDB+5ZKAeHKGUYy0iuS34quGl2YKO9NKj2WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiAwJLnxQ9B5gZ0yTDgEQYG5XA1QPdYusQgt/MP1g1QTzrowfLUVljwpeuwdix7nN
	 zz/56Iv9HJYwSrzrg3hhpe1GNbL1kM8UAYhwFO16aW3AJGjeDtoM2rAzAZeBA/r7qZ
	 J6a4vHRIPhDcCDhIF6UL7cdZD9Odivvbs6E9EBQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 116/331] rtc: Adjust failure return code for cmos_set_alarm()
Date: Mon, 29 Jan 2024 09:03:00 -0800
Message-ID: <20240129170018.322070744@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1311a8f0d4b23f58bbababa13623aa40b8ad4e0c upstream.

When mc146818_avoid_UIP() fails to return a valid value, this is because
UIP didn't clear in the timeout period. Adjust the return code in this
case to -ETIMEDOUT.

Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc:  <stable@vger.kernel.org>
Fixes: cdedc45c579f ("rtc: cmos: avoid UIP when reading alarm time")
Fixes: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231128053653.101798-3-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -292,7 +292,7 @@ static int cmos_read_alarm(struct device
 
 	/* This not only a rtc_op, but also called directly */
 	if (!is_valid_irq(cmos->irq))
-		return -EIO;
+		return -ETIMEDOUT;
 
 	/* Basic alarms only support hour, minute, and seconds fields.
 	 * Some also support day and month, for alarms up to a year in
@@ -557,7 +557,7 @@ static int cmos_set_alarm(struct device
 	 * Use mc146818_avoid_UIP() to avoid this.
 	 */
 	if (!mc146818_avoid_UIP(cmos_set_alarm_callback, &p))
-		return -EIO;
+		return -ETIMEDOUT;
 
 	cmos->alarm_expires = rtc_tm_to_time64(&t->time);
 


