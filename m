Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA893CE0B4;
	Wed, 30 Sep 2026 19:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795625; cv=none; b=GuMTsOtT1jefQG18frnpU4m0rH7xW4x+2CsMkfjPQCIgSHEROE2kHV4dbzXkfOvFNrx3Iz80AaRG8h83VQjxumoeGEFMuOYUOku6bxmvyyYaNV1gVBtU/Vl1uuAMq0MhzDW/E7mR7aJSvPSThZ1Xt66AIJNlm1nhfLxJqHWzS8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795625; c=relaxed/simple;
	bh=6vGVevuDGj6OhW00B+8oyxtPngTP1h9QUO4ud8gyACk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFvnTvelMur1ZcubpHm06nbFo665mbtZUNa5+Ih+unTeBfm8knOBDikYB3xuaR6mjdbr4hU/hCSXlh07wrqL3ktnNu7S6CQ4s/MjgyouyfIW0zm283jFSglCFq6wQN+jzRIUjQoqzBgsUbQWa2e4OgJ0MLlaa7JWfL/80vy1G34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JscpKZlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JscpKZlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1FE1F000FF;
	Wed, 30 Sep 2026 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795623;
	bh=fy5U0pjyZa0P8MR7s6mEdpsZ8poN/5PnxhxA2N9IzXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JscpKZlBnSNpTa9twbFFn0iOL2mz+6hHMviJea2vAbDqNQhXaxvTMqW7c2m6iNXWR
	 B7QyCdpW3NaZxLeagf1p7/swOWNxoxbDruG4fq6IqwjHltFE3MxIYlzailcPWOMEPe
	 S0CMFJn6nOQEHWpNqvRt++WZSc89ntITyKJHC2nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahil Chandna <sahilchandna@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0627/1193] net: mana: Reserve extra CQ slot for the fence completion CQE
Date: Wed, 30 Sep 2026 17:21:51 +0200
Message-ID: <20260930152448.175148847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Sahil Chandna <sahilchandna@linux.microsoft.com>

commit 80dd7e754b3aa9637a0758ad93fa209f9650ec48 upstream.

The RX completion queue is sized to hold exactly one CQE per posted RX WQE.
MANA_FENCE_RQ makes hardware post an additional CQE_RX_OBJECT_FENCE after
the packet CQEs. The current sizing reserves no extra slot for it and in
rare cases, CQ has no guaranteed slot for the fence CQE when it is full of
packet CQEs. This can lead to dropping the fence completion while the
driver waits holding RTNL lock throughout the timeout duration.
Reserve one extra CQE slot for CQE_RX_OBJECT_FENCE. mana_gd_alloc_memory()
requires queue_size to be a power-of-two and at least MANA_PAGE_SIZE;
the reservation pushes cq_size past a power-of-two, so round up the CQ size
in mana_create_rxq().

Cc: stable@vger.kernel.org
Fixes: 6cc74443a773 ("net: mana: Add RX fencing")
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/20260901121837.3503240-1-sahilchandna@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2152,6 +2152,10 @@ static int mana_alloc_rx_wqe(struct mana
 		*cq_size += COMP_ENTRY_SIZE;
 	}
 
+	/* Reserve an extra slot for Fence completion
+	 * event (CQE_RX_OBJECT_FENCE) in case RX CQ is full.
+	 */
+	*cq_size += COMP_ENTRY_SIZE;
 	return 0;
 }
 
@@ -2234,7 +2238,7 @@ static struct mana_rxq *mana_create_rxq(
 		goto out;
 
 	rq_size = MANA_PAGE_ALIGN(rq_size);
-	cq_size = MANA_PAGE_ALIGN(cq_size);
+	cq_size = MANA_PAGE_ALIGN(roundup_pow_of_two(cq_size));
 
 	/* Create RQ */
 	memset(&spec, 0, sizeof(spec));


