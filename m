Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3BD3C1988;
	Thu, 15 Jan 2026 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499297; cv=none; b=ulvbYmPpn6ZIDolIAfkEYRShFW1SSd7W3Opjzc3rwMLI6INkKSCW4UIGRQkADdleI3oHxU21M1AOoF2RPD6Pqqh7NBFA4dkiNrji1bZMRR4G9Gt6OYKdbYSekUMbhC4/dqHfnaBe9+uw3GPGkGPrj1uNvQ6PpjZbJWuXzuuzaKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499297; c=relaxed/simple;
	bh=mCo3k/hLTp5ZzK8bMKtmk7TO61NjThBSQsvDPGNkriI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pvrb9pOgpGSH0jRYApprDn0HrHsgMxTYbaglNRPObzJFUmHndm7Ky7+vpSEoo7yLiHvAdh95WcS1Yi1fMIHFDiTOSOj7M/RDeLJgdkWEfvS0T+HvWAjcgNgFbV9L6U85MHWSb40cLqIG8+yVaCLxY9X+C9tmtpYj4I+bsjGok2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7zq85Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7zq85Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2ADC16AAE;
	Thu, 15 Jan 2026 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499297;
	bh=mCo3k/hLTp5ZzK8bMKtmk7TO61NjThBSQsvDPGNkriI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7zq85Nl8A0xF4Y/wqy46UoTGdlvXpN9n3wVb/KbiEKWgpAqMszrrD6pzJue9OfqL
	 ytZWlHzLIYG9JfBeLxQWRxMxQ3QwYtv5sqBFuSKml2vnqPY0yy6rMxDeWdcKe5/w2u
	 xB2fgAdv1HLph80AHuIFTb/QmzdabNAi6qciP0XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/451] net/sched: ets: Remove drr class from the active list if it changes to strict
Date: Thu, 15 Jan 2026 17:46:19 +0100
Message-ID: <20260115164237.344753744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit b1e125ae425aba9b45252e933ca8df52a843ec70 ]

Whenever a user issues an ets qdisc change command, transforming a
drr class into a strict one, the ets code isn't checking whether that
class was in the active list and removing it. This means that, if a
user changes a strict class (which was in the active list) back to a drr
one, that class will be added twice to the active list [1].

Doing so with the following commands:

tc qdisc add dev lo root handle 1: ets bands 2 strict 1
tc qdisc add dev lo parent 1:2 handle 20: \
    tbf rate 8bit burst 100b latency 1s
tc filter add dev lo parent 1: basic classid 1:2
ping -c1 -W0.01 -s 56 127.0.0.1
tc qdisc change dev lo root handle 1: ets bands 2 strict 2
tc qdisc change dev lo root handle 1: ets bands 2 strict 1
ping -c1 -W0.01 -s 56 127.0.0.1

Will trigger the following splat with list debug turned on:

[   59.279014][  T365] ------------[ cut here ]------------
[   59.279452][  T365] list_add double add: new=ffff88801d60e350, prev=ffff88801d60e350, next=ffff88801d60e2c0.
[   59.280153][  T365] WARNING: CPU: 3 PID: 365 at lib/list_debug.c:35 __list_add_valid_or_report+0x17f/0x220
[   59.280860][  T365] Modules linked in:
[   59.281165][  T365] CPU: 3 UID: 0 PID: 365 Comm: tc Not tainted 6.18.0-rc7-00105-g7e9f13163c13-dirty #239 PREEMPT(voluntary)
[   59.281977][  T365] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   59.282391][  T365] RIP: 0010:__list_add_valid_or_report+0x17f/0x220
[   59.282842][  T365] Code: 89 c6 e8 d4 b7 0d ff 90 0f 0b 90 90 31 c0 e9 31 ff ff ff 90 48 c7 c7 e0 a0 22 9f 48 89 f2 48 89 c1 4c 89 c6 e8 b2 b7 0d ff 90 <0f> 0b 90 90 31 c0 e9 0f ff ff ff 48 89 f7 48 89 44 24 10 4c 89 44
...
[   59.288812][  T365] Call Trace:
[   59.289056][  T365]  <TASK>
[   59.289224][  T365]  ? srso_alias_return_thunk+0x5/0xfbef5
[   59.289546][  T365]  ets_qdisc_change+0xd2b/0x1e80
[   59.289891][  T365]  ? __lock_acquire+0x7e7/0x1be0
[   59.290223][  T365]  ? __pfx_ets_qdisc_change+0x10/0x10
[   59.290546][  T365]  ? srso_alias_return_thunk+0x5/0xfbef5
[   59.290898][  T365]  ? __mutex_trylock_common+0xda/0x240
[   59.291228][  T365]  ? __pfx___mutex_trylock_common+0x10/0x10
[   59.291655][  T365]  ? srso_alias_return_thunk+0x5/0xfbef5
[   59.291993][  T365]  ? srso_alias_return_thunk+0x5/0xfbef5
[   59.292313][  T365]  ? trace_contention_end+0xc8/0x110
[   59.292656][  T365]  ? srso_alias_return_thunk+0x5/0xfbef5
[   59.293022][  T365]  ? srso_alias_return_thunk+0x5/0xfbef5
[   59.293351][  T365]  tc_modify_qdisc+0x63a/0x1cf0

Fix this by always checking and removing an ets class from the active list
when changing it to strict.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/net/sched/sch_ets.c?id=ce052b9402e461a9aded599f5b47e76bc727f7de#n663

Fixes: cd9b50adc6bb9 ("net/sched: ets: fix crash when flipping from 'strict' to 'quantum'")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20251208190125.1868423-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index ad5d9b27670ca..c939937b2b81d 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -677,6 +677,10 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 			q->classes[i].deficit = quanta[i];
 		}
 	}
+	for (i = q->nstrict; i < nstrict; i++) {
+		if (cl_is_active(&q->classes[i]))
+			list_del_init(&q->classes[i].alist);
+	}
 	WRITE_ONCE(q->nstrict, nstrict);
 	memcpy(q->prio2band, priomap, sizeof(priomap));
 
-- 
2.51.0



