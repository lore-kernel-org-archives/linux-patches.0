Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E1D4FD789;
	Thu, 17 Sep 2026 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666160; cv=none; b=KMCxLmwt0bDc5IJd50lh+qyo2OAjdI4VTNnpxN8a3ky9Xge+EnjrkDIuBlpY5GGnAZ7+Hjv6gmQuTA18M2wfRFR2DEZ8xHBvq9cO9eibbWB4rpvt8Av9JshvUCCfip/whR4oDGeHC2Y+PEkfIKrIwavQJ17HaZFQYeAUOL4CN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666160; c=relaxed/simple;
	bh=fhmclz0bDnxS8kSyf00zfT2h1n0DsswnlVZNyPPgl4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GT35292Ys5JshMOhQDfVhRDymuPTzr294MywZIPuRVZTasEBkNYj1bnLTI9IKtpt9WgxOKKQO7yCBUjI1aXmOB3jJYZzdrUjZSt9ReXHa8oel771S9sZlJOA8uHj+jlr5Qhk+yzV4qqOJPyETHm9m3iBbil5Dyhv/oKEpgsG3RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muVVyUJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muVVyUJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BCE1F000FF;
	Thu, 17 Sep 2026 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666158;
	bh=mxjtG7wYFHaTYKWY9/0pUjpwKKYoziDanCXOMPdh3G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muVVyUJauu5Alq+pLRZHIJpv2YSBG76QPlAc9NPzOc6u10Ko7+eyoVnoUFS3g6qZr
	 MfAJ9flehIRALErG4LDprFxgECM946SkI52hiSWIvZ6QlCVbJGp8MopzyJVlhn1CYm
	 ZgjF5hcy0d2kITxdtT8Qk3wPbC5KGU2bA8DVmBb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yu <tmyu0@nuvoton.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0905/1250] hwmon: (nct6694) do not expose enable on DTIN temperature channels
Date: Thu, 17 Sep 2026 16:11:40 +0100
Message-ID: <20260917151616.524761981@linuxfoundation.org>
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



