Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C2C1C07C2;
	Tue, 15 Oct 2024 12:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997021; cv=none; b=uq8FG2OE10N1THUgXziMDJyM3WCUIodSMnO3vKhvqWfJ4aPYGFUtfBxXCS90a4/fLfJpN05Edv9qoUUf9EpDTQshU7i494wBBQVOXRDosTKeF+lNJYolLk7ScmbD/kQvO6jSIcfJ8BRtus985FQA77OndJt9qhmLXeL4OPIp1fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997021; c=relaxed/simple;
	bh=9SM+Rjta8E45KFaqWDoHbZ0BUgAqHhm4lesX5ddw6+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9Nxu7xCrNUvvulhQXi7Tb7CgZZjr2l0Y3D8I2NdJs5P0mf6mfYCqVGdixbuFfkOe5bBb0/plxT8zMmbFrk57mvvH7mrKHkHpAMxyOwdKFuI5wcmIB5CbnM9Y7Iq8peXH1lR0crELDPXXL5ttyKgiHDtwJyK/iZS0weeZrUQPmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atyLR0Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atyLR0Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69715C4CEC6;
	Tue, 15 Oct 2024 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997020;
	bh=9SM+Rjta8E45KFaqWDoHbZ0BUgAqHhm4lesX5ddw6+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atyLR0FdMdHiOlEtFxMSnHU40Tgn1nI/q9XOaULByLGiKQqUz0GUf6SATxp/YBgL9
	 OB9guulTm/R+R+AjPwUyA5b9Y/rgWtoR5HYUXizEi7jLsEjONyhkYuVeRAoF2pwQ+Q
	 /ylbVOx87AYh4jNpWsEPDspF4aOMd7ZLDfHV1ii8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/518] microblaze: dont treat zero reserved memory regions as error
Date: Tue, 15 Oct 2024 14:38:57 +0200
Message-ID: <20241015123918.281818518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 45da639bd22ca..a2cd139c5eb41 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -245,11 +245,6 @@ asmlinkage void __init mmu_init(void)
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



