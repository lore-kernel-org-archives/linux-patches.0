Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC415157A5A;
	Wed, 30 Sep 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783848; cv=none; b=Newrz6Q8yQEikCXQM/EeL/9p7OoLqAoO6dQAc/IFsgju/Em6kNhX1LW3sVqzL46TJQYWqb9FZ1AkJ31Twz5ZYqTRKjvZXEhqOcCVoAksNKFB9z14htIMMrDiSRDO1NnqiUJcWKRo730qhLEquXIuENZzXJe1zzf1P1sKXn+rLhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783848; c=relaxed/simple;
	bh=scTy3U4yYzH1VX+Fbg7UHvxfRhXlvbunev6icRWPDFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1dHZnkph8pewKlvjQCSJMkr/inrjJBy+vFm+WnMRMsMwNw8SrDeh3EvIZt4C5b1LPiyGsG8jSu62bV3j40Z36PtDub6C8eIafvUf638iEqkVl8iW90MqXHMgCRytzTGRN7UYsP5yN9SdKgPj3FT3C3zI4eJU9TL6QWlSxMdws0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdQ3/cm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdQ3/cm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6BE1F00893;
	Wed, 30 Sep 2026 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783844;
	bh=q8y+hU2PhBKAmb4s2e/TDQeXwsKCiqFfAXlH+wskq38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdQ3/cm9WJw+6DLjkxQuGMqMoSFqCLjAU2rr03D4uOFFdMoonAm8Qi+sSdi7Tkl1w
	 Il/wLTBCr+eiqkMfA4pfiXoyoywN9DMt1W3U31Fiey0I32NxvvovQa4TNRWWAoY5Qu
	 vlpC/6mqrIGTxl3dSz/I8xXoIkSoB27mFKTu76vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 540/595] tipc: Fix a data race on mon->peer_cnt in mon_timeout()
Date: Wed, 30 Sep 2026 17:27:13 +0200
Message-ID: <20260930152359.323627773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ginger Li <ginger.jzllee@gmail.com>

[ Upstream commit 8e1937fed6738460554ec123c64839e2445e7d53 ]

mon_timeout() evaluates dom_size(mon->peer_cnt) before it takes mon->lock,
while mon->peer_cnt is updated under that lock by tipc_mon_add_peer() and
tipc_mon_remove_peer().  The value can therefore be stale, and the decision
whether the local domain has to be recomputed can be based on an outdated
member count.

Read mon->peer_cnt inside the write_lock_bh(&mon->lock) protected region.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260922080909.21123-1-ginger.jzllee@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index ba0a308d41d85..0b5832640b32f 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -601,9 +601,10 @@ static void mon_timeout(struct timer_list *t)
 {
 	struct tipc_monitor *mon = from_timer(mon, t, timer);
 	struct tipc_peer *self;
-	int best_member_cnt = dom_size(mon->peer_cnt) - 1;
+	int best_member_cnt;
 
 	write_lock_bh(&mon->lock);
+	best_member_cnt = dom_size(mon->peer_cnt) - 1;
 	self = mon->self;
 	if (self && (best_member_cnt != self->applied)) {
 		mon_update_local_domain(mon);
-- 
2.53.0



