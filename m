Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF112210E3;
	Thu, 12 Dec 2024 17:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023566; cv=none; b=p4ieFvVRe8d6R2kSzN7Hij9AzFWXRSdEexLoL3Hj0lMFQDX4NascxtgULqLQ8A7wbVT6LK54yJq75vkxKSysgmzSuS9lCiwMNo9kcZAZlBpq3C7kkAMKWWXkU+uydPZHFOj+NJJIpJP/bLrO7PsICNTaJrA3D5j7CAKBu9TR6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023566; c=relaxed/simple;
	bh=T13E6lUa/mRPR5ZG4ox9E5HAIM3BnaLEgXN4rTR2IdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1ZP4GIr0QY23c3GalQx/HGfpTufHS+suKBurS67LsMTsBzaw1yVAwSNZtm87EAdBltyDi2/8N/KUv4xP6SdkrS1kJRN+SrZP8bx0pjl8R6amqaOtfBvDusuC4xs9llLobGv110/SLTjR1Nu1eXMnZW+l61mZaggoCVqtOhBidE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ne9mxIOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ne9mxIOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62534C4CED0;
	Thu, 12 Dec 2024 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023566;
	bh=T13E6lUa/mRPR5ZG4ox9E5HAIM3BnaLEgXN4rTR2IdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne9mxIOeLjAY8pg5cNSHvzkg9T/Dtlyfh2OyO3RkNP1Z3VtqxVn/DVI2yV5Syv31Q
	 yD+TG0FKe+K4gF8/X3jxE9uPjNEMpspV9d+VBoxg1dtZwr9DQwf5PTfoB4sZhsKOkw
	 O5bzmuhwT4kBLt+TjNRfdNwf0T7rXOfzp/R8zDSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 010/459] leds: lp55xx: Remove redundant test for invalid channel number
Date: Thu, 12 Dec 2024 15:55:48 +0100
Message-ID: <20241212144253.933033973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Vokáč <michal.vokac@ysoft.com>

commit 09b1ef9813a0742674f7efe26104403ca94a1b4a upstream.

Since commit 92a81562e695 ("leds: lp55xx: Add multicolor framework
support to lp55xx") there are two subsequent tests if the chan_nr
(reg property) is in valid range. One in the lp55xx_init_led()
function and one in the lp55xx_parse_common_child() function that
was added with the mentioned commit.

There are two issues with that.

First is in the lp55xx_parse_common_child() function where the reg
property is tested right after it is read from the device tree.
Test for the upper range is not correct though. Valid reg values are
0 to (max_channel - 1) so it should be >=.

Second issue is that in case the parsed value is out of the range
the probe just fails and no error message is shown as the code never
reaches the second test that prints and error message.

Remove the test form lp55xx_parse_common_child() function completely
and keep the one in lp55xx_init_led() function to deal with it.

Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Link: https://lore.kernel.org/r/20241017150812.3563629-1-michal.vokac@ysoft.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp55xx-common.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -578,9 +578,6 @@ static int lp55xx_parse_common_child(str
 	if (ret)
 		return ret;
 
-	if (*chan_nr < 0 || *chan_nr > cfg->max_channel)
-		return -EINVAL;
-
 	return 0;
 }
 


