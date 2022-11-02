Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8D2629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86B2C433D6;
	Wed,  2 Nov 2022 03:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359790;
	bh=SicJpDQEBs9PYN8UywJmCqk+A0zRsFHDHJ0JGeKSYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx1LQLGcUwvZWm8CLk2G+23ib29Sgzw1Epc01CDdIk3/8F9wkJ8OVLD9bXDH7OJsu
	 HekXzjFhcT3XtvZ/CwZCdqpmkKiESoOutaArCwQ2l3yQxZtNjReoHlXOx1xkHIWAGB
	 7h7d2RTQkit4GdnurO5aiGBKNFYG3hXNIul06TD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaobo Liu <cppcoffee@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/78] net/atm: fix proc_mpc_write incorrect return value
Date: Wed,  2 Nov 2022 03:34:02 +0100
Message-Id: <20221102022053.474415763@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiaobo Liu <cppcoffee@gmail.com>

[ Upstream commit d8bde3bf7f82dac5fc68a62c2816793a12cafa2a ]

Then the input contains '\0' or '\n', proc_mpc_write has read them,
so the return value needs +1.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/mpoa_proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 46d6cd9a36ae..c4e9538ac144 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -222,11 +222,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!page)
 		return -ENOMEM;
 
-	for (p = page, len = 0; len < nbytes; p++, len++) {
+	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
+		len += 1;
 		if (*p == '\0' || *p == '\n')
 			break;
 	}
-- 
2.35.1



