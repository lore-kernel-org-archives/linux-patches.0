Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11123369224;
	Sat, 12 Sep 2026 08:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203389; cv=none; b=TJ9szvi2poNg2/l5BJ2b1MTgi4b3PoLv35mcJa8MIDupTXP/2CIydjeIyurzc7MU5i5H9/RZlgM35Ylcy6vfjojshT0LSjL+vABVHnEat8cvPu+i8bIFTXskUHFQZsSkL176Ug6gCuF1s2XeI3o6xFsB9gz9vCL+7PMyzJJTcqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203389; c=relaxed/simple;
	bh=cckaiUirXtKD0XQXA8MUUIetx+9Qi0e8eRGKX0wi4j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDujciGEjVU1/bINZvDd/jrsWrT+L+ASPV85rWUOrTxQWQC5F425jPWe2n1WbYRUky6xg/RusRTwdNdT38zN+jRDOUjo756c7CK5e4m2zNC1N8E4SFzM1FB0OdUa5jpKoHhnNc/ls25XS1w5o1aFXW6IOOWJwJVeAZa40jdbHAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/9OWf1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/9OWf1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEBB1F000FF;
	Sat, 12 Sep 2026 08:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203387;
	bh=EmL9jBc7Ke9pUqwjnn/ck0nEbBZk2fDWTxtDnqnpXXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/9OWf1lxHAYS5BFVuDLho5zT+SS0RCqomXdI50azCZDtXlLbt1tgrQVyMYqsnQn8
	 IHilwj/87a1CdA+BnK86l4Epx936H31UdTnkDH9cxW9KKsigUAy1tlyKJPlSKD5B+K
	 JLqArrbz5EmkI9Fzk63bM8KmS8oaJmtWTKTUwQpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@linux.dev>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1398/1815] backlight: aw99706: Validate all DT property values consistently
Date: Sat, 12 Sep 2026 08:52:28 +0200
Message-ID: <20260912065721.844678388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@linux.dev>

[ Upstream commit 3d142b19b09ea62d6e9a33d46d1b858b3ad05707 ]

The lookup helpers for dim-mode and ramp-ctl take a shortcut when
lookup_tbl is NULL: they accept any u32 value without range-checking
and return success unconditionally. Out-of-range values get silently
truncated by regmap_update_bits instead of triggering the dev_warn +
default-fallback path that the other properties use.

Add a field-width check for the NULL-table case so that values
exceeding the register field maximum are rejected the same way a
table-lookup miss is.

The switching frequency table has a second hole: reserved slots use 0
as their marker, so "awinic,sw-freq-hz = <0>" matches slot 0 and
programs a reserved encoding. Make the reserved marker U32_MAX and
skip such slots during lookup.

While here, also switch the error returns to -EINVAL for consistency.

Fixes: 147b38a5ad06 ("backlight: aw99706: Add support for Awinic AW99706 backlight")
Signed-off-by: Junjie Cao <junjie.cao@linux.dev>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260804030255.1934470-3-junjie.cao@intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/aw99706.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/aw99706.c b/drivers/video/backlight/aw99706.c
index 9ac8ba50a9ea7..c4a66b59ecf13 100644
--- a/drivers/video/backlight/aw99706.c
+++ b/drivers/video/backlight/aw99706.c
@@ -60,7 +60,7 @@
 #define AW99706_MTPLDOSEL_REG			0x1E
 #define AW99706_MTPRUN_REG			0x1F
 
-#define RESV	0
+#define RESV	U32_MAX
 
 /* Boost switching frequency table, in Hz */
 static const u32 aw99706_sw_freq_tbl[] = {
@@ -94,17 +94,19 @@ static int aw99706_dt_property_lookup(const struct aw99706_dt_prop *prop,
 	int i;
 
 	if (!prop->lookup_tbl) {
+		if (dt_val > (prop->mask >> __ffs(prop->mask)))
+			return -EINVAL;
 		*val = dt_val;
 		return 0;
 	}
 
 	for (i = 0; i < prop->tbl_size; i++)
-		if (prop->lookup_tbl[i] == dt_val)
+		if (prop->lookup_tbl[i] != RESV && prop->lookup_tbl[i] == dt_val)
 			break;
 
 	*val = i;
 
-	return i == prop->tbl_size ? -1 : 0;
+	return i == prop->tbl_size ? -EINVAL : 0;
 }
 
 #define MIN_ILED_MAX	5000
@@ -116,11 +118,14 @@ aw99706_dt_property_iled_max_convert(const struct aw99706_dt_prop *prop,
 				     u32 dt_val, u8 *val)
 {
 	if (dt_val > MAX_ILED_MAX || dt_val < MIN_ILED_MAX)
-		return -1;
+		return -EINVAL;
+
+	if ((dt_val - MIN_ILED_MAX) % STEP_ILED_MAX)
+		return -EINVAL;
 
 	*val = (dt_val - MIN_ILED_MAX) / STEP_ILED_MAX;
 
-	return (dt_val - MIN_ILED_MAX) % STEP_ILED_MAX;
+	return 0;
 }
 
 static const struct aw99706_dt_prop aw99706_dt_props[] = {
-- 
2.53.0



