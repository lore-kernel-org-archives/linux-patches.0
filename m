Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB98BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527EAC433D2;
	Tue,  7 Mar 2023 18:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214696;
	bh=37AzPDB6qsEfN8uuFhA/55KyMtG4UOzpPHgcE+i4lvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ttap0Ax5eKwA0srxuYZc9Eix+CMairX9LO+SaP7aeXvpJWvBfzOUJtQxLrRJGMjDT
	 wxb0NAXPmTE0leTEn8DEs5rzvgwBgoAbf61xaBV05lyrh8nYkaXzfGaFea7BFZs4rL
	 61jXoGkSROhPAtOdqX+/CHz5pwn0IEkKqeb6tQ+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hui <judy.chenhui@huawei.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/567] ARM: OMAP2+: Fix memory leak in realtime_counter_init()
Date: Tue,  7 Mar 2023 17:55:40 +0100
Message-Id: <20230307165906.017908106@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 620ba69c8f114..5677c4a08f376 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -76,6 +76,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
-- 
2.39.2



