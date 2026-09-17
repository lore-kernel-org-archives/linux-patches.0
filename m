Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98D64ABBC1;
	Thu, 17 Sep 2026 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659886; cv=none; b=agPm5fc/SYkN1NF4TRiUjx2dQz61Jix6GqAU19Z1mNvEhhTWiapvPlDbYPEu1PddJHGLgZGQMn3XJ3aOb69mnSPj4kpcoyxrhKpAdCmJbJPcnkqD88LQTS1dDhJbvFrEVqWNKo1v26uNLdVRExPxCUECgF97Lpz9hyYjdaXFRIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659886; c=relaxed/simple;
	bh=RC1MQyOMqL99uNbwaQ+4dMzSLaQYIjM4fRpEkOnCwQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVW8T/yVDioSVT2M8Wf7GBEFqJCVAGlM6aqBCFejMbArMmJKCI0Ih+OzZaV2YOK12Pv7H2lhBUMpRZIg1eb7KvCwovnt3y4BjUK88OFZd4fpAiriOtUmUIOiDxcVJffiE9sfcBzvmhrRdsuOVng5hcZzlrLZ7b/J/FnPZybv8ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqdWg0tU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqdWg0tU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E51F00893;
	Thu, 17 Sep 2026 15:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659878;
	bh=cCC+qbqqrGXZ2EX1/9nnzpOSHWdvkhLS5IyycP4BKbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqdWg0tUn/VS+gHRjRbqjwZy8NmSqTIEUu24J0+0QCs1IeGeexVVKX1OgkA9jnned
	 RIP7W5c4Kv9Jy2g6unI78rgju6On6fSbCBdednnzNTiQ4EQCWTh0B5rHd25UZ0H2G2
	 C9j2eGgDjlCDWu6pEn2PhY7zMRthh9NWIh3RdpOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yu <tmyu0@nuvoton.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 403/733] hwmon: (nct6694) do not expose enable on DTIN temperature channels
Date: Thu, 17 Sep 2026 16:11:51 +0100
Message-ID: <20260917151401.786438276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit c88a6338ae485e4d6210cc74cdb7664d6476c925 ]

The driver registers 26 temperature channels, all advertising
HWMON_T_ENABLE, and indexes the enable bitmap with the raw channel:

	data->hwmon_en.tin_en[channel / 8] |= BIT(channel % 8);

tin_en is two bytes and only covers the 5 THR and 5 TDP channels
(index 0-9). The 16 DTIN channels (index 10-25) are enabled by the
firmware and were never meant to carry an enable bit. Because the
control structure is packed, writing temp17_enable and above indexes
past tin_en into the fin_en bytes that follow it, so it toggles fan
enable state instead; nct6694_hwmon_init() then sends the whole
structure back to the device, and reads report fan state as temperature
state. It stays within the structure, so this is not a memory safety
problem, but on a board that uses the fan channels it is not harmless.

Give the DTIN channels a temperature config without HWMON_T_ENABLE so
the core never creates their enable attribute. The enable path is then
reachable only for the first 10 channels, which stay within tin_en, and
fin_en is left alone. The DTIN input and limit attributes are unchanged.

Fixes: 197e779d29d8 ("hwmon: Add Nuvoton NCT6694 HWMON support")
Suggested-by: Ming Yu <tmyu0@nuvoton.com>
Link: https://lore.kernel.org/all/20260802124730.20387-1-ali@iusegentoo.com/
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260803102148.14196-1-ali@iusegentoo.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6694-hwmon.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/nct6694-hwmon.c b/drivers/hwmon/nct6694-hwmon.c
index 6dcf22ca5018a..9a9a4db434c4f 100644
--- a/drivers/hwmon/nct6694-hwmon.c
+++ b/drivers/hwmon/nct6694-hwmon.c
@@ -159,6 +159,9 @@ static inline s8 temp_to_reg(long val)
 #define NCT6694_HWMON_TEMP_CONFIG (HWMON_T_INPUT | HWMON_T_ENABLE |	\
 				   HWMON_T_MAX | HWMON_T_MAX_HYST |	\
 				   HWMON_T_MAX_ALARM)
+#define NCT6694_HWMON_DTIN_CONFIG (HWMON_T_INPUT |			\
+				   HWMON_T_MAX | HWMON_T_MAX_HYST |	\
+				   HWMON_T_MAX_ALARM)
 #define NCT6694_HWMON_FAN_CONFIG (HWMON_F_INPUT | HWMON_F_ENABLE |	\
 				  HWMON_F_MIN | HWMON_F_MIN_ALARM)
 #define NCT6694_HWMON_PWM_CONFIG (HWMON_PWM_INPUT | HWMON_PWM_ENABLE |	\
@@ -193,22 +196,22 @@ static const struct hwmon_channel_info *nct6694_info[] = {
 			   NCT6694_HWMON_TEMP_CONFIG,	/* TDP2 */
 			   NCT6694_HWMON_TEMP_CONFIG,	/* TDP3 */
 			   NCT6694_HWMON_TEMP_CONFIG,	/* TDP4 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN0 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN1 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN2 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN3 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN4 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN5 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN6 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN7 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN8 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN9 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN10 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN11 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN12 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN13 */
-			   NCT6694_HWMON_TEMP_CONFIG,	/* DTIN14 */
-			   NCT6694_HWMON_TEMP_CONFIG),	/* DTIN15 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN0 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN1 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN2 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN3 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN4 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN5 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN6 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN7 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN8 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN9 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN10 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN11 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN12 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN13 */
+			   NCT6694_HWMON_DTIN_CONFIG,	/* DTIN14 */
+			   NCT6694_HWMON_DTIN_CONFIG),	/* DTIN15 */
 
 	HWMON_CHANNEL_INFO(fan,
 			   NCT6694_HWMON_FAN_CONFIG,	/* FIN0 */
-- 
2.53.0



