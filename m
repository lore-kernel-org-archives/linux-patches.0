Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6465381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86510C433C8;
	Mon, 19 Jun 2023 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171447;
	bh=apa5LjQUCPwHfND7dLxHBsRZpGi5SwgtmBlh59yV+Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0evzGL+gOX7hn5HYiS0FG4NUxm7kSNEx45IFHiygM5s6ZU7pKt2qXUD9zUNwaHwk
	 w1zMjblL5inOwny5xuzoP4yloKtO9Y0HlivT2bMXDtME9z0xkVrmlyJ71ZtORgjheM
	 yWyK5mXxy5LOfYMaGBbCoyaqG9iCg7Y6Vpc3kRos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu@dudau.co.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/166] mips: Move initrd_start check after initrd address sanitisation.
Date: Mon, 19 Jun 2023 12:28:32 +0200
Message-ID: <20230619102156.453928869@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liviu Dudau <liviu@dudau.co.uk>

[ Upstream commit 4897a898a216058dec55e5e5902534e6e224fcdf ]

PAGE_OFFSET is technically a virtual address so when checking the value of
initrd_start against it we should make sure that it has been sanitised from
the values passed by the bootloader. Without this change, even with a bootloader
that passes correct addresses for an initrd, we are failing to load it on MT7621
boards, for example.

Signed-off-by: Liviu Dudau <liviu@dudau.co.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/setup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index f1c88f8a1dc51..81dbb4ef52317 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -158,10 +158,6 @@ static unsigned long __init init_initrd(void)
 		pr_err("initrd start must be page aligned\n");
 		goto disable;
 	}
-	if (initrd_start < PAGE_OFFSET) {
-		pr_err("initrd start < PAGE_OFFSET\n");
-		goto disable;
-	}
 
 	/*
 	 * Sanitize initrd addresses. For example firmware
@@ -174,6 +170,11 @@ static unsigned long __init init_initrd(void)
 	initrd_end = (unsigned long)__va(end);
 	initrd_start = (unsigned long)__va(__pa(initrd_start));
 
+	if (initrd_start < PAGE_OFFSET) {
+		pr_err("initrd start < PAGE_OFFSET\n");
+		goto disable;
+	}
+
 	ROOT_DEV = Root_RAM0;
 	return PFN_UP(end);
 disable:
-- 
2.39.2



