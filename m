Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2957D168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936B9C433D2;
	Mon,  8 May 2023 09:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539719;
	bh=tABDN212CA76MVrgvoONGmEu4F/MywUwtIQNv3n17ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xhr5ru4g7G1Miof51QccHff9olI+/GFUKqN9fSBW17JaPwYINCB/c/wVEVsQXbFNU
	 /oDpPvqf2xxeafQ2MU9EYYMTJOdz/pKFz4XQDtSu2V/fpXMBv7/tMvAhx/vglQVWb1
	 K39WmL4hFVeOSEx9ie3WELNdZhuuPUULgxP8y0aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/611] selftests/resctrl: Return NULL if malloc_and_init_memory() did not alloc mem
Date: Mon,  8 May 2023 11:39:18 +0200
Message-Id: <20230508094426.034549578@linuxfoundation.org>
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



