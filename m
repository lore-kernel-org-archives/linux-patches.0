Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A0395D8E;
	Tue, 21 Jul 2026 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664581; cv=none; b=b2JMc8o0uqMMw33M5KAi4RaJOTJSxDzVbmxPkC1Ha72OeJXW2xHZre3hKkeNimsy5XmhSKvJPOuXpEkRPc4KLS41rigamHW8ua7TkUCKkDgu9+Vmcpa0mwocPGHtlvGTLpOUA6csov8/Io7ZdQ7AFXGKNQW9AhX1QYEzbjZr47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664581; c=relaxed/simple;
	bh=tgVvwOiOOXEjZmv43bqAC/KDqwiH0wuJiH46QISI7NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKcMzOIf+pLqH6+aFFWdAZEGf/iU9y8vm6xNimK5snab0/j1qaMuLjNsRijKvuuIm3b92iGgVoa/cDUs8644JZZvoj+fKYIyzuHrW19vryCnoSRzlJIBKeI8J9i4r83AO5WlSwRxHV3/RkW0qy1a9wumu/MAXhN2M9lxd+1pKe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4pKEnVd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4pKEnVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009DF1F000E9;
	Tue, 21 Jul 2026 20:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664580;
	bh=fLZE4FsEJCRyc7kuPn0jh7Fxbdwk+Kkoq9Ig7x+QkLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4pKEnVdyeVKkVMuYN1e71GXUFcgYMRWFXIU4WnReGQ2dbQ0CKDTECy67zZsXISMx
	 /2D4cKjxU7pHAhrNIEvErejYXewfdaSrJ+gCMSdIokiZeOq1d4ccU+SahuMAe65EvP
	 YutW4KIXp8dmV9UFwpu6o7t2Fvk5hPITelRJFU4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1255/1276] net: airoha: Fix channel configuration for ETS Qdisc
Date: Tue, 21 Jul 2026 17:28:18 +0200
Message-ID: <20260721152514.178389592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 7d0da8f862340c5f42f0062b8560b8d0971a6ac4 upstream.

Limit ETS QoS channel to AIROHA_NUM_QOS_CHANNELS in
airoha_tc_setup_qdisc_ets() in order to align the configured channel to
the value set in airoha_dev_select_queue().

Fixes: 20bf7d07c956 ("net: airoha: Add sched ETS offload support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250107-airoha-ets-fix-chan-v1-1-97f66ed3a068@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -2798,11 +2798,14 @@ static int airoha_qdma_get_tx_ets_stats(
 static int airoha_tc_setup_qdisc_ets(struct airoha_gdm_port *port,
 				     struct tc_ets_qopt_offload *opt)
 {
-	int channel = TC_H_MAJ(opt->handle) >> 16;
+	int channel;
 
 	if (opt->parent == TC_H_ROOT)
 		return -EINVAL;
 
+	channel = TC_H_MAJ(opt->handle) >> 16;
+	channel = channel % AIROHA_NUM_QOS_CHANNELS;
+
 	switch (opt->command) {
 	case TC_ETS_REPLACE:
 		return airoha_qdma_set_tx_ets_sched(port, channel, opt);


