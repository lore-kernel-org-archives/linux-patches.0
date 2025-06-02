Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E19290F;
	Mon,  2 Jun 2025 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875989; cv=none; b=K4xgA+ALlJMj4C1HP/KAY8hVKvuzOh1uLdeJRqRpKvbVhvGRBPlHOK05br8bTbLBlarCTrvNEZajjox2Z3v7qqrl7dgldoKoqGc2YxJcJKr4ZQRFnqVMDkDXbBuOItIz+cmYGkbDscVP6u47uN1vtDNMy9gN8kfi7IpK83NpCNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875989; c=relaxed/simple;
	bh=cV1x8215tjtv2amYQQ/73HZJyTg+U/ji2Rrzt4Vheho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUypdEku/tPIDeOcNI5Z4F6R30RisVhfbgZWoS7j+Y6d1ksxPatAL1/QE/iq4UNPGtVuR9yfmblijAA8MUTQRvx/hoVLCL8lqZySITVHE1lkA/SpZ7yfI845BFxNYGc9f+rgibJfLh4+WW1d5e6XT/uLfzM7eJV4SaRxLCX53QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihyJOVTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihyJOVTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94429C4CEEB;
	Mon,  2 Jun 2025 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875989;
	bh=cV1x8215tjtv2amYQQ/73HZJyTg+U/ji2Rrzt4Vheho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihyJOVTF3pbHIVqbzcKH4QzOQYOZstIzQA87PdIzH7VATK0KXDMbbFYxMiYjL/6mi
	 JUeWVEBR/X7Hxp3bnPhWXORYzp7GXuECe88GiIZ5z9rumvod9ZXzfKfW58T36nVPZ2
	 z78QuXWMoESx8zvFXck88Dh2q5u79BM35C49uLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Su <jingsusu@didiglobal.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/207] dql: Fix dql->limit value when reset.
Date: Mon,  2 Jun 2025 15:46:31 +0200
Message-ID: <20250602134259.523143829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Su <jingsusu@didiglobal.com>

[ Upstream commit 3a17f23f7c36bac3a3584aaf97d3e3e0b2790396 ]

Executing dql_reset after setting a non-zero value for limit_min can
lead to an unreasonable situation where dql->limit is less than
dql->limit_min.

For instance, after setting
/sys/class/net/eth*/queues/tx-0/byte_queue_limits/limit_min,
an ifconfig down/up operation might cause the ethernet driver to call
netdev_tx_reset_queue, which in turn invokes dql_reset.

In this case, dql->limit is reset to 0 while dql->limit_min remains
non-zero value, which is unexpected. The limit should always be
greater than or equal to limit_min.

Signed-off-by: Jing Su <jingsusu@didiglobal.com>
Link: https://patch.msgid.link/Z9qHD1s/NEuQBdgH@pilot-ThinkCentre-M930t-N000
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_queue_limits.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index fde0aa2441480..a75a9ca46b594 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(dql_completed);
 void dql_reset(struct dql *dql)
 {
 	/* Reset all dynamic values */
-	dql->limit = 0;
+	dql->limit = dql->min_limit;
 	dql->num_queued = 0;
 	dql->num_completed = 0;
 	dql->last_obj_cnt = 0;
-- 
2.39.5



