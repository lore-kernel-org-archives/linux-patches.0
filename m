Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E7DBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255FFC433D2;
	Tue,  7 Mar 2023 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213720;
	bh=LU+1oG37GVp9ieO4whK8pU3+qJA8YQyavvKZccwQgxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPD+YR6ZC3b9hDIl5QDPaGfSAPXyYDumfICXFYtyVtK2nv5fUBC1Pc72+p5N3dWnJ
	 ik7IqTMoWRhXtws0CnN7t7MRVeS3tjWeBUTN86Zl29TwXfSD1JY6vd4sEBKVPml6yd
	 /nB5YVu8B46xzRZwSU3aQoKHR0+ClNM8Ro0C8xU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 570/885] s390/mm,ptdump: avoid Kasan vs Memcpy Real markers swapping
Date: Tue,  7 Mar 2023 17:58:24 +0100
Message-Id: <20230307170027.193267873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 05178996e1a77e2a4664536e6d101a086a905034 ]

---[ Real Memory Copy Area Start ]---
0x001bfffffffff000-0x001c000000000000         4K PTE I
---[ Kasan Shadow Start ]---
---[ Real Memory Copy Area End ]---
0x001c000000000000-0x001c000200000000         8G PMD RW NX
...
---[ Kasan Shadow End ]---

ptdump does a stable sort of markers. Move kasan markers after
memcpy real to avoid swapping.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/dump_pagetables.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
index 9953819d79596..ba5f802688781 100644
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -33,10 +33,6 @@ enum address_markers_idx {
 #endif
 	IDENTITY_AFTER_NR,
 	IDENTITY_AFTER_END_NR,
-#ifdef CONFIG_KASAN
-	KASAN_SHADOW_START_NR,
-	KASAN_SHADOW_END_NR,
-#endif
 	VMEMMAP_NR,
 	VMEMMAP_END_NR,
 	VMALLOC_NR,
@@ -47,6 +43,10 @@ enum address_markers_idx {
 	ABS_LOWCORE_END_NR,
 	MEMCPY_REAL_NR,
 	MEMCPY_REAL_END_NR,
+#ifdef CONFIG_KASAN
+	KASAN_SHADOW_START_NR,
+	KASAN_SHADOW_END_NR,
+#endif
 };
 
 static struct addr_marker address_markers[] = {
@@ -62,10 +62,6 @@ static struct addr_marker address_markers[] = {
 #endif
 	[IDENTITY_AFTER_NR]	= {(unsigned long)_end, "Identity Mapping Start"},
 	[IDENTITY_AFTER_END_NR]	= {0, "Identity Mapping End"},
-#ifdef CONFIG_KASAN
-	[KASAN_SHADOW_START_NR]	= {KASAN_SHADOW_START, "Kasan Shadow Start"},
-	[KASAN_SHADOW_END_NR]	= {KASAN_SHADOW_END, "Kasan Shadow End"},
-#endif
 	[VMEMMAP_NR]		= {0, "vmemmap Area Start"},
 	[VMEMMAP_END_NR]	= {0, "vmemmap Area End"},
 	[VMALLOC_NR]		= {0, "vmalloc Area Start"},
@@ -76,6 +72,10 @@ static struct addr_marker address_markers[] = {
 	[ABS_LOWCORE_END_NR]	= {0, "Lowcore Area End"},
 	[MEMCPY_REAL_NR]	= {0, "Real Memory Copy Area Start"},
 	[MEMCPY_REAL_END_NR]	= {0, "Real Memory Copy Area End"},
+#ifdef CONFIG_KASAN
+	[KASAN_SHADOW_START_NR]	= {KASAN_SHADOW_START, "Kasan Shadow Start"},
+	[KASAN_SHADOW_END_NR]	= {KASAN_SHADOW_END, "Kasan Shadow End"},
+#endif
 	{ -1, NULL }
 };
 
-- 
2.39.2



