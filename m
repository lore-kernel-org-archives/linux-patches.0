Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4844BBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C261FC4339B;
	Tue,  7 Mar 2023 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212500;
	bh=SRxSxwdC2UK5K5lirdJ2KMLSUYI6E2JgaV5+Ezi6DKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrJ0LNH5Tjte47Jv36nlAeiAPPRcHMV55EMlvw39d/yOr6WZcLPxKzihjblZF9zAr
	 C8faW6gmxctzrEW4wmPl6vk3NizQFx4ix+2HV/rQ4gvgk3sbHP2iXZeTEFWOvudJSP
	 EvvLIeaTMdh/5t0tXF+tkNi2QEBcxTXAn5W4v5+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/885] s390/mem_detect: fix detect_memory() error handling
Date: Tue,  7 Mar 2023 17:52:17 +0100
Message-Id: <20230307170010.858707251@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 3400c35a4090704e6c465449616ab7e67a9209e7 ]

Currently if for some reason sclp_early_read_info() fails,
sclp_early_get_memsize() will not set max_physmem_end and it
will stay uninitialized. Any garbage value other than 0 will lead
to detect_memory() taking wrong path or returning a garbage value
as max_physmem_end. To avoid that simply initialize max_physmem_end.

Fixes: 73045a08cf55 ("s390: unify identity mapping limits handling")
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/mem_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 7fa1a32ea0f3f..0a5821ef4f1fd 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -165,7 +165,7 @@ static void search_mem_end(void)
 
 unsigned long detect_memory(void)
 {
-	unsigned long max_physmem_end;
+	unsigned long max_physmem_end = 0;
 
 	sclp_early_get_memsize(&max_physmem_end);
 
-- 
2.39.2



