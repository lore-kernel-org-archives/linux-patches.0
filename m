Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B487F633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7B4C433C1;
	Wed,  2 Nov 2022 03:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360286;
	bh=BtZnXpGahIedbHIaXuR2wxFv59GKyLQpH2GzbOXjdGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUTGrnqiMIdXnujLF8M8CTtMWNqaAgsmTl0+HJwmO+6CgP7WpXR2y2i4INmrxrybZ
	 +h8oPr0fFyoEIlkJXnHq2Ve3bgAJhYWcWzNxcZEVmNz+aa1eBKI/mJOlukVXwrO4pi
	 Z85Fe2A6swY4AJIKh+eWt7ksbAERZLKssF44AdpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaobo Liu <cppcoffee@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/60] net/atm: fix proc_mpc_write incorrect return value
Date: Wed,  2 Nov 2022 03:34:33 +0100
Message-Id: <20221102022051.473371361@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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
index 8a0c17e1c203..4d5f8690e914 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -220,11 +220,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
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



