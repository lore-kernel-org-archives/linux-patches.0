Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1040587A;
	Tue, 21 Jul 2026 17:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655803; cv=none; b=aoAFdbYPfDjoeb5tn2QtEKyHkcQzduEX2uM72lm1dO6C/j60/ff5UAGk6OADJcq07bWGXsyaGUTJNZKESUrNcjyfADYJyyJkxCiEO9gj2Dj7lZ4zMQqe2pi6DYkHVFGzj9oP4tKHPsEua2RgIkD7sVLhm1fpnFs2CKRJeY8Shuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655803; c=relaxed/simple;
	bh=LZhHRBQ3ddwuE4Uh3+3ThXjeewzj5kdnVDQ7PZ7cCOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvNye1Z2+/vcNr+3P75As6uF4INjNLs7dQo8ZTsr1ATDbsXx4CzZYVtAlSWiV/bC5LaEm3DvKiO2rhCusNx2QaoE2s1R46IK4VOYBP1BC+kCJv70tfhZe2HEIZMqFbeL6iuSFjP7Lm0koaRPRc3RI/xHAaOKaXQhltmqZVGW1/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJfeforn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJfeforn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5C91F000E9;
	Tue, 21 Jul 2026 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655802;
	bh=0LC4IzJ57n5FEI8Kg4219nWyfQvCz9WBWbvvZVOyPVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJfeforn1JpQbopM/aXPgm0Ab1v9LkM3BMzbdbp64lLrDYSrqPj3+VsiJVlzE7QUs
	 gYrqIjQaay8lCongklkRBcNtpTxKhfC120TECwJzWcjm6DLO5s87WpIX2uG3ZP/Bq7
	 uTUvcXjEjeo23u9RMYqCUchj3x3gRh2OrtimKGj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0104/1611] lib/vsprintf: Fix to check field_width and precision
Date: Tue, 21 Jul 2026 17:03:40 +0200
Message-ID: <20260721152517.184989906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index a356965c1d7348..a8f12833fbb32f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2619,6 +2619,18 @@ static unsigned char spec_flag(unsigned char c)
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
@@ -2689,7 +2701,7 @@ struct fmt format_decode(struct fmt fmt, struct printf_spec *spec)
 	spec->field_width = -1;
 
 	if (isdigit(*fmt.str))
-		spec->field_width = skip_atoi(&fmt.str);
+		set_field_width(spec, skip_atoi(&fmt.str));
 	else if (unlikely(*fmt.str == '*')) {
 		/* it's the next argument */
 		fmt.state = FORMAT_STATE_WIDTH;
@@ -2703,9 +2715,7 @@ struct fmt format_decode(struct fmt fmt, struct printf_spec *spec)
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
@@ -2778,24 +2788,6 @@ struct fmt format_decode(struct fmt fmt, struct printf_spec *spec)
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



