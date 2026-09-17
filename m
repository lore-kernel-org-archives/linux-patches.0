Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA0B4DDB30;
	Thu, 17 Sep 2026 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659757; cv=none; b=cBJ6tMSp2PThEmTcn8bh1Ensw47pdnQxxFFfLsWCQf22zGVnjFlurirBmjAL9WyoQCjnVFR+pr4ZJnZ06ib8vGm3tke++CVk5X0bZWtlNlg4p5201YpJdxkzhzDg8xENYXmtFOHzAthwQ8Xln4lsPAwPsityuMKvbC3TXxBBOgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659757; c=relaxed/simple;
	bh=yvRB2qHvtmdGzBUtH0BvhFW4n7aZ3mP09dhGdkfrFsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYd/mFY0Gs2skvidrkPF8RzZA/wdIcR0pIChsPfQBNl/wa8pFrV1jvAtktZx1B0b+jiaylH4j7Uk1HnNAQgB9NK2uam7xR+DMQvEXpDFjuk9GSxhRWwaps+xfxXzsK0Qnm+HiK+zuTTtFwW6fuHV1TbHjUeQk87CFaYAtjvvYdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqhsoP69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqhsoP69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345261F0089B;
	Thu, 17 Sep 2026 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659749;
	bh=n4IxYd9uZGRk0l+t/YEekZ4HHgy8ubohhuV1llegpFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqhsoP69EK1q2Plo76OF0wBrP1zt7Qx8Tn7fDV4sP7Npm+zy4DfyPJW6mj4zYBuA9
	 lSsO1THqT7++LdAX3UDbvuDJJmkMcM60bl/NG0IyRdpJS731yJI/9Rw0ydsoVSkCPD
	 Ck8xoakUJnKGR59vp5w20vE9ciZqZ9yp9Fk48QyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 360/733] net: macb: zero the link settings taprio reads back
Date: Thu, 17 Sep 2026 16:11:08 +0100
Message-ID: <20260917151400.572406693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit 0523d5c52a450590bf5992bd6925394f3cc403e8 ]

macb_taprio_setup_replace() calls phylink_ethtool_ksettings_get() with
an uninitialised kset, and kset is not only an out-parameter. On a
fixed link, or an in-band link with no PHY, phylink writes speed and
duplex only if kset->base.rate_matching already reads RATE_MATCH_NONE,
a field it never writes itself; in PHY mode before the PHY is attached
it writes port and supported and nothing more. Either way the speed
read back afterwards can be stack garbage. The ethtool core zeroes the
structure on every path into the op, which is why its callers never
see this; taprio is the only in-kernel caller passing its own variable.

Fixes: 89934dbf169e ("net: macb: Add TAPRIO traffic scheduling support")
Assisted-by: LLM
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260903123652.23900-2-f@lex.la
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index cd140f98cbc83..09fd83782ae3f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4331,9 +4331,9 @@ static int macb_taprio_setup_replace(struct net_device *netdev,
 	u64 total_on_time = 0, start_time_sec = 0, start_time = conf->base_time;
 	u32 configured_queues = 0, speed = 0, start_time_nsec;
 	struct macb_queue_enst_config *enst_queue;
-	struct tc_taprio_sched_entry *entry;
+	struct ethtool_link_ksettings kset = {};
 	struct macb *bp = netdev_priv(netdev);
-	struct ethtool_link_ksettings kset;
+	struct tc_taprio_sched_entry *entry;
 	struct macb_queue *queue;
 	u32 queue_mask;
 	u8 queue_id;
-- 
2.53.0



