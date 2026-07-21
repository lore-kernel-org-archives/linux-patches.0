Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA76322DB7;
	Tue, 21 Jul 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653426; cv=none; b=MoylK0ytL7w4fOL8dzkgIzD0cEXtKwoevYGCJhRkNea21qIRYu+btjBem/Gv0XCEmc1J7SpZrRfTM4OzX2qr/Atuu++pn04ilry/YH8v56WHtFyiys9q0zqX+LrhVcRcRZUcKD8Wyf9c1qcr4QRugkeXwvKCoNabH5SEJr3phaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653426; c=relaxed/simple;
	bh=nk5PG6Det1hQcj20z1Fv2Bku9H9wMNpsk7kk0bsY/dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXH1Pd+SL7UyHKVMY9fpFOEIG4YKAc5Ofgnk42R+3CzfxAPPtLKUeX/jWMFMjfzCGHHLn71wmkp9LtzKRVnxiLLEfrxk8Omf2d4Pi6W/tJDEbYCBC7Gq8kxlL0h5TFK7pIp3d7jKDax/io4V2i1ESWPb4c3BYBlCiHKj9KaKA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aO1PFKoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aO1PFKoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB1E1F000E9;
	Tue, 21 Jul 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653425;
	bh=lFSpZ1a6PWol5UCZqRvSp/KL2x/8FXqcWwzl72l2EOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aO1PFKoLFNNp6ZP70oyp9ZvHRDYD7fdpcJk/A+h0+miAyQKG9q8o01CVHpjj3x4/H
	 oqKRlQemhkY4XinX4qllJDc5kz5oDEUvCSrhJfKK5QOERl0pxOEijMZhRGb09vMYqa
	 WPL/+0iS82sIOUA92f4xuxsZ4E0TFETsYulNO3ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Hendry <kylehendrydev@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1321/2077] MIPS: mm: Add check for highmem before removing memory block
Date: Tue, 21 Jul 2026 17:16:34 +0200
Message-ID: <20260721152623.975480347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Hendry <kylehendrydev@gmail.com>

[ Upstream commit 6d5fbecd0213489bc4de71a0da194d18e654fd6e ]

If a device has less physical memory than the highmem threshold
bootmem_init() doesn't set highstart_pfn. This results in highmem_init()
wrongly disabling the entire memory range if the cpu doesn't support
highmem. Add a check that highstart_pfn is non zero before removing the
highmem block.

Fixes: f171b55f1441 ("mips: fix HIGHMEM initialization")
Signed-off-by: Kyle Hendry <kylehendrydev@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 1c07ca84ee2141..352718e43f697d 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -426,10 +426,11 @@ static inline void __init highmem_init(void)
 	unsigned long tmp;
 
 	/*
-	 * If CPU cannot support HIGHMEM discard the memory above highstart_pfn
+	 * If CPU cannot support HIGHMEM discard any memory above highstart_pfn
 	 */
 	if (cpu_has_dc_aliases) {
-		memblock_remove(PFN_PHYS(highstart_pfn), -1);
+		if (highstart_pfn)
+			memblock_remove(PFN_PHYS(highstart_pfn), -1);
 		return;
 	}
 
-- 
2.53.0



