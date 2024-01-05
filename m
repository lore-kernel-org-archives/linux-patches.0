Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D2518EB7;
	Fri,  5 Jan 2024 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7phsm4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEB3C433C7;
	Fri,  5 Jan 2024 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465831;
	bh=/PYoXlV3AGwHYpbw7aM3SSRhbm8GUtZZ23gKYP0AH+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7phsm4i6dY7q0qHKMyBJUtAFXA5wAdkjjpBEKKevATjVXiZniTHl4kBcwWESIy16
	 Hsl156szk+HshrvRbcWs59I1IlwGC2i2FmQb4bVB8oqJJ8lfaplxmvHOUuEjWla5rH
	 rnxj0rQMTMCtFQ8Pc6AgAbgAwBTNHQKirbVahSm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/47] ARM: OMAP2+: Fix null pointer dereference and memory leak in omap_soc_device_init
Date: Fri,  5 Jan 2024 15:38:50 +0100
Message-ID: <20240105143815.665190329@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit c72b9c33ef9695ad7ce7a6eb39a9df8a01b70796 ]

kasprintf() returns a pointer to dynamically allocated memory which can
be NULL upon failure. When 'soc_dev_attr->family' is NULL,it'll trigger
the null pointer dereference issue, such as in 'soc_info_show'.

And when 'soc_device_register' fails, it's necessary to release
'soc_dev_attr->family' to avoid memory leaks.

Fixes: 6770b2114325 ("ARM: OMAP2+: Export SoC information to userspace")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Message-ID: <20231123145237.609442-1-chentao@kylinos.cn>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/id.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 188ea5258c999..8c9160779689d 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -797,10 +797,15 @@ void __init omap_soc_device_init(void)
 
 	soc_dev_attr->machine  = soc_name;
 	soc_dev_attr->family   = omap_get_family();
+	if (!soc_dev_attr->family) {
+		kfree(soc_dev_attr);
+		return;
+	}
 	soc_dev_attr->revision = soc_rev;
 
 	soc_dev = soc_device_register(soc_dev_attr);
 	if (IS_ERR(soc_dev)) {
+		kfree(soc_dev_attr->family);
 		kfree(soc_dev_attr);
 		return;
 	}
-- 
2.43.0



