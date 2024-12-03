Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B6A1F75A4;
	Tue,  3 Dec 2024 15:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239025; cv=none; b=JOEit6FZ1KHUSbPtw0jpZ4uslwkSVqmYZogmUr+QZE92vPGWrJtkwpB9hPfi+h/wU0igFB9PoiIVaJj7qM3Z45JPPsAgeCotZBN96G6gDFJ+WxLPD2BYNbZSttVvUt3BOA51AFNiVMCNeZi5j5XjJEwUCkw9EjLhqtj1paLykx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239025; c=relaxed/simple;
	bh=zBhV5iuIC/VN4d51PVBOm/2db34LhgtbwjF8e7S2Qp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvFJmuowRvOBExfKZbP+CWp2tj/SXG/Jf4ySaDlw5ekXb2aAfNnypT6I2H5qVr/fNvMkUXRYNbsbiTHDJLjJhzr4pIz3LLDldmbk13hOQxu8M14cxh4a9F4VLdeh8wLFgn5nPkM7SJPxxXPBGHFRt338IwBrq5SajYYs4Sf4IPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka1jOmpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka1jOmpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A97C4CECF;
	Tue,  3 Dec 2024 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239025;
	bh=zBhV5iuIC/VN4d51PVBOm/2db34LhgtbwjF8e7S2Qp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka1jOmpAFiRWF5am06vaVn6npMyVcgow9fFrYz2ZBQpe7swWwRwAgHuGDVMEczxR4
	 k1vLqn4Pn2o0+YxlYPK9ub+3bNVpcoRDqqMIbQIguo/cj9bVlTQyX4KhhLYG3QDzQ9
	 g8/kUW05DWx9Q5JIWFQri+RWZ9aQuf1fca4MDp4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 447/817] fadump: reserve param area if below boot_mem_top
Date: Tue,  3 Dec 2024 15:40:19 +0100
Message-ID: <20241203144013.327213237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



