Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E9C33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301142; cv=none; b=NlycIcxrfFwgHarDK/1EKwYTKYrwHGxK9LO+IpNc3S82zJaaLtz+TYJce66Sfchic7kOHpWZnfqeF5giKtXtdq40gUUWlNLcatJr+jjevjZ6fi8z+riveaV3qACoM1cMV24SgOWOzvYkbV2N6U0Mh6w7Ha75VOht4D/4u6a3ZK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301142; c=relaxed/simple;
	bh=W9Ht9061eXlsgXJAa/mgHZ9alCq4zRwr8EaSMiXPFq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4ApbEC0Wx0IAEIL/NX/4X72i4l2r8YVMj3dxnNaw1Ufbx2+i0ovsN1DZEoEU8iAi1eviRPw1bSdB/aSuvxiPS79LGhX2fhYwXiIIwdxrwghg2lhAlTOzePT2ThQdArFGxh/hfNnPzwY2K+ZTV1U8I7ETpBRtJt0fpY3Xx88L74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNgI97f4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNgI97f4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18387C116D0;
	Sat, 28 Feb 2026 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301142;
	bh=W9Ht9061eXlsgXJAa/mgHZ9alCq4zRwr8EaSMiXPFq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNgI97f4oL4cixTzaQHj6YFG0yvOK9BeWqowcnXksTEy32AHGkRWY9as0HBXy4xzu
	 YRD4RVCqkAixaTGUmTXjpx23wkdp/ymkgT/5FhWwnjF9xo3zuwBhZHa4ux1gJ2I161
	 aC82zWanbysxO8dWn9jOk1CvvzT8qj5bdOPgcIt2FE7MesXHLvypxqlXlEv4KJCwp6
	 YSxL6xdnJoGQxusgUgOdqhqc3Ccwnb9ZVbNuPW28pAEIUAqKTccU3Y2o2538jEANAR
	 wcmddy5iIUFfUcVqKNfm1xX/VawSSviHn7EIBfE/B90VzhnQtCEkp+c5yhhrl71OBM
	 2Y5TdC3hUqveg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnd Bergmann <arnd@arndb.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/752] scsi: buslogic: Reduce stack usage
Date: Sat, 28 Feb 2026 12:40:15 -0500
Message-ID: <20260228174750.1542406-304-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e17f0d4cc006265dd92129db4bf9da3a2e4a4f66 ]

Some randconfig builds run into excessive stack usage with gcc-14 or
higher, which use __attribute__((cold)) where earlier versions did not do
that:

drivers/scsi/BusLogic.c: In function 'blogic_init':
drivers/scsi/BusLogic.c:2398:1: error: the frame size of 1680 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

The problem is that a lot of code gets inlined into blogic_init() here. Two
functions stick out, but they are a bit different:

 - blogic_init_probeinfo_list() actually uses a few hundred bytes of kernel
   stack, which is a problem in combination with other functions that also
   do. Marking this one as noinline means that the stack slots get get
   reused between function calls

 - blogic_reportconfig() has a few large variables, but whenever it is not
   inlined into its caller, the compiler is actually smart enough to reuse
   stack slots for these automatically, so marking it as noinline saves
   most of the stack space by itself.

The combination of both of these should avoid the problem entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260203163321.2598593-1-arnd@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/BusLogic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index a86d780d1ba40..026c3e617cb1c 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -920,7 +920,8 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
   a particular probe order.
 */
 
-static void __init blogic_init_probeinfo_list(struct blogic_adapter *adapter)
+static noinline_for_stack void __init
+blogic_init_probeinfo_list(struct blogic_adapter *adapter)
 {
 	/*
 	   If a PCI BIOS is present, interrogate it for MultiMaster and
@@ -1690,7 +1691,8 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
   blogic_reportconfig reports the configuration of Host Adapter.
 */
 
-static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
+static noinline_for_stack bool __init
+blogic_reportconfig(struct blogic_adapter *adapter)
 {
 	unsigned short alltgt_mask = (1 << adapter->maxdev) - 1;
 	unsigned short sync_ok, fast_ok;
-- 
2.51.0

