Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD7E18132F;
	Sun,  1 Sep 2024 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207678; cv=none; b=ObQhGPHVcBhw+B2EKbdNTu8pUMnHd1womFr0TUTLC+Vciepqw8kNEhdTjNmNyc7ieTxANZ4ZKMLhNcelilqkMWkNbhjUrxzynGuocdAM6U9GRD/OWg+MR8W6Da2k46R4k6ZJpwM+Uclg5RT5SDpxb9GRrMhWJn0CGdkPgS/GZng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207678; c=relaxed/simple;
	bh=EJkqY60li/DlqWyMwGh+ExfPkQTrX1Jo1WTk+nWrLbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVBlSk3JTjUh1UlKA6JUREOfPrjYgONUuCQnqebvuTiVCAqEU3/JwzYkWYyUPZieIjwzf3fDqNuLmwFsnAKfbSzTTu8MpgqTSCc7mj/dxInffuIGEcieZnDoOOjDMSzK2v8i+G2e13RR+ukL+xpYiGzLbBzqjnXUTN6Dy8kq0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hw9b+RHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw9b+RHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E118AC4CEC3;
	Sun,  1 Sep 2024 16:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207678;
	bh=EJkqY60li/DlqWyMwGh+ExfPkQTrX1Jo1WTk+nWrLbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hw9b+RHOseC6cIKM6MiUgFUvr72KnK8hlOce9vV+n5B0NzizRXCxK9oU2JJghJvf3
	 rPkDoQyeZyPD9MubhgsYQDqAITySDVVMdivp9MOQQ/eMdPhk0JeWAPMQbJQfMAZlQu
	 qBfG5Uo1kz4Bf/tiNiCJiMProIxnhu/6LoQ2GYJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/98] openrisc: Call setup_memory() earlier in the init sequence
Date: Sun,  1 Sep 2024 18:16:14 +0200
Message-ID: <20240901160805.360978367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oreoluwa Babatunde <quic_obabatun@quicinc.com>

[ Upstream commit 7b432bf376c9c198a7ff48f1ed14a14c0ffbe1fe ]

The unflatten_and_copy_device_tree() function contains a call to
memblock_alloc(). This means that memblock is allocating memory before
any of the reserved memory regions are set aside in the setup_memory()
function which calls early_init_fdt_scan_reserved_mem(). Therefore,
there is a possibility for memblock to allocate from any of the
reserved memory regions.

Hence, move the call to setup_memory() to be earlier in the init
sequence so that the reserved memory regions are set aside before any
allocations are done using memblock.

Signed-off-by: Oreoluwa Babatunde <quic_obabatun@quicinc.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index f3a7375ac3cd9..f306816c98cb2 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -287,6 +287,9 @@ void calibrate_delay(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	/* setup memblock allocator */
+	setup_memory();
+
 	unflatten_and_copy_device_tree();
 
 	setup_cpuinfo();
@@ -311,9 +314,6 @@ void __init setup_arch(char **cmdline_p)
 	initrd_below_start_ok = 1;
 #endif
 
-	/* setup memblock allocator */
-	setup_memory();
-
 	/* paging_init() sets up the MMU and marks all pages as reserved */
 	paging_init();
 
-- 
2.43.0



