Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E12168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E26CC4339C;
	Mon,  8 May 2023 10:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540689;
	bh=xdAFWYR/RXqH8ok1Y1aPIX+9ysIpKlGcch10JaOzDf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kemYTu6MznZMUFmh8RUA/ByLOczoTmfcXA3SxPBbvN6tbfUZfKbgCC+Z3p+AtVhMH
	 gVIuQFv/l2aYr6iSmwzsVCitA+/pu032W4XbeSCytzgKSUfqOGcr0q9Vs5CjR3nBFb
	 a1sbV8jJSaysQ9LUbp5v3JxURdMb7SHYLItYOrCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/611] powerpc/wii: fix resource printk format warnings
Date: Mon,  8 May 2023 11:45:03 +0200
Message-Id: <20230508094437.131393006@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7b69600d4da0049244e9be2f5ef5a2f8e04fcd9a ]

Use "%pa" format specifier for resource_size_t to avoid compiler
printk format warnings.

../arch/powerpc/platforms/embedded6xx/flipper-pic.c: In function 'flipper_pic_init':
../include/linux/kern_levels.h:5:25: error: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
../arch/powerpc/platforms/embedded6xx/flipper-pic.c:148:9: note: in expansion of macro 'pr_info'
  148 |         pr_info("controller at 0x%08x mapped to 0x%p\n", res.start, io_base);
      |         ^~~~~~~

../arch/powerpc/platforms/embedded6xx/hlwd-pic.c: In function 'hlwd_pic_init':
../include/linux/kern_levels.h:5:25: error: format '%x' expects argument of type 'unsigned int', but argument 2 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
../arch/powerpc/platforms/embedded6xx/hlwd-pic.c:174:9: note: in expansion of macro 'pr_info'
  174 |         pr_info("controller at 0x%08x mapped to 0x%p\n", res.start, io_base);
      |         ^~~~~~~

../arch/powerpc/platforms/embedded6xx/wii.c: In function 'wii_ioremap_hw_regs':
../include/linux/kern_levels.h:5:25: error: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
../arch/powerpc/platforms/embedded6xx/wii.c:77:17: note: in expansion of macro 'pr_info'
   77 |                 pr_info("%s at 0x%08x mapped to 0x%p\n", name,
      |                 ^~~~~~~

Fixes: 028ee972f032 ("powerpc: gamecube/wii: flipper interrupt controller support")
Fixes: 9c21025c7845 ("powerpc: wii: hollywood interrupt controller support")
Fixes: 5a7ee3198dfa ("powerpc: wii: platform support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230223070116.660-3-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/embedded6xx/flipper-pic.c | 2 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    | 2 +-
 arch/powerpc/platforms/embedded6xx/wii.c         | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index 609bda2ad5dd2..4d9200bdba78c 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -145,7 +145,7 @@ static struct irq_domain * __init flipper_pic_init(struct device_node *np)
 	}
 	io_base = ioremap(res.start, resource_size(&res));
 
-	pr_info("controller at 0x%08x mapped to 0x%p\n", res.start, io_base);
+	pr_info("controller at 0x%pa mapped to 0x%p\n", &res.start, io_base);
 
 	__flipper_quiesce(io_base);
 
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index 380b4285cce47..4d2d92de30afd 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -171,7 +171,7 @@ static struct irq_domain *__init hlwd_pic_init(struct device_node *np)
 		return NULL;
 	}
 
-	pr_info("controller at 0x%08x mapped to 0x%p\n", res.start, io_base);
+	pr_info("controller at 0x%pa mapped to 0x%p\n", &res.start, io_base);
 
 	__hlwd_quiesce(io_base);
 
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index f4e654a9d4ff6..219659f2ede06 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -74,8 +74,8 @@ static void __iomem *__init wii_ioremap_hw_regs(char *name, char *compatible)
 
 	hw_regs = ioremap(res.start, resource_size(&res));
 	if (hw_regs) {
-		pr_info("%s at 0x%08x mapped to 0x%p\n", name,
-			res.start, hw_regs);
+		pr_info("%s at 0x%pa mapped to 0x%p\n", name,
+			&res.start, hw_regs);
 	}
 
 out_put:
-- 
2.39.2



