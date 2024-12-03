Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1581F7063;
	Tue,  3 Dec 2024 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241465; cv=none; b=A4cijUU7hbvk5cT7mQvIfdMwu7AaXrjOpsHYf5MfWnQ2TWLWu7Cc21JanMeUtEP3A5BQbCTc6GVG74/4GKpET2nBcESiyQLID5/VcDEHUd+AgTvt/J6i4pBVX3yqDS4Iqk+5iOzCzjWohGb9M1NSCJ8FlFIrx1nre+bBwrKf1Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241465; c=relaxed/simple;
	bh=pzFCCkGSp9VjrLrsVnCdwhBOVUPDC41nJAot61r6keY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4JvQF+caEyxs5FoiUjPY83dwTcxzWLs3YfcCFqDp7MVUn2fnaa66w1j9k3LyOAlIJGPLZLutiDkZAnI9SAbLYbJ2vJ5uuBFcV+FOswmHRVnAhiZqj2/smxo0FgroCkZrztmZjlrJRRtw4gkpur1HSczTauWEKq1QBRW6ij6/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CJfV9ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CJfV9ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB89C4CECF;
	Tue,  3 Dec 2024 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241465;
	bh=pzFCCkGSp9VjrLrsVnCdwhBOVUPDC41nJAot61r6keY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CJfV9psCPVAOta2cU5RlyGZiOlzDbrqBGQRvUSgro8EgXbCPwQPEssq4kFT4+kyK
	 r69cJwiAEEcpkdi0pv7g6URt+YbScusLycAIsQN8RDhCp5UTQrgP75vUoheKJzSGhE
	 uOQIjO9w8kEQbRbyaRS+S3ZCyc/xNr7zq1myMBdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/826] fadump: reserve param area if below boot_mem_top
Date: Tue,  3 Dec 2024 15:42:34 +0100
Message-ID: <20241203144800.419912243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit fb90dca828b6070709093934c6dec56489a2d91d ]

The param area is a memory region where the kernel places additional
command-line arguments for fadump kernel. Currently, the param memory
area is reserved in fadump kernel if it is above boot_mem_top. However,
it should be reserved if it is below boot_mem_top because the fadump
kernel already reserves memory from boot_mem_top to the end of DRAM.

Currently, there is no impact from not reserving param memory if it is
below boot_mem_top, as it is not used after the early boot phase of the
fadump kernel. However, if this changes in the future, it could lead to
issues in the fadump kernel.

Fixes: 3416c9daa6b1 ("powerpc/fadump: pass additional parameters when fadump is active")
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241107055817.489795-2-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 6ab7934d719f7..4641de75f7fc1 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -136,7 +136,7 @@ void __init fadump_append_bootargs(void)
 	if (!fw_dump.dump_active || !fw_dump.param_area_supported || !fw_dump.param_area)
 		return;
 
-	if (fw_dump.param_area >= fw_dump.boot_mem_top) {
+	if (fw_dump.param_area < fw_dump.boot_mem_top) {
 		if (memblock_reserve(fw_dump.param_area, COMMAND_LINE_SIZE)) {
 			pr_warn("WARNING: Can't use additional parameters area!\n");
 			fw_dump.param_area = 0;
-- 
2.43.0



