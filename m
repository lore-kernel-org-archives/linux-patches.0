Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD98481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909C0C433EF;
	Fri, 10 Mar 2023 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457682;
	bh=h45FqZ9Ieft4z0aLHcXFa3xiGJQXXHeHkhXUqcc5B6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfvny06Tls4260NVaveh3O4d3oWnRsFDEdVHG8h/wn7+2Hi8Gvvf/W6zxtlrCz4kB
	 3d4wYpWMF7Il+n7HDi67ccWILm4vd/MKwEoPyvo4YtuEbb91YSXwK7karjrQZUh4Vb
	 BtT8/m5dbnHuqNp+r7TmSc0JypwK8dJYn9nbwVjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hui <judy.chenhui@huawei.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/252] ARM: OMAP2+: Fix memory leak in realtime_counter_init()
Date: Fri, 10 Mar 2023 14:36:14 +0100
Message-Id: <20230310133718.942136744@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Hui <judy.chenhui@huawei.com>

[ Upstream commit ed8167cbf65c2b6ff6faeb0f96ded4d6d581e1ac ]

The "sys_clk" resource is malloced by clk_get(),
it is not released when the function return.

Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time counter.")
Signed-off-by: Chen Hui <judy.chenhui@huawei.com>
Message-Id: <20221108141917.46796-1-judy.chenhui@huawei.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index c4ba848e8af62..d98aa78b9be91 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -701,6 +701,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
-- 
2.39.2



