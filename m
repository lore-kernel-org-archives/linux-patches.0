Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3314F30C4;
	Wed, 30 Sep 2026 16:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785519; cv=none; b=rZvua8jtiVrHvTzxDyPwd9/CnzBNDWQeBLrAjK0I8dpkQU4GZHlvhAAE1yjiNzrRncojYDb82sPXg7vWOMls1DW602G21M+vF+TMjRSRuowmcmk3+ozhRlSkMX8NZk0DnI/vEtilB2iuX0+DOQeXLiw7254ZPJGaZSgYREA02pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785519; c=relaxed/simple;
	bh=IyrRc3GqrYL+q9OIetHeSzhNfC/nIDrhQyrIKgSg9L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUVfNwJ6tNsYIU5XfgdqtjUrQ3oxeV1ULodJwONwNcglyrzhgVNdK1gfyDKNo0OWBdVRHZep6rvn5dVEyjLokVLfYn1p0ZWH4GpAL4DbbT/6QpZaTa4MeGsGY/5PuIsqNRfy/qq3RzI5NlmWwDGh3r8zPrMZORNSbYPuc08y2jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9VL3se6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9VL3se6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AD91F00898;
	Wed, 30 Sep 2026 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785512;
	bh=qpjrmmFTYMHlqxNvcSH0VcWDcxVqPEgJc9C+TFOZzqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9VL3se62T9LmqGZNGRGByScWZumy8zAAWCN77I+NRYvBCm3G4qyT0mA+i0VskaDR
	 ncfy2lliCxOBnTiwsIl6FA8D390ENiPnd4oKHXH5RySHs28041A3ynk63EguIHykWC
	 q6XXGigxChTdXdfQp8CMTH7VFRigOd7Ge9X8gq3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Razdan <vrazdan@openai.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 533/982] hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS
Date: Wed, 30 Sep 2026 17:21:09 +0200
Message-ID: <20260930152428.220368301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1095,7 +1095,9 @@ static int pmbus_get_boolean(struct i2c_
 
 	regval = status & mask;
 	if (regval) {
-		if (data->revision >= PMBUS_REV_12) {
+		/* Generic STATUS_WORD alarms are not individually clearable. */
+		if (data->revision >= PMBUS_REV_12 &&
+		    reg != PMBUS_STATUS_WORD) {
 			ret = _pmbus_write_byte_data(client, page, reg, regval);
 			if (ret)
 				goto unlock;


