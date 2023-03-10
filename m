Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66880848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2BEC433D2;
	Fri, 10 Mar 2023 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458412;
	bh=BJCK/MI2oqlK4Pnw64YK4S26qD5YbxS2ntVnJJojWAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCRGBsOCORvU6IGmDWPWMGegDCpTXH1CwjzJngCTJu74+ogUVB2BJTBCNXAeTpb64
	 qUQXNOqTIgGQhsKMOIhBwMhQARZe6dKLaybTj4T/msYbDGiRthDNb4G7nyH2rKPXk8
	 a53uHqZ46ZF+zKRaE5S3A9NhQmYfJcOop35e54pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hui <judy.chenhui@huawei.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/357] ARM: OMAP2+: Fix memory leak in realtime_counter_init()
Date: Fri, 10 Mar 2023 14:34:53 +0100
Message-Id: <20230310133734.169660141@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 1defb838eae3a..a5da85b73461b 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -700,6 +700,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
-- 
2.39.2



