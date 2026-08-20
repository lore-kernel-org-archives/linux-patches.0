Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140FB374E5A;
	Thu, 20 Aug 2026 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243296; cv=none; b=H1fiYZCoFaGcld85wtls6VxreGhoSWKdKSgDfDDb/HxxPVgtc8+sCB1st74t7LqoHKyxne/T1PnyJuffgvwwJKo4PHqkUeSLS+loZosANImN5Tbj+Dm2eLDf3zImxfaofFZgen81QmEQ2pq6U6B5ZLrqbAh06J7YfLTamkjRjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243296; c=relaxed/simple;
	bh=ORq6KOImIuzwgLdpmiNIDT9tjvFRK/sqdKFMjxT2tfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXgh3JvgYtW442sis9mrhjO3kqjWl16r/x/0LzQdMoF2Ytq57ZGClfFCoocCyk7/bJKoPprZj17RVPxXqOzGGMMP/Ds/cqLj8O0JG7jgzndU0lhL4/OACF56Qdis01Caengf+XX9nI/28KaD0Y9OlVGhQR6mZRGwXewMbaO2qlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeML8VUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeML8VUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375221F000E9;
	Thu, 20 Aug 2026 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243294;
	bh=G2extqhJ7NA6HxsxMte7PCAQNO+DNQg/L9qjl3/KiLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeML8VUt1l1YWFBg42YJkPrGTXW9wCxhsc4LQo8Bma75+mqwTUzoUyXv2rY1DyPdH
	 +zTvWZK3L4+d2d8gcYYp2DsKr3Y8TmB+TD/Sqh90+o0IbhhgUss/1sHy8rJTjaf9hy
	 hsYR1DYvmywps/bM41xNeYT2IdghzPJw7Y1mJEu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrey Troshin <drtrosh@yandex-team.ru>
Subject: [PATCH 5.15 046/272] net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot
Date: Thu, 20 Aug 2026 16:53:50 +0200
Message-ID: <20260820145232.604735234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit 277740023def559a4a2ddc3e8e784ee37a0f16a9 upstream.

On the SMC-D client, slot 0 of ini->ism_dev[]/ini->ism_chid[] is
reserved for an SMC-Dv1 device. smc_find_ism_v2_device_clnt()
populates V2 entries starting at index 1, so when no V1 device is
selected slot 0 is left in its kzalloc()'ed state with ism_dev[0] ==
NULL and ism_chid[0] == 0.

smc_v2_determine_accepted_chid() then matches the peer's CHID against
the array starting from index 0 using the CHID alone. A malicious
peer replying to a SMC-Dv2-only proposal with d1.chid == 0 matches
the empty slot, ini->ism_selected becomes 0, and the subsequent
ism_dev[0]->lgr_lock dereference in smc_conn_create() faults at
offsetof(struct smcd_dev, lgr_lock) == 0x68:

  BUG: KASAN: null-ptr-deref in _raw_spin_lock_bh+0x79/0xe0
  Write of size 4 at addr 0000000000000068 by task exploit/144
  Call Trace:
   _raw_spin_lock_bh
   smc_conn_create (net/smc/smc_core.c:1997)
   __smc_connect (net/smc/af_smc.c:1447)
   smc_connect (net/smc/af_smc.c:1720)
   __sys_connect
   __x64_sys_connect
   do_syscall_64

Require ism_dev[i] to be non-NULL before accepting a CHID match.

Fixes: a7c9c5f4af7f ("net/smc: CLC accept / confirm V2")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260511062138.2839584-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1107,7 +1107,8 @@ smc_v2_determine_accepted_chid(struct sm
 	int i;
 
 	for (i = 0; i < ini->ism_offered_cnt + 1; i++) {
-		if (ini->ism_chid[i] == ntohs(aclc->chid)) {
+		if (ini->ism_dev[i] &&
+			ini->ism_chid[i] == ntohs(aclc->chid)) {
 			ini->ism_selected = i;
 			return 0;
 		}


