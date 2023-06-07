Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A55C10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD9BC433D2;
	Wed,  7 Jun 2023 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169611;
	bh=fpqoULnVRtw5Y0dDZwpIfs4sYiENDoFspuX+MK4wXMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHiIhjm2MDdgAd4BCQpeS/h2wCBCfbpUil/CiUto9RiOX+VHv3YtM6cqNF/z8a37E
	 maFxijnYfj5V2KcqHRjEF0bdRZi3aBC4VMG/RvrNjFG0Q02FRZZ61HT3NAdnFDuPh1
	 a+n7DKXN04nQf8cvzL1dLtOn4wUV0r0nmyGMR8eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 147/286] s390/ipl: fix IPIB virtual vs physical address confusion
Date: Wed,  7 Jun 2023 22:14:06 +0200
Message-ID: <20230607200927.899845956@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 2facd5d3980f3a26c04fe6ec8689a1d019a5812c ]

The pointer to IPL Parameter Information Block is stored
in the absolute lowcore for later use by dump tools. That
pointer is a virtual address, though it should be physical
instead.

Note, this does not fix a real issue, since virtual and
physical addresses are currently the same.

Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 5f0f5c86963a9..e43ee9becbbb9 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1936,14 +1936,13 @@ static struct shutdown_action __refdata dump_action = {
 
 static void dump_reipl_run(struct shutdown_trigger *trigger)
 {
-	unsigned long ipib = (unsigned long) reipl_block_actual;
 	struct lowcore *abs_lc;
 	unsigned int csum;
 
 	csum = (__force unsigned int)
 	       csum_partial(reipl_block_actual, reipl_block_actual->hdr.len, 0);
 	abs_lc = get_abs_lowcore();
-	abs_lc->ipib = ipib;
+	abs_lc->ipib = __pa(reipl_block_actual);
 	abs_lc->ipib_checksum = csum;
 	put_abs_lowcore(abs_lc);
 	dump_run(trigger);
-- 
2.39.2



