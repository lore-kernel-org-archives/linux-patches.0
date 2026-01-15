Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5D83D331A;
	Thu, 15 Jan 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499317; cv=none; b=Fd/+W/ZsgZLuH17VjS9f6EzLUo3iF0gMteoGvxATcd2D8VGBfgXrjzDt8pnoeeUzm89xNgzbajX/1Z8dFvnXp4WhTSAk9GyEA47L0KYMl73Aic54sZXut6byEJjVwmyYtgrr9eviLTPAiR1fSrA8rECMC4y9IUYB4S2VHx5ckRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499317; c=relaxed/simple;
	bh=I9dxoNHhlciASeKYTDNrbNJYmOyX9lqK9Uc/kxZjnxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4Wr1yO7jOBUwHooQq+xIJY2XsTg/PEF8kDy4a1bSTzQYgzCA68xvQ/G/dUJwms5Ibkm9yKbQtIa3euNKU0yI2qwXCrzkM5w/s96h0mgCyVF8Edb5FVWWmbavQIjIOKlAPd7L3MaXAYNNJFd6WpuKwQY0luUbkDOuzvLZMLlvfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1w2AGx32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1w2AGx32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0505DC16AAE;
	Thu, 15 Jan 2026 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499317;
	bh=I9dxoNHhlciASeKYTDNrbNJYmOyX9lqK9Uc/kxZjnxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1w2AGx32Oa6nsmqXVQS1lOLRRysevSv5bGJk0+LVosMaZ3gNnb+1hP/3b4aR0p8Jo
	 /0AJGAGsJgD+yIKQR80OecKrmfhlFwla1KrLZ4T16It9lgJ2BvX9wLfkIRnNNIP3rW
	 Vir8/Zm7VTsh38l3cCoMeOnA0Jf6JtMDA2iDYQu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/451] net/mlx5: fw_tracer, Add support for unrecognized string
Date: Thu, 15 Jan 2026 17:46:25 +0100
Message-ID: <20260115164237.559058446@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d49fd21f49637..1002bf0078659 100644
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



