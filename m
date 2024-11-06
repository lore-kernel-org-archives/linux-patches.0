Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF021DF252;
	Wed,  6 Nov 2024 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894950; cv=none; b=BG211gYy4vKdJav2ccDUnwaf52hGtnmQEB+mo2rMw0TuPf2eb+M5qYmCZTwx0vpf5JzZFdgjevml3Js+X7VnhvUDI7SBiVzGAlPEqVNdXz6aUnfOugAZwfCmOIqM0j4uepfzw4tLLJ0aXIzPKhnszEksASvnoBgm8lq5B+O098g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894950; c=relaxed/simple;
	bh=uMssFgwIVGK6zP/qExPtn2V2qxO4ocmICrEcxr+ZGqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL9mD2SMdPV4XaGzLjtQgjVJuOY+GrHisnhcW7jGiDDkO+akRfXEtZAf5axeS6+MEq8atfMooyWekBnIW1f1lZVOnMhsFxBw+Ae8ltoTFsUcr3ZPayB2ALvnHgkuX3Pz5kY007g+E/CZjeJZdi2MvXCFDMVG7mQ5FFguyWxo+w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoo0ssfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoo0ssfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411F8C4CED4;
	Wed,  6 Nov 2024 12:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894950;
	bh=uMssFgwIVGK6zP/qExPtn2V2qxO4ocmICrEcxr+ZGqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoo0ssfRIwWACjUjyADN/SY6+FqSzE1mzw2b0dKXeU4yZWnL2q2m/QOo2Vg3Kzj1g
	 HWRNVD4eZA9UCBfTCldv7yyGJo9FAsbTeTUhBWYhYSsqlAU9iDdhk03kEfyBHPFB6F
	 RgkRZbKLoplFWysjQ+AyopSnmtFmuSrnSOlAiFYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/350] microblaze: dont treat zero reserved memory regions as error
Date: Wed,  6 Nov 2024 12:59:05 +0100
Message-ID: <20241106120321.299318555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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
index df6de7ccdc2eb..ecad6d8b9154b 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -289,11 +289,6 @@ asmlinkage void __init mmu_init(void)
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



