Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9F15099D;
	Tue, 15 Oct 2024 11:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992258; cv=none; b=HdkLKB0Z3kq+xcHK9VVjY2XAEiv7TYHo2554/qFLjeAsSSFSQyX0QrRmERw7ToN7hFFRzuYjapnRcj/vEweXdPfBPxM0gpK1/5i3728eO59Y1fpVwrrVbkMtGo9w/9qNfNk5GFjRJ90uUJcElf47XDcMfeynLdJBitqFCTLwT50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992258; c=relaxed/simple;
	bh=wjeVwpaM7OXgk8E34Dnb3F1tf4lSrVa5+RONc23b8uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3haD4Nxwmx5wiC59sJd5hbr05fHxmIEyGbrX/y1n+AmpRD5i/+0S/95kfvKyMCWWozT9J4HTDF5oGqMrGKtgRiuenzqGQTCEx/NFJgGOGZn9YoMY6Tb2RyBUrVy8ChmO0Sy6KwpT1s/F5K7CUQMgEyGFWaR87AA81lGC66AgLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twy8FTIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twy8FTIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D804BC4CED1;
	Tue, 15 Oct 2024 11:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992258;
	bh=wjeVwpaM7OXgk8E34Dnb3F1tf4lSrVa5+RONc23b8uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twy8FTIvzkh37Ua45XUPHLnvpCim79JlAPSXwCLqhgvlvqzypyNkKHKtmrw0YLlRh
	 zjY9oU5b/ZWKnjqh/66GHJ8HBNOt1ZzoNi8p00MlqaSI/8wOG2l1/Nr8+0Ndd74QBP
	 iNMHEVza75RG/NwEZWtpJD8A0RKy0v+fyTtQegcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/691] microblaze: dont treat zero reserved memory regions as error
Date: Tue, 15 Oct 2024 13:20:12 +0200
Message-ID: <20241015112442.894553659@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport <rppt@kernel.org>

[ Upstream commit 0075df288dd8a7abfe03b3766176c393063591dd ]

Before commit 721f4a6526da ("mm/memblock: remove empty dummy entry") the
check for non-zero of memblock.reserved.cnt in mmu_init() would always
be true either because  memblock.reserved.cnt is initialized to 1 or
because there were memory reservations earlier.

The removal of dummy empty entry in memblock caused this check to fail
because now memblock.reserved.cnt is initialized to 0.

Remove the check for non-zero of memblock.reserved.cnt because it's
perfectly fine to have an empty memblock.reserved array that early in
boot.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240729053327.4091459-1-rppt@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/mm/init.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 952f35b335b26..71ad7ffc3eff3 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -192,11 +192,6 @@ asmlinkage void __init mmu_init(void)
 {
 	unsigned int kstart, ksize;
 
-	if (!memblock.reserved.cnt) {
-		pr_emerg("Error memory count\n");
-		machine_restart(NULL);
-	}
-
 	if ((u32) memblock.memory.regions[0].size < 0x400000) {
 		pr_emerg("Memory must be greater than 4MB\n");
 		machine_restart(NULL);
-- 
2.43.0



