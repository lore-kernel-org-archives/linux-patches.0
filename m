Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A393720316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDSx/+YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE2EC433C7;
	Mon,  6 Nov 2023 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276612;
	bh=pEN+eGy/tY768i9FK42u04Bmhvp+Jt2ONiji+zvKoEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDSx/+YE2PMOgnj8VhwGgf+XRaxd7oCpnMwjieAI5o+f0NWTzwpLNaimBPBXnr5kP
	 HIp22XZDq7Pv6u1eVyJtXwKy3NrxeLCaSXBz09R+iVl5d89cOYxXgVto507imTAo8G
	 JYtjkfOPacPmbJWC19C2iYt3Xu5LfKNLX981fXNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 38/88] s390/kasan: handle DCSS mapping in memory holes
Date: Mon,  6 Nov 2023 14:03:32 +0100
Message-ID: <20231106130307.220283424@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 327899674eef18f96644be87aa5510b7523fe4f6 ]

When physical memory is defined under z/VM using DEF STOR CONFIG, there
may be memory holes that are not hotpluggable memory. In such cases,
DCSS mapping could be placed in one of these memory holes. Subsequently,
attempting memory access to such DCSS mapping would result in a kasan
failure because there is no shadow memory mapping for it.

To maintain consistency with cases where DCSS mapping is positioned after
the kernel identity mapping, which is then covered by kasan zero shadow
mapping, handle the scenario above by populating zero shadow mapping
for memory holes where DCSS mapping could potentially be placed.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/vmem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
index c67f59db7a512..f66d642251fe8 100644
--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -57,6 +57,7 @@ static void kasan_populate_shadow(void)
 	pmd_t pmd_z = __pmd(__pa(kasan_early_shadow_pte) | _SEGMENT_ENTRY);
 	pud_t pud_z = __pud(__pa(kasan_early_shadow_pmd) | _REGION3_ENTRY);
 	p4d_t p4d_z = __p4d(__pa(kasan_early_shadow_pud) | _REGION2_ENTRY);
+	unsigned long memgap_start = 0;
 	unsigned long untracked_end;
 	unsigned long start, end;
 	int i;
@@ -101,8 +102,12 @@ static void kasan_populate_shadow(void)
 	 * +- shadow end ----+---------+- shadow end ---+
 	 */
 
-	for_each_physmem_usable_range(i, &start, &end)
+	for_each_physmem_usable_range(i, &start, &end) {
 		kasan_populate(start, end, POPULATE_KASAN_MAP_SHADOW);
+		if (memgap_start && physmem_info.info_source == MEM_DETECT_DIAG260)
+			kasan_populate(memgap_start, start, POPULATE_KASAN_ZERO_SHADOW);
+		memgap_start = end;
+	}
 	if (IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
 		untracked_end = VMALLOC_START;
 		/* shallowly populate kasan shadow for vmalloc and modules */
-- 
2.42.0



