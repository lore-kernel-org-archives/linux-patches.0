Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098E3DFC99;
	Thu, 17 Sep 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666508; cv=none; b=JJE31U/ZWeh+3kt3tYAbqE/r2bsbYRwLqp9KhmyQ3Br0zo4gVzX6aW8rTRJ4NjtQdlnX5rT5qj9TsSCbmimnhBpIukGRFW8IeKy6mdXCmF3FxOZBKuIpd0ishpn11Fh1lp+qweKg9iZf0lBsjMOgH28AP4izG85ot+xHjZJa1m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666508; c=relaxed/simple;
	bh=l81lU3bYoeGOituxT1dIO46Xtcv5IRAuLb93dr1HpBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3AeeKzgEFV6TY6LrjuLthI6dxkRe1gcl8czhwZKKSfEiW90ge2lyGGpGeHlBzMdNR3gJkEwLf2C3pDLZTcRxro6ELoZKpId2ZV7XJh7BYzxl5/03uO6e4VXsiTUHGYz36UPQvp0sFx/PcYF41s1vBfCd5mU9ZqFz8jThW1vU5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwO2ERQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwO2ERQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD01F000FF;
	Thu, 17 Sep 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666506;
	bh=ECLayZsnCbp/HfFYUjZeQkw2HFhNm1p8WSPj98Eu/PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwO2ERQJUlfh6YqArQefFHbP2Uw9w/0m8ux0Acv0gHwxUGyZ84F6LBFRLuYsiLvCG
	 6HAxMQHa3NKEaN4VLL1p9M+IlI87hdhoL3QSz9OeVDjEwcjFxOef27VTVty98DLXPT
	 nI4L/b8f63h43kSkykpAKQFTcCz3ArVKidYbvtqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Razdan <vrazdan@openai.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1059/1250] hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS
Date: Thu, 17 Sep 2026 16:14:14 +0100
Message-ID: <20260917151620.827961840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Vishnu Razdan <vrazdan@openai.com>

commit 6d760f8b41aed74de4402440e4db663d261478bd upstream.

Some hwmon alarms fall back to STATUS_WORD summary bits when no
individual limit alarm is available. On PMBus 1.2 and newer devices,
pmbus_get_boolean() acknowledges these alarms with the same byte-data
write used for detailed status registers. For example, PB_STATUS_INPUT
is 0x2000, so it is truncated to zero when passed to
_pmbus_write_byte_data(). The resulting write cannot acknowledge the
input alarm.

PMBus 1.3 Part II, sections 10.2.4 and 10.2.5, excludes ordinary
STATUS_BYTE and STATUS_WORD summary bits from individual clearing.
Their summary bits clear when the underlying status bits clear, so
changing this to a word-data write would not fix the generic input
alarm either.

Use the existing page CLEAR_FAULTS path for generic STATUS_WORD
alarms, including devices whose status accessor uses STATUS_BYTE.
Keep individual byte writes for detailed status registers on PMBus
1.2 and newer devices. As with the existing older-device fallback,
CLEAR_FAULTS can clear other latched status; an active condition can
reassert its status.

Fixes: 35f165f08950 ("hwmon: (pmbus) Clear pmbus fault/warning bits after read")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Vishnu Razdan <vrazdan@openai.com>
Link: https://patch.msgid.link/20260824-vrazdan-pmbus-status-word-b4-v1-1-2606ecd0c029@openai.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1169,7 +1169,9 @@ static int pmbus_get_boolean(struct i2c_
 
 	regval = status & mask;
 	if (regval) {
-		if (data->revision >= PMBUS_REV_12) {
+		/* Generic STATUS_WORD alarms are not individually clearable. */
+		if (data->revision >= PMBUS_REV_12 &&
+		    reg != PMBUS_STATUS_WORD) {
 			ret = _pmbus_write_byte_data(client, page, reg, regval);
 			if (ret)
 				return ret;


