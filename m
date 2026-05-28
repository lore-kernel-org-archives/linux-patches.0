Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CEC318B96;
	Thu, 28 May 2026 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001485; cv=none; b=efhKRTRWzUG3vuVypSCPIyMXmraFnpgpBRFkd+QryA19BgcCzKG3O8INHDOAWmt22bLOHfQ5tLTT8HhRU9cd2UWScj6NMPeio74f8gVZJcQM64EqAkgSo0a0H7HLKD8Nstg4ByHQ2OVhm22D81xOHwtyXFmZ4FXkZuCCyfxxkCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001485; c=relaxed/simple;
	bh=IxDaWclae19SooHc2Q4mp8YAujS+x/ePM+r1M59vA9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzIf5HXJq9eeXkVZRHfr0xsyVTEnBCMP0GIB/oDJEkvJJJuae4X/LL5EGRV8mOBrCNJ57xUaIFz6rGZPcGWryCn4EUOyA8/cRMFCBMBwwNKe5RLPGx7gHQdnJ6bgL8YIlALoPLzrjpafQ1ZQOaqO9y+wKT8TyqxTFMafnwBonS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+y7u52N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+y7u52N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1E81F000E9;
	Thu, 28 May 2026 20:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001484;
	bh=0WaKUCih6A6gozKezBu5W3qLgZRccGW4V68sIsvdNkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+y7u52N4uTwAgh7HTWC783R0YW+RNh2jq28s7sT+MDxEHfj/U9AS5/ohsPYQFJiP
	 S5lLc4kZaA52bm6IKG2QYKI27D1ekXgQK7jTHbGeB/h1tK7BXAZ4F2qeuyqSao00QA
	 //8S/vfpKHZLEgckdhiXPZs1yGo3T5p0KuZnxu5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/186] net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot
Date: Thu, 28 May 2026 21:50:23 +0200
Message-ID: <20260528194932.812801762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 277740023def559a4a2ddc3e8e784ee37a0f16a9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0e9a3b8da6a63..6629fd61be06a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1378,7 +1378,8 @@ smc_v2_determine_accepted_chid(struct smc_clc_msg_accept_confirm *aclc,
 	int i;
 
 	for (i = 0; i < ini->ism_offered_cnt + 1; i++) {
-		if (ini->ism_chid[i] == ntohs(aclc->d1.chid)) {
+		if (ini->ism_dev[i] &&
+		    ini->ism_chid[i] == ntohs(aclc->d1.chid)) {
 			ini->ism_selected = i;
 			return 0;
 		}
-- 
2.53.0



