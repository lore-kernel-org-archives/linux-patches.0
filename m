Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466C23B38B9;
	Mon, 23 Mar 2026 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274326; cv=none; b=QS0VyRf8aT76fB4zqCL2QgoqH9J7OQPLR8AGDzhf4+Ab+uIbnSzmbNy6jjblZPnOyDLhdkxQXfwStqNC5dbCYTI8iNPUDEZdOvB2qS0hyZ62OeFIpE2QUmilPmOeiiA3aR4UqVZoQSWvODtkFKVvrYoCwoKMZ0P3rTn1M6H3tpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274326; c=relaxed/simple;
	bh=uZ9JvnwDJaxokd4c6l3RmyOaBcxyIUMvovuTJy2GZUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWXk8RZzPq2eY0aEJ54KrGjGynD91lUWCKge6LFRuUKtjlXBDb0v7nBwoM0+eSKbAVqLjGjuBBRiSwrG8QpqrsU8Pc0os7LxJaOyDSI3yQNtMcY/bybAvUBtDkJtknqvXndZWqvazs8IKIN8Zv4PL6OcbiNV0xH1oVqnSek5suA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O41j7yT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O41j7yT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC879C2BCB4;
	Mon, 23 Mar 2026 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274326;
	bh=uZ9JvnwDJaxokd4c6l3RmyOaBcxyIUMvovuTJy2GZUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O41j7yT8WHfPILOTVVjQjam0TGmHuRgfaeiiIm/Toz4DpBnduEovxad6yg1oMZS/0
	 hlnqymLiOwAlv9BAEYTVHU/x19osWYMCPNQ+JDg2/QOXheqN9zppJkfupoccNO4X6r
	 Ji4zCg/+seXuCI5ZoR7DCaUz4UoNrWNAu43Bg9xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.19 183/220] hwmon: (pmbus/mp2975) Add error check for pmbus_read_word_data() return value
Date: Mon, 23 Mar 2026 14:46:00 +0100
Message-ID: <20260323134510.354893860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


