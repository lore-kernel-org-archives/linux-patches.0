Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA02ECE94;
	Tue, 17 Jun 2025 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176109; cv=none; b=lJNeFZA2GmbfneECTRak1Q4ooI3z7topL8EldUSK+m5TjkoQWxqnd1r6ZMvCV6ZjU2EMnbV5WjUP0wR9cV0MObMxR56wmHuY9yN9XbW9oV/v3DtMJKW58lJ95hSSTaIslBNK7b0RIoHNnzZ4k6SLPUJpmwqFCdatkDOqRhZgGco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176109; c=relaxed/simple;
	bh=26j4J55XU6SuWQYd2ofRCKbKxbx1YXYiEnhj90CZLMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo9LLZ0cOmyUuS/Q0jsb10ERQbfI/I/OMV0kY/Z7VgX7PHS58IWWGTKK4csZyRUxNU6ag9w7xg3zSZTV3L0nD0aCnwZz+oL8uWyE/hzihrCFu3eNld/tzCJ+csWyDCwdWX/wJ0O+8R7DsbNsv/5WI4LBWu0mdHcD9ICkC0kqTpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiOigOBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiOigOBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC4FC4CEF3;
	Tue, 17 Jun 2025 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176109;
	bh=26j4J55XU6SuWQYd2ofRCKbKxbx1YXYiEnhj90CZLMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiOigOBbVgMRHjvr21qHW3kD3TooYX0ysq2yByzmo8Wmi90bJR19SiFEEQwB6gzns
	 b31MMKNrRKWUHNZDeUW6EfggaBNNo64LMv9mAkEQwD0K1nZvwDhnRR+pRY1y4oErMH
	 omFQyxKDraqpvLJlyYERx4ZQU6xkGMcgD7Gx9jCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/356] gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt
Date: Tue, 17 Jun 2025 17:25:59 +0200
Message-ID: <20250617152348.030779940@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f41a94aade120dc60322865f363cee7865f2df01 ]

Previously, the RX_BUFFERS_POSTED stat incorrectly reported the
fill_cnt from RX queue 0 for all queues, resulting in inaccurate
per-queue statistics.
Fix this by correctly indexing priv->rx[idx].fill_cnt for each RX queue.

Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250527130830.1812903-1-alok.a.tiwari@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 8cd098fe88ef2..b4745d94cbbdb 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1992,7 +1992,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			};
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(RX_BUFFERS_POSTED),
-				.value = cpu_to_be64(priv->rx[0].fill_cnt),
+				.value = cpu_to_be64(priv->rx[idx].fill_cnt),
 				.queue_id = cpu_to_be32(idx),
 			};
 		}
-- 
2.39.5



