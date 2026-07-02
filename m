Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94434DD6E0;
	Thu,  2 Jul 2026 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009649; cv=none; b=cHERByYlKdOFM/psNyOtCplnzwHzCxkHXSgdV9QImzWO1yXVueAMx6h2EFwf0K6fYhqwNK3YPF3/b0mC3/1sg5PF3f2I6AlhsAI/dvZKyKGbT4sKPqUc1/TeEhvLFx+eMugbl9Buh6sBG6xR89mlOnD2ysAy+W1kH7DJsgOw/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009649; c=relaxed/simple;
	bh=+Er7iQNLWnhOhJL244BCucrJRfdtB1lsCfELfewOhH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaQnI7d/zoAQzERhCt9fpksp3UzeMLCKnr3oacBzkeP3IMLODD+77rP3BLEkDOR2S3O0xMCEl7DcECticMPjih5p07mU4tQb9IePrdLXMXr+qba/Y2VG93RWyhoTK22PwHr8H4pWwaNUy17qSsRwaHtEElbUjvgWzflWbMSGRwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWLazq9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWLazq9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1741F00A3A;
	Thu,  2 Jul 2026 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009646;
	bh=SVD+rcrAcCMBxTN33cgzRqrVn22JL+kLN+wNdF+dPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWLazq9yRxe+2YNBKYyzChQba+FfR+gaIi9+dkaLxA8oA+EYx0jp59tvKArAqMtub
	 ryQK625/6P9KwsbNR0zsk/cE8aACpsaXr5AZIzFSmlY8OupSVoimb6ruqTmPV9hZhY
	 LNA4wgBllWEfcM6HG3a4+8+Gu097p4reAT+cX2/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/95] batman-adv: tp_meter: fix fast recovery precondition
Date: Thu,  2 Jul 2026 18:19:36 +0200
Message-ID: <20260702155109.903633121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 2b0d08f08ed3b2174f05c43089ec65f3543a025b upstream.

The fast recovery precondition checks if the recover (initialized to
BATADV_TP_FIRST_SEQ) is bigger than the received ack. But since recover is
only updated when this check is successful, it will never enter the fast
recovery mode.

According to RFC6582 Section 3.2 step 2, the check should actually be
different:

> When the third duplicate ACK is received, the TCP sender first
> checks the value of recover to see if the Cumulative
> Acknowledgment field covers more than recover

The precondition must therefore check if recover is smaller than the
received ack - basically swapping the operands of the current check.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index f961beac12282e..1fc8d6e6f99b30 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (recv_ack >= tp_vars->recover)
+		if (tp_vars->recover >= recv_ack)
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



