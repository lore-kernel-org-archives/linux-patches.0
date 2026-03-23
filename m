Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EDA17DE36;
	Mon, 23 Mar 2026 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274978; cv=none; b=a9k1Q4PQqOi6U8/qtRUTJezkAyYLnKtmA68s9tT+rFRCxHNeappT0yoIcIM4I8IMp8KeX8nGnSdp+Wn0u7XHk6UfHg/SBuhK9EdXb881jr3zhsRg66vpzjiALN5QQaoXAViydHsARQtQDlCHk/IntonFv/iiNHWGYy+gme0j83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274978; c=relaxed/simple;
	bh=RmZqgE0RmN9gLrA4M5pn53njs4wbi5vhk+GDfhJXaQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKOSdc8GKOt7krgczau79Y0z25Wc9Y3tJwXSr8/db0lT1shW8gXzlzpqqOe3AU8ssxFfLKTgvB9vG7foIcMsohDjfhcpfB+gaNhzxaR6ve42QW9gh32xIferYx/hLkj8vUKSiImh69tscUcPboQFjJMphSGAeWr36bpu+EJrW50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=El3+knBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="El3+knBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FA4C4CEF7;
	Mon, 23 Mar 2026 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274978;
	bh=RmZqgE0RmN9gLrA4M5pn53njs4wbi5vhk+GDfhJXaQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=El3+knBr6ooslP8INeIjg5J91lm+d/asIjipAxAwituP1IVUmI3vskLgXHvyzl7Nd
	 lYhM5L/HLcZA+hQUR1u8DkGpMFFcgMC9ePueKEDG9UU8bTRrN3TrklQys9ahvnFFpC
	 JEVCkiISuLmKWNmkKF742FVKdiBzGaThrqgHJTCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 181/212] hwmon: (pmbus/mp2975) Add error check for pmbus_read_word_data() return value
Date: Mon, 23 Mar 2026 14:46:42 +0100
Message-ID: <20260323134509.469406510@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 19d4b9c8a136704d5f2544e7ac550f27918a5004 upstream.

mp2973_read_word_data() XORs the return value of pmbus_read_word_data()
with PB_STATUS_POWER_GOOD_N without first checking for errors. If the I2C
transaction fails, a negative error code is XORed with the constant,
producing a corrupted value that is returned as valid status data instead
of propagating the error.

Add the missing error check before modifying the return value.

Fixes: acda945afb465 ("hwmon: (pmbus/mp2975) Fix PGOOD in READ_STATUS_WORD")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260317173308.382545-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/mp2975.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/pmbus/mp2975.c
+++ b/drivers/hwmon/pmbus/mp2975.c
@@ -313,6 +313,8 @@ static int mp2973_read_word_data(struct
 	case PMBUS_STATUS_WORD:
 		/* MP2973 & MP2971 return PGOOD instead of PB_STATUS_POWER_GOOD_N. */
 		ret = pmbus_read_word_data(client, page, phase, reg);
+		if (ret < 0)
+			return ret;
 		ret ^= PB_STATUS_POWER_GOOD_N;
 		break;
 	case PMBUS_OT_FAULT_LIMIT:


