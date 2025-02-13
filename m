Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FA426B080;
	Thu, 13 Feb 2025 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458886; cv=none; b=qqdxsBqKwpNznvd4AtatZMxpduGbTyZZE/nup2g+srnuxnZLG4Ph7Zy5CsgUiMF1grFkU2Cgxh/B+Snzmgvzs9hIsFJFcXSJAKBg4a6CkgGy2dzY1KZgiFk7Z6kxqHZxDEeWvLwp9uor8hIfCJgRGCCkrhO6U7jwlswcy81gLe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458886; c=relaxed/simple;
	bh=7RmH3NhI4wj5DdZWFySUSHeQ+SANgsRIIJRO/b0TPwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN19EnVquEZPqPHW1ArnTFfuVaDTkwJgDGZmx2zH+m6DqBcseOOFf1lEYbU8fH/LXYgbMrzdiaGOFb+dvSWpoMa4MUphE50hbPHr/z/MI/pkRtXhDVPBK3e0uUtPeY4niYyciYD/5EptCzcTee16lL4ivDGssQ1a6ru6XCcsgwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPmJKyEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPmJKyEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F90DC4CED1;
	Thu, 13 Feb 2025 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458885;
	bh=7RmH3NhI4wj5DdZWFySUSHeQ+SANgsRIIJRO/b0TPwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPmJKyEUkYLwy/zANC46M0/ihVVodeC+tbwgvdaqJOtTHzHTlr6nYLmCgE1MkSy8u
	 yk6JTLwC6RO2mlJvAGU+SzDaNHl+RllWs0pyBfyIEkPqVd/TD0wpbeHEf8MTyewA5o
	 nGGMBelUZH7GnSzQHRkRYEgM9HDnGYODi4W2KOm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 064/443] net/mlx5: HWS, change error flow on matcher disconnect
Date: Thu, 13 Feb 2025 15:23:49 +0100
Message-ID: <20250213142443.091083173@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 1ce840c7a659aa53a31ef49f0271b4fd0dc10296 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/matcher.c | 24 +++++++------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c
index 1bb3a6f8c3cda..e94f96c0c781f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c
@@ -165,14 +165,14 @@ static int hws_matcher_disconnect(struct mlx5hws_matcher *matcher)
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
 
@@ -180,27 +180,19 @@ static int hws_matcher_disconnect(struct mlx5hws_matcher *matcher)
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
-- 
2.39.5



