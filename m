Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6A04E01E3;
	Thu, 17 Sep 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668806; cv=none; b=uAphawUPFK75dkNgbpjtTK2fHsGMMywGtwmKPv2tQjSBzLdhrQlbWo7vpuPaf2eaWaOYqjfE9smZWSlIr6oHbC+jBI9+uKo7y+aLwZoh//RSZXVHQZ2r6BkxIRI3FNjNQqMPnRkfYF3sVid31Drbfhaav/kS2x4tgoQ4VdoTY6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668806; c=relaxed/simple;
	bh=OEtnHRKYCkrhIvRZIAjke5iTwiebL38Cc9IOjylklyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LniocbhGf9CBc0T1mFfFo7gbjlGH12A6Yg1GOd1XiKDOm6yZ7bBMoLS1hDgewWyhvNPkl1mJiePQ613vJ4J4A64iC6/Zo5XzCdd8niRUz3j7BMmlW1KPlwtf9EywrrZPB/BeXwVKyxLFAP9yD52ZX++EsW9mTSBhZzFmH3aD/ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlqM1Ufk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlqM1Ufk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91A31F000FF;
	Thu, 17 Sep 2026 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668803;
	bh=RckreDvoCywrMmfgpqs/Im18ifMFyhBVLSM/3N2tExc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlqM1UfkJmVfeTjBPcSQrVrMtuWVJYjggC9PZfVnXTmOqabHu0ikUtcVLMsEe4Yqj
	 Ua/ErXYrCT2IfeGCh2WcfwE/uTsFidUpZVaa+T6XsvVB+I3A1Ef3rmZZ4LcrwGj9W7
	 myFaoG+Y5HirrbUAtydFEciGSPq1Difj+p31pm8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0545/1102] s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block
Date: Thu, 17 Sep 2026 16:08:08 +0100
Message-ID: <20260917151553.511915801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 37f61b71cbc0caefc01022a19ee56fc2510e2e6e ]

Unlike kdump, which passes the re-IPL parameter block through os_info,
the stand-alone dump passes it through the IPL parm block address and
checksum in lowcore.

Some IPL types, like HMC FTP boot or QEMU direct kernel boot, might not
provide an IPL parameter block. In this case reipl_type_init() selects
IPL_TYPE_UNKNOWN and reipl_block_actual remains NULL. Nevertheless,
dump_reipl_run() unconditionally dereferences it when preparing the
lowcore fields. This may happen to work by chance when address zero
contains readable lowcore data. A zero IPL parameter block address is
then stored in lowcore, causing the stand-alone dumper to enter disabled
wait after completing the dump.

Explicitly store a zero IPL parameter block address and checksum when no
re-IPL parameter block is available. This does not change the behavior:
the stand-alone dumper completes the dump and halts, while valid re-IPL
parameter blocks continue to be handled as before.

Fixes: 099b76513992 ("[S390] Automatic IPL after dump")
Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index ae363fbe83fae..cc238d10df7a7 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1910,7 +1910,8 @@ static struct shutdown_action __refdata dump_action = {
 static void dump_reipl_run(struct shutdown_trigger *trigger)
 {
 	struct lowcore *abs_lc;
-	unsigned int csum;
+	unsigned long ipib = 0;
+	unsigned int csum = 0;
 
 	/*
 	 * Set REIPL_CLEAR flag in os_info flags entry indicating
@@ -1926,9 +1927,12 @@ static void dump_reipl_run(struct shutdown_trigger *trigger)
 	    reipl_type == IPL_TYPE_UNKNOWN)
 		os_info_flags |= OS_INFO_FLAG_REIPL_CLEAR;
 	os_info_entry_add_data(OS_INFO_FLAGS_ENTRY, &os_info_flags, sizeof(os_info_flags));
-	csum = (__force unsigned int)cksm(reipl_block_actual, reipl_block_actual->hdr.len, 0);
+	if (reipl_block_actual) {
+		ipib = __pa(reipl_block_actual);
+		csum = (__force unsigned int)cksm(reipl_block_actual, reipl_block_actual->hdr.len, 0);
+	}
 	abs_lc = get_abs_lowcore();
-	abs_lc->ipib = __pa(reipl_block_actual);
+	abs_lc->ipib = ipib;
 	abs_lc->ipib_checksum = csum;
 	put_abs_lowcore(abs_lc);
 	dump_run(trigger);
-- 
2.53.0



