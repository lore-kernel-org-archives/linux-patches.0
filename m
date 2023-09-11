Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757BD4432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08C6C433C7;
	Mon, 11 Sep 2023 14:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441405;
	bh=5ABk6foTYudds1mNovXNfAQDaHGU2Sdl4DCipukPHJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWfRB+I/1HmWn0Xp43bCnVevRlPni8W4ZdMCvL4TBMFeT04hAScKc4X6M94RdTTaT
	 NJ1+c8gnQF0kbNLIfMNFvvgJW55ffyHUCJ2cddcO7k1uI+8PLiSI1DSTxzQBoiBLbK
	 4/Hf8zQGvC8jN47AAgNH8Xv4b+6ke27gHvFldwyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <minyard@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 375/739] ipmi:ssif: Fix a memory leak when scanning for an adapter
Date: Mon, 11 Sep 2023 15:42:54 +0200
Message-ID: <20230911134701.639441454@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Corey Minyard <minyard@acm.org>

[ Upstream commit b8d72e32e1453d37ee5c8a219f24e7eeadc471ef ]

The adapter scan ssif_info_find() sets info->adapter_name if the adapter
info came from SMBIOS, as it's not set in that case.  However, this
function can be called more than once, and it will leak the adapter name
if it had already been set.  So check for NULL before setting it.

Fixes: c4436c9149c5 ("ipmi_ssif: avoid registering duplicate ssif interface")
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 3b87a2726e994..faf1f2ad584bf 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1400,7 +1400,7 @@ static struct ssif_addr_info *ssif_info_find(unsigned short addr,
 restart:
 	list_for_each_entry(info, &ssif_infos, link) {
 		if (info->binfo.addr == addr) {
-			if (info->addr_src == SI_SMBIOS)
+			if (info->addr_src == SI_SMBIOS && !info->adapter_name)
 				info->adapter_name = kstrdup(adapter_name,
 							     GFP_KERNEL);
 
-- 
2.40.1



