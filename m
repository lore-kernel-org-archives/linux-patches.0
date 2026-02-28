Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02888343D7B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302258; cv=none; b=gxlWwXjc4p6io8JQDAGIt0ur6qeCOaHRirWqy5w1+StVAVOZiSu0lgtWB2HIQb2uWA3KsV/r3LNpqZ5qhGXQ3e4aSqP8Mi5opU2S7ojRjK4B6brpDsJ+uSv3kvUIIJueVOk+1fnh1llPsExdBxvghgS4S1aI8yvi0iaOpDUwtT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302258; c=relaxed/simple;
	bh=cIvM9cZQaVaOB3m0J80SmQTu4cZVnB3I0GrT4F4cUmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmo1qb3WExvWqqrWoE/Toql2rwwkPqlSN/UrPdhHCG4rxF1QIokj1rXSTMN0WpAM3cB5G9PK4F6wlQB+SpznLtywTqwB4mwmrTinexIgZk7A/cLovk8mPwk6WE3M+KXxsMCcVFCxnoFpMli6QMWNbCi8rgljBQmoDla9aZNkAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lux5gAQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lux5gAQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F96FC116D0;
	Sat, 28 Feb 2026 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302257;
	bh=cIvM9cZQaVaOB3m0J80SmQTu4cZVnB3I0GrT4F4cUmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lux5gAQ5jQYDFSJlaPUkkS3PJX+3BUPA58Rm336awQ1PBE6gugymzyPXBgrlsc/YS
	 6es+y6S20eEqYDtKY8o1RoJzrV3n5DCVzxo8CHmWINOViokI2BzcTe60Q9ygcGkZa7
	 R7GGN1EcXKtMSqKVBAft7Mem2vxKPkqJR58MytZWfkqxFbUYkxkZlKPzsCmcCmiz9G
	 D2Br8+HPgSUBqtiN6WPfly6CYNBOApVv2WX4wFQFm3NhFOC0IYt+Il/SN3sxCrMDdP
	 RZx5lua/J2fyQPZAlNK1gRdFhQ7wVwucpOVzU1VKaQF7sPMlPo/Lcz0DWeVPsJgVNl
	 QHrLbK8CZ/Uvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Juergen Gross <jgross@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/283] xen-netback: reject zero-queue configuration from guest
Date: Sat, 28 Feb 2026 13:06:54 -0500
Message-ID: <20260228180709.1583486-272-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 6d1dc8014334c7fb25719999bca84d811e60a559 ]

A malicious or buggy Xen guest can write "0" to the xenbus key
"multi-queue-num-queues". The connect() function in the backend only
validates the upper bound (requested_num_queues > xenvif_max_queues)
but not zero, allowing requested_num_queues=0 to reach
vzalloc(array_size(0, sizeof(struct xenvif_queue))), which triggers
WARN_ON_ONCE(!size) in __vmalloc_node_range().

On systems with panic_on_warn=1, this allows a guest-to-host denial
of service.

The Xen network interface specification requires
the queue count to be "greater than zero".

Add a zero check to match the validation already present
in xen-blkback, which has included this
guard since its multi-queue support was added.

Fixes: 8d3d53b3e433 ("xen-netback: Add support for multiple queues")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260212224040.86674-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index a78a25b872409..61b547aab286a 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -735,10 +735,11 @@ static void connect(struct backend_info *be)
 	 */
 	requested_num_queues = xenbus_read_unsigned(dev->otherend,
 					"multi-queue-num-queues", 1);
-	if (requested_num_queues > xenvif_max_queues) {
+	if (requested_num_queues > xenvif_max_queues ||
+	    requested_num_queues == 0) {
 		/* buggy or malicious guest */
 		xenbus_dev_fatal(dev, -EINVAL,
-				 "guest requested %u queues, exceeding the maximum of %u.",
+				 "guest requested %u queues, but valid range is 1 - %u.",
 				 requested_num_queues, xenvif_max_queues);
 		return;
 	}
-- 
2.51.0

