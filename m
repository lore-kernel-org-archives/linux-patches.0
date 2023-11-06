Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4A6208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHRIkEUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD886C433C7;
	Mon,  6 Nov 2023 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276726;
	bh=6Y2SBe5+MO2isqZnfvRlCFLhihD9grEYjYWOBF0O7cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHRIkEUyls5gJo9aLs+2lbIuxLNRon0FpCphVrNnkxq6ubK8Qeo2LB3jo0+ttv3GK
	 UwlRvZUfwERrAZGzEeNwNDdWKpgpf52PBA/kOj5QnNq80cN+p8Vj0VraPZMjecksbz
	 qVULcyBkGHzhNakjM2FgA1TfpEhRf1rJ2P1kUct4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak R Varma <drv@mailo.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 48/88] LoongArch: Replace kmap_atomic() with kmap_local_page() in copy_user_highpage()
Date: Mon,  6 Nov 2023 14:03:42 +0100
Message-ID: <20231106130307.621590964@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 477a0ebec101359f49d92796e3b609857d564b52 ]

Replace kmap_atomic()/kunmap_atomic() calls with kmap_local_page()/
kunmap_local() in copy_user_highpage() which can be invoked from both
preemptible and atomic context [1].

[1] https://lore.kernel.org/all/20201029222652.302358281@linutronix.de/

Suggested-by: Deepak R Varma <drv@mailo.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 51c9a6c90a169..d967d881c3fef 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -68,11 +68,11 @@ void copy_user_highpage(struct page *to, struct page *from,
 {
 	void *vfrom, *vto;
 
-	vto = kmap_atomic(to);
-	vfrom = kmap_atomic(from);
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
 	copy_page(vto, vfrom);
-	kunmap_atomic(vfrom);
-	kunmap_atomic(vto);
+	kunmap_local(vfrom);
+	kunmap_local(vto);
 	/* Make sure this page is cleared on other CPU's too before using it */
 	smp_wmb();
 }
-- 
2.42.0



