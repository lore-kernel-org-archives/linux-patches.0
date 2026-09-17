Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1483370AFB;
	Thu, 17 Sep 2026 15:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658993; cv=none; b=HP5CftzT0/9fCuTQ8XlycqvWOqE4KfzWvreWyEVtKEKxAY7DAt5DuxbMa1SFPmogtYaChd90ANyjUWffm3SFFX8lmRdAs95ydBE1G59QRa9O/Cb/MAyCrVG5JeUnGzgvAB4mwVrXgUwiXpi2fez+UURBVu2D5JUdf1DexDbXf38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658993; c=relaxed/simple;
	bh=Iqi23Y8a80obOFjkmgrMgmT0H+eRqD0eQHkgbDf2yRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpBL0VmGMuP+90nRroVfnc6DA/bIa3A9G04d8IhSfNM4M/vudMWmko0yziTKyFOZMoXdLipWv9ma0D1JA/3G+ZL4NKc8mKLPBtOMPUJXfnPUyDZqIbuLgmhZ1gu7lkskFrLuIZ5YMAVGGsGw5X9DNV07KS0L0diSfTzN9ZszLMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVpCDQoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVpCDQoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD711F000FF;
	Thu, 17 Sep 2026 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658977;
	bh=WG/JbdEWWQfqVvEvcDWTel294rEwI9t9YBFcJKd1YHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVpCDQoEWhSwcHOT1Tls1QVSiRCoo6i09a06mOE4H09zA9xYSvBDFqHGKxDHO6FAK
	 6nStfff8nVYLmqirVLNSfS/CpXcH9Ly44+hiW5GBPdbw/ZkZZl0oHnoIZeLJ9JHoln
	 aFujB3ij4vF3fXuQCu4NJjUbVxGzXYgGnnSSV7aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 102/733] s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block
Date: Thu, 17 Sep 2026 16:06:50 +0100
Message-ID: <20260917151353.501880473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



