Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D3B31D366;
	Wed, 30 Sep 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791719; cv=none; b=sgEhH1tMP+IErnqgVBWNktqRYOLfPWwXr33KN+VWd+0FnBrlO4GN0ty2D2oqltbvwdIcSjrQo84JNd5qlMcvWLd6Xo1nR7YnGfr/E9UKI8+mxRJ3Ho2t0rlY72H3+L1TPLJ9h6Jaz0pIFQM6DKMIyjZYShTzm/AxVh1Vojjto4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791719; c=relaxed/simple;
	bh=vn+Gr23sKTJJJW6Ak7YWqq/8jQAkPul/4uUFA1i4OkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOX1DDXiQXeIu5+tq+AKwynVyld3hHAYyIMOTBeRayJ4Q+xqLpdwLo6LR6J6puisl4/M1Ofl8hrVZXSH3sTegFqReArcl6XtX8nx++V4mfNIIf2MxWPOtTyxVeXxmWLaDQWaaBnW4R6TM24Vw9rZ8iXE4LXZQ6j5EO6J/JF1mU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpXpom2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpXpom2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A81F000FF;
	Wed, 30 Sep 2026 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791718;
	bh=aY+MOoFOn92ThEJ/seqHWv0hMVgL2YX6fk8vyWsiCa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpXpom2G16HSDaNoPnUe5SadHf6LLu/ah/TPRAcHHpyKpPdL02uX/VhRH+UtqS7xe
	 2jmhtRRdrYwjcXOrQU5J7Q8jGBBNW8pfQmozLxP8GkXSQ7XMaHPrEVQ4v+zF2wbkrT
	 YeyfeCCLkDyGjHS65C5uxpDaPu+DLRQ1bfclespc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Razdan <vrazdan@openai.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 400/752] hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS
Date: Wed, 30 Sep 2026 17:24:30 +0200
Message-ID: <20260930152406.938041453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -932,7 +932,9 @@ static int pmbus_get_boolean(struct i2c_
 
 	regval = status & mask;
 	if (regval) {
-		if (data->revision >= PMBUS_REV_12) {
+		/* Generic STATUS_WORD alarms are not individually clearable. */
+		if (data->revision >= PMBUS_REV_12 &&
+		    reg != PMBUS_STATUS_WORD) {
 			ret = _pmbus_write_byte_data(client, page, reg, regval);
 			if (ret)
 				goto unlock;


