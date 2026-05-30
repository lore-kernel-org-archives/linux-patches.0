Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6451D2690D5;
	Sat, 30 May 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160737; cv=none; b=YBgu9E0gu7TE3eILOZSQ6gAOjbIwKiv7nbmclqKSuJEtnKsFLI7w/GXYu19bJJbiTM3stDcblo8lALhnaYAZTQ5atxz1UpyEgbexFBozCX35DAiBTT6+KCvQ8qiV7ugPdG7O0Xr6YD7o/LftoogpuyauL00X0zKK3mG/nPo2NO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160737; c=relaxed/simple;
	bh=m2zk5wT6IOGa7hoGs634Av8xzDPZUV+6Jz5O2Ed6hk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyieCWs4NT9OwNlardongn3eY9dHNebQ3DThaDSAbu9cYULWK+7fqckMHTiHJ8RVwgTUd2rAPC6Fq+JIFrcu3vekxSB82PAxjxivsLChsCR6KqLPuQftrfrxAqFANoC9D2IuOKJEOn7JvtBGwt8UQhx/oNaUDdOFPHXNWSQDfQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQpSj/Rz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQpSj/Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C691F00893;
	Sat, 30 May 2026 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160736;
	bh=RAeQir5G7NqPgxHj2snMH22RWcYMqPBGH5yoFAyj+MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQpSj/Rzgv0FAR5D+ioXn2CxEJqbbXn/stAYJ5PLwsW6oFcZWyVlviEGqB+5dGeJE
	 PJc0wbDw+YfEIvEydiTDsnn+jqoqrxa8+yDF0l86BFZNV8tv7CSaJqIFt3BAikj+n6
	 Vv0VQoZ+RElv1/v64/WOCsjY/xNhJh+LQc3Wv+UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 421/969] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Sat, 30 May 2026 17:59:05 +0200
Message-ID: <20260530160311.892226588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ba9d20ee9076dac32c371116bacbe72480eb356c upstream.

When batadv_bla_add_claim() fails to insert a new claim into the hash, it
leaked a reference to the backbone_gw for which the claim was intended.
Call batadv_backbone_gw_put() on the error path to release the reference
and avoid leaking the backbone_gw object.

Cc: stable@kernel.org
Fixes: 3db0decf1185 ("batman-adv: Fix non-atomic bla_claim::backbone_gw access")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -723,6 +723,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


