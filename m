Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDB83B583D;
	Mon, 23 Mar 2026 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279336; cv=none; b=MCv5T7w777vkt3cai/VtX6znYoEFQGkJc6kkCqMGFIYaIRPGeSpmD1ZzYt23F6b25Xe1lknyUc5Kk7LukAx7CXCULaxbqH1egHP8jmJGkETewJ87NcwxztLw0QbCdOxZjmjU0LdUnyegK01mqTjo8W35O+t1lSwkUdEwvKL3zyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279336; c=relaxed/simple;
	bh=S1Aoxri6kHao/r+ew9Pf/ANfVy/HhXfy9zBWD1RMW5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i81k5eJ2M6qML3yONQIZYWi9Q43/1pqPlGIzCyqL2CHle+3K16RzUiGZo3qeQ1HpPoGR1694rzaF06OvQONiLWm4E7amcjndt51KSy00Ozx1HHOK1r003Uj6VaytMd6x6ACeol0lpezdvZpK+5pcBTYQNTYWvBGrh4LjYudQiuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSp5d90n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSp5d90n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9623DC4CEF7;
	Mon, 23 Mar 2026 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279336;
	bh=S1Aoxri6kHao/r+ew9Pf/ANfVy/HhXfy9zBWD1RMW5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSp5d90n89wTu90Edo8LpfCAQLARxPCpZ4fROZD7XnZU3GFHqYhnQkA44ItWQXDfi
	 bCz8leaGvVF1Q//q/LzTkiyMmX+ZkZiXxA0tG0lI+OPr5j+rhmEQXAQQSi8YvlV2Gy
	 idm9iKaJu9HvhJG0h/sn+QlI4xSmQG20AadSCibY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 549/567] hwmon: (pmbus/mp2975) Add error check for pmbus_read_word_data() return value
Date: Mon, 23 Mar 2026 14:47:49 +0100
Message-ID: <20260323134547.588150548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -300,6 +300,8 @@ static int mp2973_read_word_data(struct
 	case PMBUS_STATUS_WORD:
 		/* MP2973 & MP2971 return PGOOD instead of PB_STATUS_POWER_GOOD_N. */
 		ret = pmbus_read_word_data(client, page, phase, reg);
+		if (ret < 0)
+			return ret;
 		ret ^= PB_STATUS_POWER_GOOD_N;
 		break;
 	case PMBUS_OT_FAULT_LIMIT:


