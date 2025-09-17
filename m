Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CC62FBDFF;
	Wed, 17 Sep 2025 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113269; cv=none; b=iVknUTt2vklLdngMtTVX7IryqWUo1NzfEwHJ3Ar26xnt8ojKk8dqe5GGp4YyIHCLKPWQ5TiF+jm7iy2ZAn5dhBEKyW1JQcotvrDJ8BzjMH/Z1uKR6DEjTIGuwlSvY1DRS08ZbGnGFEkZ9JS4ybYOJVCNN3CriEJzDKHHAPEmONM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113269; c=relaxed/simple;
	bh=yo4NqTqFf/8uKzy8Vjuh0ygzuZOMNWxTSrj5Lj4z3r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgrlX/CvDqzZ+oHqLSd6Hsx6HLjHWzoNrXf+FcvaOobQ5XQBAPyK6Sl7qh/zTHKz1q/tHwv12kIKcfH9KfV7Wgu65qHwp8LlSV7jYzdZpAawZGdzdgR4IGl2teuidmzQqanRaf8PtADh1tFIfxJN6rSEzPvUCSmFkmtAW9FAzms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLbuvdYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLbuvdYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342BCC4CEF0;
	Wed, 17 Sep 2025 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113269;
	bh=yo4NqTqFf/8uKzy8Vjuh0ygzuZOMNWxTSrj5Lj4z3r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLbuvdYavWrErfXHxEI8lO0BPBjXnhgXnpfvkXo1h6gEBALzd6O57ZSHfDGGvhjfd
	 O/2RMkSYwarw2yBigyiHb1latBKjXm4r6K1QlLit1bAwV5v32OOaC1472Oj42ooGWN
	 EJqcTpTzWp7F1QADgBZk0VfSJLcb7f9+0T5lwjo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jan Alexander Preissler <akendo@akendo.eu>,
	Sujana Subramaniam <sujana.subramaniam@sap.com>
Subject: [PATCH 6.12 008/140] net/mlx5: HWS, change error flow on matcher disconnect
Date: Wed, 17 Sep 2025 14:33:00 +0200
Message-ID: <20250917123344.523489396@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

commit 1ce840c7a659aa53a31ef49f0271b4fd0dc10296 upstream.

Currently, when firmware failure occurs during matcher disconnect flow,
the error flow of the function reconnects the matcher back and returns
an error, which continues running the calling function and eventually
frees the matcher that is being disconnected.
This leads to a case where we have a freed matcher on the matchers list,
which in turn leads to use-after-free and eventual crash.

This patch fixes that by not trying to reconnect the matcher back when
some FW command fails during disconnect.

Note that we're dealing here with FW error. We can't overcome this
problem. This might lead to bad steering state (e.g. wrong connection
between matchers), and will also lead to resource leakage, as it is
the case with any other error handling during resource destruction.

However, the goal here is to allow the driver to continue and not crash
the machine with use-after-free error.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Itamar Gozlan <igozlan@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250102181415.1477316-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jan Alexander Preissler <akendo@akendo.eu>
Signed-off-by: Sujana Subramaniam <sujana.subramaniam@sap.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_matcher.c |   24 +++-------
 1 file changed, 8 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_matcher.c
@@ -165,14 +165,14 @@ static int hws_matcher_disconnect(struct
 						    next->match_ste.rtc_0_id,
 						    next->match_ste.rtc_1_id);
 		if (ret) {
-			mlx5hws_err(tbl->ctx, "Failed to disconnect matcher\n");
-			goto matcher_reconnect;
+			mlx5hws_err(tbl->ctx, "Fatal error, failed to disconnect matcher\n");
+			return ret;
 		}
 	} else {
 		ret = mlx5hws_table_connect_to_miss_table(tbl, tbl->default_miss.miss_tbl);
 		if (ret) {
-			mlx5hws_err(tbl->ctx, "Failed to disconnect last matcher\n");
-			goto matcher_reconnect;
+			mlx5hws_err(tbl->ctx, "Fatal error, failed to disconnect last matcher\n");
+			return ret;
 		}
 	}
 
@@ -180,27 +180,19 @@ static int hws_matcher_disconnect(struct
 	if (prev_ft_id == tbl->ft_id) {
 		ret = mlx5hws_table_update_connected_miss_tables(tbl);
 		if (ret) {
-			mlx5hws_err(tbl->ctx, "Fatal error, failed to update connected miss table\n");
-			goto matcher_reconnect;
+			mlx5hws_err(tbl->ctx,
+				    "Fatal error, failed to update connected miss table\n");
+			return ret;
 		}
 	}
 
 	ret = mlx5hws_table_ft_set_default_next_ft(tbl, prev_ft_id);
 	if (ret) {
 		mlx5hws_err(tbl->ctx, "Fatal error, failed to restore matcher ft default miss\n");
-		goto matcher_reconnect;
+		return ret;
 	}
 
 	return 0;
-
-matcher_reconnect:
-	if (list_empty(&tbl->matchers_list) || !prev)
-		list_add(&matcher->list_node, &tbl->matchers_list);
-	else
-		/* insert after prev matcher */
-		list_add(&matcher->list_node, &prev->list_node);
-
-	return ret;
 }
 
 static void hws_matcher_set_rtc_attr_sz(struct mlx5hws_matcher *matcher,


