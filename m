Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CEC4BE439;
	Wed, 30 Sep 2026 15:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783037; cv=none; b=uzH2SG12PexNIhMHhxjb7iG4+MOyGUx3h8IYXqbeIxtGn6S9WLPtNwFq8P0xnWkP9ZoeTbGc2FRhx9lUxCkSOx+mONuIuGUlJatd21U0cg1U7KkGiJYkJqJPgc5Z1UXZf14u8ySjZCWoBftVQF8gW1OkFyFCDmu6lh213AZOqBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783037; c=relaxed/simple;
	bh=ht5HH0mfomIq3uREsaI8xOqR11plH2X4SgizQwxsrkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YXbVahy1wsZbzCpmw4EdjSL5XEb5xbmzZoqTG6a8xymsg268vOIqtqaQw9eR4MuM8l5fA0RI1qKbWtOcxPNuqlGlz99Rwxl8pi5f2jyDDgo601DgcIaYS22vmRdxr6zNS172x2g2FZeBCZ7dFL2gwBm47wPaDU41neJrC8GOm/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TefSdXvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TefSdXvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6390B1F00898;
	Wed, 30 Sep 2026 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783029;
	bh=jncb+/64acKnohiq5DqRiI/OI1Sc3/eZ/xK/SpWUPRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TefSdXvWoUFoUz+J8SnAMc7TXg18iExEh+DwtYzfD3dpWN1LeYXSf/OXKLeTJ2ELY
	 gbDQTnry8yEWXhUBXxy1UtFlvb8HltEvWnD0tQ3lm58mxPWqzHF9OHsUy5XCHXGo/R
	 8CvxHAzUXP66mAMYE8rubcPy74JaH+prf7cjdbwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/595] net/sched: pie: clamp psched_mtu in pie_drop_early
Date: Wed, 30 Sep 2026 17:22:26 +0200
Message-ID: <20260930152353.156119179@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 54370e44c002770ae61fc889f28f699e91616ffc ]

pie_drop_early() calls psched_mtu() with no clamp. With mtu=0x80000000
the bytemode divide silently zeroes the drop probability, disabling AQM.
Clamp to [1, 1<<20].

Conditions to recreate the bug:
  CONFIG_NET_SCH_PIE=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root pie
  tc qdisc change dev dummy0 root pie stab data 32768 size_log 15 cell_log 0

Fixes: d4b36210c2e6 ("net: pkt_sched: PIE AQM scheme")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.7
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 4d0f86c3ae703..e924de3508875 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -35,7 +35,7 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 {
 	u64 rnd;
 	u64 local_prob = vars->prob;
-	u32 mtu = psched_mtu(qdisc_dev(sch));
+	u32 mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 1, 1 << 20);
 
 	/* If there is still burst allowance left skip random early drop */
 	if (vars->burst_time > 0)
-- 
2.53.0



