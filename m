Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BFF3B71AE;
	Thu, 17 Sep 2026 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665404; cv=none; b=etkO0jRvKwnGXbQ9y33q7ROuMIwk5crBklx2GZm2h6hGCCHyziMWAqlMxW4JHjDCZyb7zRBhLPFoVC2vOIyBeP97TRJ91Q0m72yq7Wr/EdLT4NpS/11yS2wX2jX+uxjrPJRhEP5/p4laWz8i+jnTAQDZlA0byp4fcjYbf59yZII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665404; c=relaxed/simple;
	bh=wchRTPRNod1kUmH0Y5gcwGcYAGItQXldtz/LcDFTJR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LD8OZE0qjKFudW8fTth6VqqwlyRYPCnFwOXTRC2LJE6d2Shl8rqfSEaKrVParoH9qeArhbIkb92jZt6pdGjqMggYdXbzhTAYlXUrIKTQs5f0JnMveN6rA+diVljCrPw+nITkkJuc4Bba4UHBcrNgRAlkypg/r7eTTJFYE2HDN8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEHuDTja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEHuDTja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81A61F000FF;
	Thu, 17 Sep 2026 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665403;
	bh=FivXf1tSjhPjWbxJk3Dwh7LPjgIsMdQe1LSKumL+vPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEHuDTjazwwKNE5B5iTUgSXN2jPhh1rF9sfJjkSxlgpADZZR13DQgLd95E57iTcML
	 NzbHqL7lpSL/cwYJK19ndxjXl7Ca81RY5D/da+apA5sNBj4OIVjUTUlUrZXwsosHO0
	 VzkZgUODHr9EbMfHQYazqpDQnM214YcoLoAecZ74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0654/1250] s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block
Date: Thu, 17 Sep 2026 16:07:29 +0100
Message-ID: <20260917151609.620884262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7024fc4137152..68fdd5616dfe1 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1929,7 +1929,8 @@ static struct shutdown_action __refdata dump_action = {
 static void dump_reipl_run(struct shutdown_trigger *trigger)
 {
 	struct lowcore *abs_lc;
-	unsigned int csum;
+	unsigned long ipib = 0;
+	unsigned int csum = 0;
 
 	/*
 	 * Set REIPL_CLEAR flag in os_info flags entry indicating
@@ -1945,9 +1946,12 @@ static void dump_reipl_run(struct shutdown_trigger *trigger)
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



