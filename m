Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC6F2C027B;
	Thu, 15 Jan 2026 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498013; cv=none; b=sRzxZj83JwK3Y6Ds9fxg8XmKaV3rdCKg4hB5ykaXphokLhHP6wsnlS4Qev7ZlUH3IaDb8akoXm/QyM5I1C1f4qJI/PLbqyBwMS/VVFIxsUlcUzkkrJ8p6dj3zN7B2M4GIuuip5Lwannr20r9esLmhIA3XqdWcqbtIMMYZj04HB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498013; c=relaxed/simple;
	bh=cO2VZFaHtlUhEuuOtAY5KtXxFaNVIvDiHp6kznvIuqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3+jOIzRl58rPWAJeKOlObKme9W9DxjJZd8pVNznUmBPjmGhnT71xpC/grc9PZMfX3MtnfZjqH2z7D9Qaklp5mDS5fGgXJSDW+UM7vb2UcFeF6BXhHsCmP2tN/FbKQaXSaF/TWX56rHdnxKboPoSKNtHFV6+6UIKWtbkDmZhiJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEAyhDsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEAyhDsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C9AC16AAE;
	Thu, 15 Jan 2026 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498012;
	bh=cO2VZFaHtlUhEuuOtAY5KtXxFaNVIvDiHp6kznvIuqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEAyhDsUQ0XUmCDf4fYuZNxlc2JcCJEKwfrw1HxRxpQvxJizKASvSdAUakatPB0/+
	 fVlFzwmRybs6luVyZkvgO6NLqG5iFLuRtDQtGV9IjesR+u/vlW5mjAbfda9ZlenXWK
	 4tNy+JL6AY79x7d9lSue3vLUCCRujyA5YqeIyuBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/554] net/mlx5: fw_tracer, Add support for unrecognized string
Date: Thu, 15 Jan 2026 17:45:05 +0100
Message-ID: <20260115164254.895139531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit f7133135235dbd11e7cb5fe62fe5d05ce5e82eeb ]

In case FW is publishing a string which isn't found in the driver's
string DBs, keep the string as raw data.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: b35966042d20 ("net/mlx5: fw_tracer, Validate format string parameters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 25 +++++++++++++++++--
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index efa2e0a8fa1d1..d982b468dcc1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -460,6 +460,7 @@ static void poll_trace(struct mlx5_fw_tracer *tracer,
 
 	tracer_event->event_id = MLX5_GET(tracer_event, trace, event_id);
 	tracer_event->lost_event = MLX5_GET(tracer_event, trace, lost);
+	tracer_event->out = trace;
 
 	switch (tracer_event->event_id) {
 	case TRACER_EVENT_TYPE_TIMESTAMP:
@@ -582,6 +583,26 @@ void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
 	mlx5_tracer_clean_message(str_frmt);
 }
 
+static int mlx5_tracer_handle_raw_string(struct mlx5_fw_tracer *tracer,
+					 struct tracer_event *tracer_event)
+{
+	struct tracer_string_format *cur_string;
+
+	cur_string = mlx5_tracer_message_insert(tracer, tracer_event);
+	if (!cur_string)
+		return -1;
+
+	cur_string->event_id = tracer_event->event_id;
+	cur_string->timestamp = tracer_event->string_event.timestamp;
+	cur_string->lost = tracer_event->lost_event;
+	cur_string->string = "0x%08x%08x";
+	cur_string->num_of_params = 2;
+	cur_string->params[0] = upper_32_bits(*tracer_event->out);
+	cur_string->params[1] = lower_32_bits(*tracer_event->out);
+	list_add_tail(&cur_string->list, &tracer->ready_strings_list);
+	return 0;
+}
+
 static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 					   struct tracer_event *tracer_event)
 {
@@ -590,7 +611,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	if (tracer_event->string_event.tdsn == 0) {
 		cur_string = mlx5_tracer_get_string(tracer, tracer_event);
 		if (!cur_string)
-			return -1;
+			return mlx5_tracer_handle_raw_string(tracer, tracer_event);
 
 		cur_string->num_of_params = mlx5_tracer_get_num_of_params(cur_string->string);
 		cur_string->last_param_num = 0;
@@ -605,7 +626,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 		if (!cur_string) {
 			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
-			return -1;
+			return mlx5_tracer_handle_raw_string(tracer, tracer_event);
 		}
 		cur_string->last_param_num += 1;
 		if (cur_string->last_param_num > TRACER_MAX_PARAMS) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 97252a85d65e6..568efb1e2bd24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -158,6 +158,7 @@ struct tracer_event {
 		struct tracer_string_event string_event;
 		struct tracer_timestamp_event timestamp_event;
 	};
+	u64 *out;
 };
 
 struct mlx5_ifc_tracer_event_bits {
-- 
2.51.0



