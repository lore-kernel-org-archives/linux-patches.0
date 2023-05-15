Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09620FC10
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138EC433D2;
	Mon, 15 May 2023 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172154;
	bh=tABDN212CA76MVrgvoONGmEu4F/MywUwtIQNv3n17ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tORNrjtt4wBCZ63vshW5hhOVR48y8hOUsTYFmG3q8onjhvu3VwitlNW2fe0Bf2Ffw
	 F3gFicmzvDAjmv5VLgZ7qxZIchRbUU682Dwb9BzV9876IfqE1n0jubyGbNLPH95g1m
	 DLfZjrYNMbxyFgtVBMG8JKGQYRH25cF4nSh0IhCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/381] selftests/resctrl: Return NULL if malloc_and_init_memory() did not alloc mem
Date: Mon, 15 May 2023 18:25:12 +0200
Message-Id: <20230515161739.581049583@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 22a8be280383812235131dda18a8212a59fadd2d ]

malloc_and_init_memory() in fill_buf isn't checking if memalign()
successfully allocated memory or not before accessing the memory.

Check the return value of memalign() and return NULL if allocating
aligned memory fails.

Fixes: a2561b12fe39 ("selftests/resctrl: Add built in benchmark")
Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/fill_buf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/selftests/resctrl/fill_buf.c
index 56ccbeae0638d..c20d0a7ecbe63 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -68,6 +68,8 @@ static void *malloc_and_init_memory(size_t s)
 	size_t s64;
 
 	void *p = memalign(PAGE_SIZE, s);
+	if (!p)
+		return NULL;
 
 	p64 = (uint64_t *)p;
 	s64 = s / sizeof(uint64_t);
-- 
2.39.2



