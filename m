Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C66359FBB;
	Fri,  9 Jan 2026 12:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960414; cv=none; b=NLzP6kQNFxDho5MkGeofESaaUh1w31ZU7Y+tcs04i9px577r7t+wq2FyzzeBW7vc1Fo6bo+K50qPrfnCz3jcV0n3tsLddDZQanbXHlCQGoviW30CYCUq1FH1TeuNwryV+IwlMQLVf8fXUOFDNG2ncfO+mK9qrmb39Wzuwdk00Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960414; c=relaxed/simple;
	bh=AcZn1BEDerCQSmAKJjYWCHRPCuS5TQgfJ9iQk2UpxHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvwHa5ZEJYkWOsOE4hdTgwbfhgq0f3vwxUdsS9mxrNvPwHmJ82BJY0l8Z53XU3WOUB2xRHLqzgFk2haPG6G0az02zPDizwHTa36SWHdNRM89GI7h/Y8bgFE+o3EU5NFBNtIaBci5mXzbdxKKq5PIjXxuXu+xyxDFLQh2NIjfiyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLsQl06X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLsQl06X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3414FC4CEF1;
	Fri,  9 Jan 2026 12:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960414;
	bh=AcZn1BEDerCQSmAKJjYWCHRPCuS5TQgfJ9iQk2UpxHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLsQl06X9vkhBYKMURgz3OXeE9WJUDCYAhqrzuVeSqmciW5w5T8F5xctnhM/nFn8o
	 5eUyKJe1hxZqbmJ1kAVIkKqPXsYjJLuR6/ooy+2d/0SGr1ils4QGrgBw0QNDnRPVrn
	 A8xy6nH8cxD4Ji7AS+ARR1TpIFEUcTUsEu7I83nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 352/737] net/mlx5: fw_tracer, Validate format string parameters
Date: Fri,  9 Jan 2026 12:38:11 +0100
Message-ID: <20260109112147.238522555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit b35966042d20b14e2d83330049f77deec5229749 ]

Add validation for format string parameters in the firmware tracer to
prevent potential security vulnerabilities and crashes from malformed
format strings received from firmware.

The firmware tracer receives format strings from the device firmware and
uses them to format trace messages. Without proper validation, bad
firmware could provide format strings with invalid format specifiers
(e.g., %s, %p, %n) that could lead to crashes, or other undefined
behavior.

Add mlx5_tracer_validate_params() to validate that all format specifiers
in trace strings are limited to safe integer/hex formats (%x, %d, %i,
%u, %llx, %lx, etc.). Reject strings containing other format types that
could be used to access arbitrary memory or cause crashes.
Invalid format strings are added to the trace output for visibility with
"BAD_FORMAT: " prefix.

Fixes: 70dd6fdb8987 ("net/mlx5: FW tracer, parse traces and kernel tracing support")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/netdev/hanz6rzrb2bqbplryjrakvkbmv4y5jlmtthnvi3thg5slqvelp@t3s3erottr6s/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 83 ++++++++++++++++---
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  1 +
 2 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 85d3bfa0780c6..197c306d350bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -33,6 +33,7 @@
 #include "lib/eq.h"
 #include "fw_tracer.h"
 #include "fw_tracer_tracepoint.h"
+#include <linux/ctype.h>
 
 static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
 {
@@ -358,6 +359,43 @@ static const char *VAL_PARM		= "%llx";
 static const char *REPLACE_64_VAL_PARM	= "%x%x";
 static const char *PARAM_CHAR		= "%";
 
+static bool mlx5_is_valid_spec(const char *str)
+{
+	/* Parse format specifiers to find the actual type.
+	 * Structure: %[flags][width][.precision][length]type
+	 * Skip flags, width, precision & length.
+	 */
+	while (isdigit(*str) || *str == '#' || *str == '.' || *str == 'l')
+		str++;
+
+	/* Check if it's a valid integer/hex specifier:
+	 * Valid formats: %x, %d, %i, %u, etc.
+	 */
+	if (*str != 'x' && *str != 'X' && *str != 'd' && *str != 'i' &&
+	    *str != 'u' && *str != 'c')
+		return false;
+
+	return true;
+}
+
+static bool mlx5_tracer_validate_params(const char *str)
+{
+	const char *substr = str;
+
+	if (!str)
+		return false;
+
+	substr = strstr(substr, PARAM_CHAR);
+	while (substr) {
+		if (!mlx5_is_valid_spec(substr + 1))
+			return false;
+
+		substr = strstr(substr + 1, PARAM_CHAR);
+	}
+
+	return true;
+}
+
 static int mlx5_tracer_message_hash(u32 message_id)
 {
 	return jhash_1word(message_id, 0) & (MESSAGE_HASH_SIZE - 1);
@@ -419,6 +457,10 @@ static int mlx5_tracer_get_num_of_params(char *str)
 	char *substr, *pstr = str;
 	int num_of_params = 0;
 
+	/* Validate that all parameters are valid before processing */
+	if (!mlx5_tracer_validate_params(str))
+		return -EINVAL;
+
 	/* replace %llx with %x%x */
 	substr = strstr(pstr, VAL_PARM);
 	while (substr) {
@@ -570,14 +612,17 @@ void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
 {
 	char	tmp[512];
 
-	snprintf(tmp, sizeof(tmp), str_frmt->string,
-		 str_frmt->params[0],
-		 str_frmt->params[1],
-		 str_frmt->params[2],
-		 str_frmt->params[3],
-		 str_frmt->params[4],
-		 str_frmt->params[5],
-		 str_frmt->params[6]);
+	if (str_frmt->invalid_string)
+		snprintf(tmp, sizeof(tmp), "BAD_FORMAT: %s", str_frmt->string);
+	else
+		snprintf(tmp, sizeof(tmp), str_frmt->string,
+			 str_frmt->params[0],
+			 str_frmt->params[1],
+			 str_frmt->params[2],
+			 str_frmt->params[3],
+			 str_frmt->params[4],
+			 str_frmt->params[5],
+			 str_frmt->params[6]);
 
 	trace_mlx5_fw(dev->tracer, trace_timestamp, str_frmt->lost,
 		      str_frmt->event_id, tmp);
@@ -609,6 +654,13 @@ static int mlx5_tracer_handle_raw_string(struct mlx5_fw_tracer *tracer,
 	return 0;
 }
 
+static void mlx5_tracer_handle_bad_format_string(struct mlx5_fw_tracer *tracer,
+						 struct tracer_string_format *cur_string)
+{
+	cur_string->invalid_string = true;
+	list_add_tail(&cur_string->list, &tracer->ready_strings_list);
+}
+
 static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 					   struct tracer_event *tracer_event)
 {
@@ -619,12 +671,18 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 		if (!cur_string)
 			return mlx5_tracer_handle_raw_string(tracer, tracer_event);
 
-		cur_string->num_of_params = mlx5_tracer_get_num_of_params(cur_string->string);
-		cur_string->last_param_num = 0;
 		cur_string->event_id = tracer_event->event_id;
 		cur_string->tmsn = tracer_event->string_event.tmsn;
 		cur_string->timestamp = tracer_event->string_event.timestamp;
 		cur_string->lost = tracer_event->lost_event;
+		cur_string->last_param_num = 0;
+		cur_string->num_of_params = mlx5_tracer_get_num_of_params(cur_string->string);
+		if (cur_string->num_of_params < 0) {
+			pr_debug("%s Invalid format string parameters\n",
+				 __func__);
+			mlx5_tracer_handle_bad_format_string(tracer, cur_string);
+			return 0;
+		}
 		if (cur_string->num_of_params == 0) /* trace with no params */
 			list_add_tail(&cur_string->list, &tracer->ready_strings_list);
 	} else {
@@ -634,6 +692,11 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 				 __func__, tracer_event->string_event.tmsn);
 			return mlx5_tracer_handle_raw_string(tracer, tracer_event);
 		}
+		if (cur_string->num_of_params < 0) {
+			pr_debug("%s string parameter of invalid string, dumping\n",
+				 __func__);
+			return 0;
+		}
 		cur_string->last_param_num += 1;
 		if (cur_string->last_param_num > TRACER_MAX_PARAMS) {
 			pr_debug("%s Number of params exceeds the max (%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 5c548bb74f07b..30d0bcba88479 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -125,6 +125,7 @@ struct tracer_string_format {
 	struct list_head list;
 	u32 timestamp;
 	bool lost;
+	bool invalid_string;
 };
 
 enum mlx5_fw_tracer_ownership_state {
-- 
2.51.0



