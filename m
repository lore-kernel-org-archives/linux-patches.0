Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8227F3FC5B1;
	Wed, 20 May 2026 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302555; cv=none; b=RKMYoT7d4s1Wx6/7DhgBTdBJwGAF6Afs19q0m5DdgZhiTfgQ29IsYK61/vhHKkcNIC0VvLITWYB+BKoCOQnUAnkwZTRd7nYiz48VZ8ZiEtOGpkwczzwMibQrYSe+P4WdoB4RMBG5N9Iv9HndLs7FkfM4/kw2S/4NlOB3nUZX4Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302555; c=relaxed/simple;
	bh=s84VXc93XxVxtSt7rDziOWxo9Fih3wR5wSsP3qcFxVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZXYp727/XXC4WSMxC3Z6AMwU5dmSKJRRVJpWWXlvn56lDdEx+VJrwUgg4K49uzLk38IrhhJhdojsqakgl8Wzn3Arn8o0AlDzgPIUurexBJU1WLbDts3P6Osit3XPedcW9fGZrAwd0eGb1g1s5Cn3GqrWGCs06OUaWGmeZr8Ujs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeJ1fhsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeJ1fhsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6101F000E9;
	Wed, 20 May 2026 18:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302554;
	bh=kPWds7Fu+oRCg1M5WWyn9oBwcPlIMABePoRiLPYqcDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeJ1fhsf+Y7ubiMpB4BlKVS0TbXy93CgCBlj/jcAqK3jqjUsBq3Q3D6wDJWihVjCw
	 BtT0XF8QHRfLENtUSvkAzLFXKr1n8T1xVKe0AwRzkmExizprbsG4fKS3UeiX+7oqF+
	 nEQfr7miOUGOFMkatsLoLdl9snQgfNEbshaeKq+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/508] net/sched: sch_cake: fix NAT destination port not being updated in cake_update_flowkeys
Date: Wed, 20 May 2026 18:22:15 +0200
Message-ID: <20260520162105.399522598@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 14e06f474b6ca..55e8b682ec14c 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -620,7 +620,7 @@ static bool cake_update_flowkeys(struct flow_keys *keys,
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



