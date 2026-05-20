Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D785A36F901;
	Wed, 20 May 2026 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298999; cv=none; b=ahOOwsSJYmF6EUcUPbgMIro0cgEOuX1eFL8ooS/9DvXzHuPozqYJPB5wd94vSFGfO1mOQi6cBsJ1H/VRKfLKmAz3QqN5rfs6lU70j4TpZpYLPcrYIIm8bX/73JlJHPwservWG98gllY/NL/bcfKNlusvYX6tEZ0G5Wq7VYOYSTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298999; c=relaxed/simple;
	bh=amGxJ3bXNXUi7/YNHQCZt5burf6NxV8gCrzA+/xrRuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWQrjPYkLltMCm8WV7uzp9Vw7QA83uaK6yya2y3UPk4hp8JOWjDhuR0Xz1wnB8AfSXHLQwKyIcGMM8QxHUh7Z+HzT5htQTtZ4MpNObYhP2WtiNU6B4nuKaajI0kXqcM4E/uCROYdUkKzlIcw8LWHKknkxfpoHYCwXfh1vnIzsdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEJTb3AR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEJTb3AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BB01F000E9;
	Wed, 20 May 2026 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298998;
	bh=APoX5xKBRySpuwfceItLLb9ebXk2s8DlXZ/+TOCH/YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEJTb3ARgCYa2AIn1+Ltv9buSjh4lZagOnIbA020c2kfJLXrsCfU8mc7G7CALjEIQ
	 Icx54NUreh7iq+hKKI4H9o5Enk3hzVFHxPaZ8T4WreL021Gw1nJp60AmH7GJTcRqrf
	 uPiEpAi5i1Yz8l/TKu/sbOD/HxOPh6H3aiAbB/gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 617/957] net/sched: sch_cake: fix NAT destination port not being updated in cake_update_flowkeys
Date: Wed, 20 May 2026 18:18:20 +0200
Message-ID: <20260520162147.914681249@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit f9e40664706927d7ae22a448a3383e23c38a4c0b ]

cake_update_flowkeys() is supposed to update the flow dissector keys
with the NAT-translated addresses and ports from conntrack, so that
CAKE's per-flow fairness correctly identifies post-NAT flows as
belonging to the same connection.

For the source port, this works correctly:
    keys->ports.src = port;

But for the destination port, the assignment is reversed:
    port = keys->ports.dst;

This means the NAT destination port is never updated in the flow keys.
As a result, when multiple connections are NATed to the same destination,
CAKE treats them as separate flows because the original (pre-NAT)
destination ports differ. This breaks CAKE's NAT-aware flow isolation
when using the "nat" mode.

The bug was introduced in commit b0c19ed6088a ("sch_cake: Take advantage
of skb->hash where appropriate") which refactored the original direct
assignment into a compare-and-conditionally-update pattern, but wrote
the destination port update backwards.

Fix by reversing the assignment direction to match the source port
pattern.

Fixes: b0c19ed6088a ("sch_cake: Take advantage of skb->hash where appropriate")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260413110041.44704-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index d325a90cde9ee..1a2023cd55109 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -606,7 +606,7 @@ static bool cake_update_flowkeys(struct flow_keys *keys,
 		}
 		port = rev ? tuple.src.u.all : tuple.dst.u.all;
 		if (port != keys->ports.dst) {
-			port = keys->ports.dst;
+			keys->ports.dst = port;
 			upd = true;
 		}
 	}
-- 
2.53.0



