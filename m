Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606046AA8F;
	Tue, 21 Jul 2026 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648382; cv=none; b=li5khAyKuj1qdQi2mksACRbpWvzev38kwAppqOQbb3VT5Xx0Vfqzth5aTAuBG6M2dGJ2VodIb1iDunZSbWZ048woyOjxl5j8jnsYY4yzkU4zWZjASFCA1E0Yk78bXVaudm0eM0DoMOoyil9gyMY6VFjHyH+YxPI3i/4TVxd09Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648382; c=relaxed/simple;
	bh=o1SiEsUfjnvlwpRR6CnoOk+YOV12oYo9Fhr5j/se/AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNjhszdaLBxqYSYaQPiT1aa64O0QqwqjlFcwYvu+nrB9Fnh3+CPxOMy9Gyfsgc9qycd8yd+Jc9IPNUhZ5eW/9XO0x3KpHmhaF4V4VAHfJhmzzJbO06beYsu/34rcryVqwd+Ha3RzGcYqriiP+TovFJevfL9fk023PktbznleEMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI6GZx2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI6GZx2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8581F000E9;
	Tue, 21 Jul 2026 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648381;
	bh=1t9Yw0ETGosGuY1H4/0J0I4w6SZFYv/AsHuWlsQr4YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LI6GZx2VA+FI3umFvCydViVZKFecFZmU6iYc5re8UJY5WZvT4g7T1yXXpayKFGutt
	 Q3vp9mc88xVUcziRhgS94iWesh2hu9kV/1QSlSM3IXUVPycyeOB5EhnWP/XEVkI0xT
	 PDLK9XnZm5gvss/A3hZ4sWR6SZT8bJtMOucLAT0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0134/2077] lib/vsprintf: Fix to check field_width and precision
Date: Tue, 21 Jul 2026 16:56:47 +0200
Message-ID: <20260721152555.852412483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 71876dffab295b6e25d4209f0424da8fc5020e12 ]

Check the field_width and presition correctly. Previously it depends
on the bitfield conversion from int to check out-of-range error.
However, commit 938df695e98d ("vsprintf: associate the format state
with the format pointer") changed those fields to int.
We need to check the out-of-range correctly without bitfield
conversion.

Fixes: 938df695e98d ("vsprintf: associate the format state with the format pointer")
Reported-by: David Laight <david.laight.linux@gmail.com>
Closes: https://lore.kernel.org/all/20260318151250.40fef0ab@pumpkin/
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/177452712047.197965.16376597502504928495.stgit@devnote2
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vsprintf.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 9f359b31c8d1c1..3c76cc5c7f9ceb 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2640,6 +2640,18 @@ static unsigned char spec_flag(unsigned char c)
 	return (c < sizeof(spec_flag_array)) ? spec_flag_array[c] : 0;
 }
 
+static void set_field_width(struct printf_spec *spec, int width)
+{
+	spec->field_width = clamp(width, -FIELD_WIDTH_MAX, FIELD_WIDTH_MAX);
+	WARN_ONCE(spec->field_width != width, "field width %d out of range", width);
+}
+
+static void set_precision(struct printf_spec *spec, int prec)
+{
+	spec->precision = clamp(prec, 0, PRECISION_MAX);
+	WARN_ONCE(spec->precision < prec, "precision %d too large", prec);
+}
+
 /*
  * Helper function to decode printf style format.
  * Each call decode a token from the format and return the
@@ -2710,7 +2722,7 @@ struct fmt format_decode(struct fmt fmt, struct printf_spec *spec)
 	spec->field_width = -1;
 
 	if (isdigit(*fmt.str))
-		spec->field_width = skip_atoi(&fmt.str);
+		set_field_width(spec, skip_atoi(&fmt.str));
 	else if (unlikely(*fmt.str == '*')) {
 		/* it's the next argument */
 		fmt.state = FORMAT_STATE_WIDTH;
@@ -2724,9 +2736,7 @@ struct fmt format_decode(struct fmt fmt, struct printf_spec *spec)
 	if (unlikely(*fmt.str == '.')) {
 		fmt.str++;
 		if (isdigit(*fmt.str)) {
-			spec->precision = skip_atoi(&fmt.str);
-			if (spec->precision < 0)
-				spec->precision = 0;
+			set_precision(spec, skip_atoi(&fmt.str));
 		} else if (*fmt.str == '*') {
 			/* it's the next argument */
 			fmt.state = FORMAT_STATE_PRECISION;
@@ -2799,24 +2809,6 @@ struct fmt format_decode(struct fmt fmt, struct printf_spec *spec)
 	return fmt;
 }
 
-static void
-set_field_width(struct printf_spec *spec, int width)
-{
-	spec->field_width = width;
-	if (WARN_ONCE(spec->field_width != width, "field width %d too large", width)) {
-		spec->field_width = clamp(width, -FIELD_WIDTH_MAX, FIELD_WIDTH_MAX);
-	}
-}
-
-static void
-set_precision(struct printf_spec *spec, int prec)
-{
-	spec->precision = prec;
-	if (WARN_ONCE(spec->precision != prec, "precision %d too large", prec)) {
-		spec->precision = clamp(prec, 0, PRECISION_MAX);
-	}
-}
-
 /*
  * Turn a 1/2/4-byte value into a 64-bit one for printing: truncate
  * as necessary and deal with signedness.
-- 
2.53.0



