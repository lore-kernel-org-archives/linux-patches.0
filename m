Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334B01A285;
	Wed,  8 Apr 2026 18:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673887; cv=none; b=dadMkHeOKZKplwOTfUsy5FhknwhfvH5ZhAajA46yyXkp9vfGw0caZvPNCmou3MfVNy59iLa4cAaKsihDyVknaTwSQSb2niXi74NiR1T4gdSENDaB4NmtZw8sNlLgM7nLAIr60ERxBFSmH/2+flOrJQ3gzdIMYMonOW+DpEEYSNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673887; c=relaxed/simple;
	bh=xU2WLSTrytvIOYw5z3Pb3tPV8RJoFF0MhEPKmH3mzD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbYiDY2o9RWIjUKSq6acHxKQ86cXz3iV4ppEku2HK7dc5+EftbNU2hXwnCdE03F2AmXwlkcwIWaKPdnP4GPKPvXkVoWeP1l4RXimUVu8QpeZr80yJuRKl+UyxIa9rs21ocUvm54rGk7owcIIrIMAJVqXBHsYjSPwk3zq3MpZs1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErOvYyec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErOvYyec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE26FC19421;
	Wed,  8 Apr 2026 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673887;
	bh=xU2WLSTrytvIOYw5z3Pb3tPV8RJoFF0MhEPKmH3mzD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErOvYyecVLP4XwUUXI86KCiCSBQDRKcszCLHwvRMWrE0dVWnu7KNZh0f3CjgO9QI4
	 J+0ycjiRxoF6m29EwWNERGrnXWEOlePVwbq+QmTm5UTyXPNhE0Z7BfycQBlEIPUPVw
	 RlZKfHpcX9gD59Tuj3+MVsKVPUR4uSuqgZTGVaTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 127/242] hwmon: (occ) Fix division by zero in occ_show_power_1()
Date: Wed,  8 Apr 2026 20:02:47 +0200
Message-ID: <20260408175931.843166963@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 39e2a5bf970402a8530a319cf06122e216ba57b8 upstream.

In occ_show_power_1() case 1, the accumulator is divided by
update_tag without checking for zero. If no samples have been
collected yet (e.g. during early boot when the sensor block is
included but hasn't been updated), update_tag is zero, causing
a kernel divide-by-zero crash.

The 2019 fix in commit 211186cae14d ("hwmon: (occ) Fix division by
zero issue") only addressed occ_get_powr_avg() used by
occ_show_power_2() and occ_show_power_a0(). This separate code
path in occ_show_power_1() was missed.

Fix this by reusing the existing occ_get_powr_avg() helper, which
already handles the zero-sample case and uses mul_u64_u32_div()
to multiply before dividing for better precision. Move the helper
above occ_show_power_1() so it is visible at the call site.

Fixes: c10e753d43eb ("hwmon (occ): Add sensor types and versions")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260326224510.294619-2-sanman.pradhan@hpe.com
[groeck: Fix alignment problems reported by checkpatch]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/occ/common.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -420,6 +420,12 @@ static ssize_t occ_show_freq_2(struct de
 	return sysfs_emit(buf, "%u\n", val);
 }
 
+static u64 occ_get_powr_avg(u64 accum, u32 samples)
+{
+	return (samples == 0) ? 0 :
+		mul_u64_u32_div(accum, 1000000UL, samples);
+}
+
 static ssize_t occ_show_power_1(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -441,9 +447,8 @@ static ssize_t occ_show_power_1(struct d
 		val = get_unaligned_be16(&power->sensor_id);
 		break;
 	case 1:
-		val = get_unaligned_be32(&power->accumulator) /
-			get_unaligned_be32(&power->update_tag);
-		val *= 1000000ULL;
+		val = occ_get_powr_avg(get_unaligned_be32(&power->accumulator),
+				       get_unaligned_be32(&power->update_tag));
 		break;
 	case 2:
 		val = (u64)get_unaligned_be32(&power->update_tag) *
@@ -459,12 +464,6 @@ static ssize_t occ_show_power_1(struct d
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
-static u64 occ_get_powr_avg(u64 accum, u32 samples)
-{
-	return (samples == 0) ? 0 :
-		mul_u64_u32_div(accum, 1000000UL, samples);
-}
-
 static ssize_t occ_show_power_2(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {


