Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FD12E7379;
	Thu, 28 May 2026 20:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000035; cv=none; b=mp0p25diQO/WIQtSlokAdb53DYrcOQfmWvxZv1iuT8B26b/hgO55wXHW3aXzcEjPQmh0vv/FHf/Bt6FKxf/aGyvUTrIQO83hkFJrZ1GEn1B0gcAyCAVVodSyy8vgLuG8PnKEbui78Xsm+HxGFghB+0nfAWVXMazaWbluTYz8IcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000035; c=relaxed/simple;
	bh=JJvOLt47s883xP3jKJS4Pkf9sHPWvgl+QvZpn9ljvmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P38V8hJ2tgJ3RdyceP4GAq2614/ERB+61haLGXR03vAaHbJEmejiaAtJqGSF4y6NmnlSxnUCsdJ/3xm5HNgLgvKI+Cn33IEAWMxjkbSV6pA+Ku1BjNn2nTMcCtNBoFrEr1EEl+qU5mU3tWQxfF3R02nxXmDFybKg5rvenr/mIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVUR8yXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVUR8yXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36481F000E9;
	Thu, 28 May 2026 20:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000034;
	bh=NDUIFfJ2dlj9L7Eq7T72zx/QpquKXMtAeYpHUvpjv3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVUR8yXBWmMdHX5j7fvPO8uC9zh8d7f33tMAq/yzYxD3Rxq/5cGHv4muUBn1nmwJS
	 6HPpylvsezkq/d1VWe/fCtVzu1x1hQ6xZrCnI155ywEnK/0sBn29CRVu9pFbn0VTMl
	 RXDiBbwH0zswPj5fRJ6es1IZedT8Ici2KC9OgICs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/377] net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot
Date: Thu, 28 May 2026 21:48:38 +0200
Message-ID: <20260528194646.463967140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6421c2e1c84de..5915fcdef743d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1400,7 +1400,8 @@ smc_v2_determine_accepted_chid(struct smc_clc_msg_accept_confirm *aclc,
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



