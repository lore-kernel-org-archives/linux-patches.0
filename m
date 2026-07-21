Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA8D3358C6;
	Tue, 21 Jul 2026 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657959; cv=none; b=s6fOr8fXHEh6P8X/5/HUlfPQSunbvpYXblBq+5vHfmH7hWTfRXvZbL0vLRrOTQJ1miN0ByUNqrXVAlVxEhQo2BIrkK4VYYaZI5ILdtibmjHdnnTevxKI4gMyhy4TBBPyrn9/vXgq/2stkMpZVpAM+XYmCVB8LZO0aRZ9kfEZsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657959; c=relaxed/simple;
	bh=Udccl9iaCNyJgjqh5a4oj/4/8T1UN8DDjuF364UDKZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJqsfCsIwik3t3uI9NJKPE7kLRkoZMizJdTrzhSX8FlfrfAZYVhyO7/0nkOysUbS+zwNNl87zdauIhP+2YB0Gq2q0T+oYxHOQddZeOQF6hQO2kWJFowXIShA+uy4COsm9KWgHGHaapf0IsACbU2iKrAUe9E/KJ97LADy5tp2/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3Wwmc4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3Wwmc4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEEE1F00A3A;
	Tue, 21 Jul 2026 18:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657957;
	bh=OpCbuPu5s//Glm7VXJ2xTuCcrArU4CtGacZrNpKR2j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3Wwmc4Aau96vxxhZXZcFwTrWfdv2IFpkcYrNCWqF/q59LWMq0dj4Cv5L32Ytuo1n
	 vjl3NNs4aEKHDJKErWwcu5I6l4K09ZXIs1CwAnNKoPzTRdoaz9pw/N/oZyfeshZdg6
	 6V0/yVUhJFwTLHJvPpEw5UXHOdoIUoHx97t8Nnw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Hendry <kylehendrydev@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0961/1611] MIPS: mm: Add check for highmem before removing memory block
Date: Tue, 21 Jul 2026 17:17:57 +0200
Message-ID: <20260721152537.009834387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index decd201504043c..4d73dc6c334738 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -435,10 +435,11 @@ static inline void __init highmem_init(void)
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



