Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78743502A8;
	Wed, 30 Sep 2026 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795015; cv=none; b=sT6YLMGaO6W1BostJ9stHg6rzV61LObl70ZMESRuzLc027DYAKZvbSjGiqWQUuhb++0lB3OlzbYZ0GnlnZVC/eYMorxhbgBAbcK53c9y279SGU7GpFnc1Ya+tVicQhcI07bMvRdtSGyRAUeYeT4dT5q/cl+7XEkxz7KBRMEalx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795015; c=relaxed/simple;
	bh=VI6mFEVMSg8EziN7UFKLJMqZGajAoHfLtlWBo0mTMR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGIDa5I9WGU6ARHTfK61MHcan57ANV+s2dUGlfhtB5iMhaOkibS7GswHR/rGgOUTUYIahdKPlrOAYyPgA3s5Imq8uJn6eX4D1wOU9wVE/yw0Upus1V7iEqRsUbDDunMvjHwyU+v68KpJI0PQdv3nGDOtP4M2+OmQyrlQS+zPmnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CALiGEfu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CALiGEfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2211F000FF;
	Wed, 30 Sep 2026 19:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795014;
	bh=O/ZlB+vO1B6gjOW/nRhLBLbXNKX+ZvS0acQ7NjQeY+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CALiGEfu3mO4BgdfGQoWYleEG/uzX2CYwV+NN3YnGJ207X7nNovfisgAt/zx2FOFw
	 Tgh2OvisFqu3s9lkvWMNL39P+ltSODuRQoT7AQSxWd0Tkp5pFdNKMGpncf6xp3CoVc
	 SxZ+0WrStxkQfC91tFazNDkzdQWJvpd4INCVajJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0411/1193] s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block
Date: Wed, 30 Sep 2026 17:18:15 +0200
Message-ID: <20260930152443.331747836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 806a32cb22a7b..32c9d33c9d721 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1951,7 +1951,8 @@ static struct shutdown_action __refdata dump_action = {
 static void dump_reipl_run(struct shutdown_trigger *trigger)
 {
 	struct lowcore *abs_lc;
-	unsigned int csum;
+	unsigned long ipib = 0;
+	unsigned int csum = 0;
 
 	/*
 	 * Set REIPL_CLEAR flag in os_info flags entry indicating
@@ -1967,9 +1968,12 @@ static void dump_reipl_run(struct shutdown_trigger *trigger)
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



