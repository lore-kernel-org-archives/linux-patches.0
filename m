Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B873F871A;
	Wed, 20 May 2026 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296581; cv=none; b=eCmj8ZCm8f/b22GR4kIyczfNq097JAaMZpFskP+zWE1DOjLpmcT1Okt3dEZP/n1C9bKcV8V9U3QD5uPFEiWE/OrL1w0eqx5vzXdxDLjSbY8e+yWGyd5uDSfIHH7xRfSTUmo1nzLx8zH/lcjMzABFFelIQ5OLpknzI2Q0qxiCYUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296581; c=relaxed/simple;
	bh=5f7xRQi1tX5q9BEGGHi5pdHNNbnY5UxqNPvVxOSDi3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGEXgbQw2o62rvNnhtgF+e6ayXOPcgC+RoqhOfVIC2DHZ50f0WZfuydQNeYXqBhHMmPk1/u5TdG17FpVl/ImAq2uK1k0hB+M4JkwVbFLRGVVe9eZvqGnH9GimRwU+xjNjLZ1GDCumQBqOz8R+bjw1TlMXu7KYZgXrEfjQXTtedo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECb5OEVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECb5OEVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF371F000E9;
	Wed, 20 May 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296577;
	bh=UBRm0Y1aZRmAN3zLXC2XNUDms9+GkAE4EGdm/tT8Blk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECb5OEVlyi9Jy7DMVbxnVSJEdgBab4JXLOmJD49ux34dWvcaw0RO6DxHwKfglgLXZ
	 HqCRTWe7Hgsu8Van+IPGsTVxSyT028QdDahER671fjOvD4ENS+LYl060uhxiS50TUO
	 l9vpTHw7RQlYKOMIXRWMeOhAD2MuEiJIwUOxuR9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0851/1146] net: mana: Init gf_stats_work before potential error paths in probe
Date: Wed, 20 May 2026 18:18:21 +0200
Message-ID: <20260520162207.497601563@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 6e8bc03349fe4f09567fa76235abf52bdaf83082 ]

Move INIT_DELAYED_WORK(gf_stats_work) to before mana_create_eq(),
while keeping schedule_delayed_work() at its original location.

Previously, if any function between mana_create_eq() and the
INIT_DELAYED_WORK call failed, mana_probe() would call mana_remove()
which unconditionally calls cancel_delayed_work_sync(gf_stats_work)
in __flush_work() or debug object warnings with
CONFIG_DEBUG_OBJECTS_WORK enabled.

Fixes: be4f1d67ec56 ("net: mana: Add standard counter rx_missed_errors")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-3-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2b3dd326a8e15..974df81855d23 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3598,6 +3598,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 		INIT_WORK(&ac->link_change_work, mana_link_state_handle);
 	}
 
+	INIT_DELAYED_WORK(&ac->gf_stats_work, mana_gf_stats_work_handler);
+
 	err = mana_create_eq(ac);
 	if (err) {
 		dev_err(dev, "Failed to create EQs: %d\n", err);
@@ -3672,7 +3674,6 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 
 	err = add_adev(gd, "eth");
 
-	INIT_DELAYED_WORK(&ac->gf_stats_work, mana_gf_stats_work_handler);
 	schedule_delayed_work(&ac->gf_stats_work, MANA_GF_STATS_PERIOD);
 
 out:
-- 
2.53.0



