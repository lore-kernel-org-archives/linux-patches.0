Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C10B1C695;
	Thu,  2 Jul 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011287; cv=none; b=G9qzV35Jb8oGa35pVvcaxUFaLviz8QBPpRC/8aU8S6aHKt6WE0BtiIlEizUjK8y71d/SOkl1gELJoKWgElhpCOfR5DI1nPdbawVBgbRB2R20xSqZmeAjNGgAWdB+Qe09D1cRlkhsQAxKDRrPzVhSHfkzQF5wvBrCPqJy8CST0pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011287; c=relaxed/simple;
	bh=/rxZ3b5BiGoda2iuEgYLTfAD2KmSr236j6cD2DTtSb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxS8EE/iF4nAb13kQaQJOYm5J0hwAcch0hX20NxzeAlPgh3DjMagpbrKP5GU+S5u7DScn7F2n2m6hxIW9cjPaFMKeJnkLzUl4O9TUnM3iQc9feR6fhdS3ZDB/EUV4cl8S63lnQwZuWqPCsmdYsaDXy5GTQ8v5FDj76kDf2Go108=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkwbfvk6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkwbfvk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21671F000E9;
	Thu,  2 Jul 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011286;
	bh=ouBSktitWGWnMxo1/5P+Uy+r9F9ihbHzSH5pj2Xt7eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkwbfvk6UMeg8PKuf5AwRWt7PELQChs/9q+zB6+sD1ljos2w9JD15ktyzHkbI5Ye9
	 wR5Uep5pueATaoLRPaQfVegO3sC0KgeF1ioQQ3Nz1CmZabIlJWoVh8W0jH5DUTDxmn
	 xpCt6/eVcggXR6svmbJdsPx5FNJ+3ETNosF8+RyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/108] batman-adv: tp_meter: initialize dup_acks explicitly
Date: Thu,  2 Jul 2026 18:20:04 +0200
Message-ID: <20260702155112.265021401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b2b68b32a715e0328662801576974aa37b942b00 upstream.

When an ack with a sequence number equal to the last_acked is received, the
dup_acks counter is increased to decide whether fast retransmit should be
performed. Only when the sequence numbers are not equal, the dup_acks is
set to the initial value (0).

But if the initial packet would have the sequence number
BATADV_TP_FIRST_SEQ, dup_acks would not be initialized and atomic_inc would
operate on an undefined starting value. It is therefore required to have it
explicitly initialized during the start of the sender session.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index f222c5093b647e..fe9a447643074a 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1045,6 +1045,7 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	tp_vars->icmp_uid = icmp_uid;
 
 	tp_vars->last_sent = BATADV_TP_FIRST_SEQ;
+	atomic_set(&tp_vars->dup_acks, 0);
 	atomic_set(&tp_vars->last_acked, BATADV_TP_FIRST_SEQ);
 	tp_vars->fast_recovery = false;
 	tp_vars->recover = BATADV_TP_FIRST_SEQ;
-- 
2.53.0



