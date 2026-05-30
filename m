Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB033E36A;
	Sat, 30 May 2026 18:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166592; cv=none; b=DVGijpYZX7FC0HXmlfd/mwH4zCsJ1r0LyYT4BpJi47goaFWQLS4c+LITu1RVrFAgi1rXVdSpCrF8NiotIjOkqPTcukmWRgTzIY4tVOTE8EdyK+ZC7obMYJA9SPAjTMNOoGLr+xFyqmreP7t/dJ7CzpNCYGJQWal8VJ7PNVMhL08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166592; c=relaxed/simple;
	bh=MGxR21G4YOis9zUho2pdaJVkIXeqwrRsh8Qk955TGk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zs0bsje0h3XHu3vSEvAT6iDr7I97HC6ofCX726BHCO6MSOjA9eGFz4/OMDt0NzldaC8fqBOSUYS6yeeKU5dQ3trZDaQGzIPENS9PwuAntJCDRqEx6XvqIdkRcIqyXH++8aWloGFEcn2Yf9DlG0srYQ1UpCld9D3LDFp5jiQgW9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmZTo+Np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmZTo+Np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0741D1F00893;
	Sat, 30 May 2026 18:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166591;
	bh=BG+uihWVNRb/hbjBP7aJs9d7u2s2Y03+dRkfKsFvPzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmZTo+Np0/vGqZxUdpayja4togysnWc/F5BanAzy+7mmppsUL5HxOTOjP1U3A5L3y
	 V6R91FVcnhiEXPFKXwVrFy0+sBL05JKb9tLUH9hyXWxf0qQm80yoxTTHPtwRZw/GNR
	 XbdIV1BsaOxmX7vZsJba0CY/zYUk3YyK1lV1b1zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/589] net/sched: sch_cake: fix NAT destination port not being updated in cake_update_flowkeys
Date: Sat, 30 May 2026 18:04:53 +0200
Message-ID: <20260530160235.581286166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index edf9a6e328d22..96bd0d36d8c12 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -619,7 +619,7 @@ static bool cake_update_flowkeys(struct flow_keys *keys,
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



