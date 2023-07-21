Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F2920F98
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7031BC433CA;
	Fri, 21 Jul 2023 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966812;
	bh=VwDbWI8afAvuQL7ga3v3CdPRp45UVoLoOECQD14GT8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnG1/i3qRNtb4SR4BUOwhPNZN/ajE9PTiCopbDs7EF7xnsX/L/+3Uu+sM+dE6Vsaw
	 3lRBa3dSOyPMZ1DT7WzMihylN38MPPXkpBlS0PJ9dS7+dFvtD9FmO9vqtZKiSnJyh4
	 HaJ0ZHsvvsbzV53wzourihjmFCYSD0V5f6pBTVo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/532] netdevsim: fix uninitialized data in nsim_dev_trap_fa_cookie_write()
Date: Fri, 21 Jul 2023 18:05:42 +0200
Message-ID: <20230721160638.319255600@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f72207a5c0dbaaf6921cf9a6c0d2fd0bc249ea78 ]

The simple_write_to_buffer() function is designed to handle partial
writes.  It returns negatives on error, otherwise it returns the number
of bytes that were able to be copied.  This code doesn't check the
return properly.  We only know that the first byte is written, the rest
of the buffer might be uninitialized.

There is no need to use the simple_write_to_buffer() function.
Partial writes are prohibited by the "if (*ppos != 0)" check at the
start of the function.  Just use memdup_user() and copy the whole
buffer.

Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/7c1f950b-3a7d-4252-82a6-876e53078ef7@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 94490dfae6568..a7279356299af 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -168,13 +168,10 @@ static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
 	cookie_len = (count - 1) / 2;
 	if ((count - 1) % 2)
 		return -EINVAL;
-	buf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
-	if (!buf)
-		return -ENOMEM;
 
-	ret = simple_write_to_buffer(buf, count, ppos, data, count);
-	if (ret < 0)
-		goto free_buf;
+	buf = memdup_user(data, count);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
 
 	fa_cookie = kmalloc(sizeof(*fa_cookie) + cookie_len,
 			    GFP_KERNEL | __GFP_NOWARN);
-- 
2.39.2



