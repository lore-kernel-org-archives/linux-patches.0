Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DB118C00D;
	Fri, 27 Sep 2024 12:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439959; cv=none; b=ogenVCMI3qsuLzpUPk8+nAG6Yc94WZHnU/3keIp069Q3B0YEJu8nskiQX1vznIjIDkffF91BSKtBYRK0nHj0GrLHFvUmR/S3vlpGbl4TcScN0kiFlaG674AgusJlKD+q/d6Vo/Io1kYcJodZE6pnf64mSEW2dL3IZacf5enzcmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439959; c=relaxed/simple;
	bh=+3/gE7wk3rQhXNEKmf+qZltU+xBaWtnBqQrz1aH2aQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwTFgcx1J0vD4liet9kNGN9J0COMuMKeRzeplFk4XIOM1MXBkW/pAAdT7ZHkBjweM85nFESlhtGCCJoVhQPkrKFEGWdr77VRzeDdXHzgB8bXcvB6H3JJQp8rHnIzKEagbKoroxuzXNTPwhscj9WA+lRr5DBMCUOUCI0GvSAb2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjcg6Ooo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjcg6Ooo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DD3C4CEC4;
	Fri, 27 Sep 2024 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439958;
	bh=+3/gE7wk3rQhXNEKmf+qZltU+xBaWtnBqQrz1aH2aQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjcg6Oooa6kx0lOV+BXqBWQhD+KaO1Hiz3tz2/NfzDhSUdYgruKsqtMfFWa9oTS+j
	 NyV35TKX4sbP42EQOgpkkX9CjxQqqYGjPU88QYw8BhUmfgtyFTsmc8+I2pPRSymh3E
	 o+JL7xtJ03nOuxbY88PR7J/360SCY/jNAqEV01ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/54] microblaze: dont treat zero reserved memory regions as error
Date: Fri, 27 Sep 2024 14:23:02 +0200
Message-ID: <20240927121720.129442670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3827dc76edd82..4520c57415797 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -193,11 +193,6 @@ asmlinkage void __init mmu_init(void)
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



