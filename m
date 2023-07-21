Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB38F20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B711C433C7;
	Fri, 21 Jul 2023 19:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967141;
	bh=QMx00GV73ExsiDGIHVHUOk7IR9frutVtrL4AeQsamWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YaMQfaNUl3/zvyqF4O0tO1y/CmE9LCzhqwSIRf2IY+xgBQqXTzfNUuNYle14H9gZN
	 akbRURbMj+Byi9cOeSKpjOWnQgWW7jbGz//UIKx/VTtHXa2KIkhBw63I1wQP34Kqbk
	 rFfC3+BZlIKuqeR00B3usodF4UtKPtY6gNcoEz10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/223] netdevsim: fix uninitialized data in nsim_dev_trap_fa_cookie_write()
Date: Fri, 21 Jul 2023 18:05:12 +0200
Message-ID: <20230721160523.368360029@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
index 68e56e451b2be..c3fbdd6b68baf 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -184,13 +184,10 @@ static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
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



