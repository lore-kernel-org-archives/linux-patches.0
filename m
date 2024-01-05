Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D882AE74;
	Fri,  5 Jan 2024 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRFSW3oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2DEC433C7;
	Fri,  5 Jan 2024 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465678;
	bh=VvdKIoZDvqoE/smi7WVy1jvi8PrS6G5552hodv+hi60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRFSW3oMmsDWZNH2MRD/N4hYiWm2JdFuGjCNg6nKeOYF63iUZDAiYumhy/pR/J0nk
	 466K/Qge1Zt1PV+kmMyBCoSSSQaRlVphB5IZL184Y3VSkIqtgREzebxf//wPpzMTVF
	 zA7gAPQVB5Li9oSs1SDr8omJRvRB3n7EYLQuYhGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/41] ARM: OMAP2+: Fix null pointer dereference and memory leak in omap_soc_device_init
Date: Fri,  5 Jan 2024 15:38:46 +0100
Message-ID: <20240105143814.215861496@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 859c71c4e9324..df8a9dda67a01 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -800,10 +800,15 @@ void __init omap_soc_device_init(void)
 
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



