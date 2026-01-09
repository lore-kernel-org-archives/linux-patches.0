Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E5335BCD;
	Fri,  9 Jan 2026 12:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962158; cv=none; b=m1F6MDIYjuxwFaVcI3OKUFTEBaiImLWYKWRffNgjA0IsOOKsCt0VcbkpM1HOdri++8jWGQPgRYAYqmW3EQ3W/zpb64JKozsIuq68mQyAq1+VwV41sp1toCh671U47Wcxdbun8A0DeT+rsaLXPwOuXHsF6WEsHNYJ7CtqT1YAits=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962158; c=relaxed/simple;
	bh=sEETfLI0UAOpePwKWddQTco0WJEsN3je2X0q3fZgY18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfl1pJh8vbV2oOLbNrx9Agf1yszJmQpxKi+WKsFSnCsSYmHP2cy85JmlNACOsRMkfyORXO4tqho9i1DIUimfYw8PFst9VdtK6O9yuC3C39Xd3rYzOLbyQ2+n9hrx4ZPMu6Qd2qRMLrtKNqQHN6D9EkSDqM5vF+QVt8vyPB07IuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mj4EFajC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mj4EFajC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753FCC4CEF1;
	Fri,  9 Jan 2026 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962157;
	bh=sEETfLI0UAOpePwKWddQTco0WJEsN3je2X0q3fZgY18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mj4EFajCi3c5IktJf3HtC++gFEg4kxEqkfQs3ys49nYHMIdv7kqY2sWwRk8/6ECZS
	 Vc6HKW409LYNRzUAW23VCHzxozn8Wg2ZjSI5MsnDKGdKO2uYOm4ihst5bflqRHm3bt
	 5nxJu4VfzHShYnFMIgGVlSiRH6BkGPfyA77J4qm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/634] net/mlx5: fw_tracer, Add support for unrecognized string
Date: Fri,  9 Jan 2026 12:39:04 +0100
Message-ID: <20260109112127.545152487@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3ba54ffa54bfe..83a3074a725b1 100644
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
index 4762b55b0b0ee..3ff412999a3e2 100644
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



