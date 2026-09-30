Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004353CF039;
	Wed, 30 Sep 2026 19:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795687; cv=none; b=Md0MYw+kY30ZqELGhSARlmzT/OmyrF+hKr7DHHP77S6K2pNmyBQr8eO9WIL3BN5/JoeKmEr1c3Ly/8/mtuDGJo9VUINf6/eS+WWlsYXLiThMrzmatarMFwKFUcw15/ylQ0O6awGwcSaad2+Pn7Tdy7aUcI+1DdD8AEVEJ2x8uRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795687; c=relaxed/simple;
	bh=amDsT3A3WvsS+eibUZkHuvJ3/xNM+ejQm16PQQh9ABY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi1+y+hv3W37OkJFvgz7uwtnPJVmxQ3LnW4QkVj8BsV2qLT6LwpFbRohbVTJo3Ju1rT95eHO2Fv5JGvBq/9o5bjr5EIKMPnRIruLJ3asH1Voud8RYZNstGk0MZVBoGtOtqgRDf0s7/etj/28F4/EEbDY1iMFho3mCK4qoxbZnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYwonXQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYwonXQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CBD1F00899;
	Wed, 30 Sep 2026 19:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795685;
	bh=u8Raal4eUMZYJ/4dwBuO8PT4WyOenZaP/aKwzY56DpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYwonXQYwiL72DlomwOtNcZEA9uiAGd8p/UceHmfgqzp5Zt7f6aGP5OFZ1Zms6lTw
	 Pu47SOGxBsCo35O47U6hFT29HEFpaQDMvL0C593sL8h0k0CEXz6BMDTlGnl1heYdRS
	 IZNncv9ZseHq5SVz1h0PfbB84l7y8k2BFoTLqzdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Razdan <vrazdan@openai.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0647/1193] hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS
Date: Wed, 30 Sep 2026 17:22:11 +0200
Message-ID: <20260930152448.620780117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -1103,7 +1103,9 @@ static int pmbus_get_boolean(struct i2c_
 
 	regval = status & mask;
 	if (regval) {
-		if (data->revision >= PMBUS_REV_12) {
+		/* Generic STATUS_WORD alarms are not individually clearable. */
+		if (data->revision >= PMBUS_REV_12 &&
+		    reg != PMBUS_STATUS_WORD) {
 			ret = _pmbus_write_byte_data(client, page, reg, regval);
 			if (ret)
 				goto unlock;


