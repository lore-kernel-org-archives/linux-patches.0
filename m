Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E9C1FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52974C433C9;
	Fri, 21 Jul 2023 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956004;
	bh=fcJKqd2+Lm0CxymUN4dde9zVyvViQfmRIZmeB3lW6G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfRVpHvxoinXm/ayvbaYBYb75ZYVVnajoK2YQrv9RgK/iTPL952nyWWcl+hSc0kHE
	 gG6NMOJt83EM5hSVqT5uhnlES2nDHaq2ddg2LvhIpx9QR530guFQAsWFQ3jaz+ZPVO
	 fjSJSGd7g/QY9jc7ul4PdVstHtzkVVIIyDOdzqJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 099/292] netdevsim: fix uninitialized data in nsim_dev_trap_fa_cookie_write()
Date: Fri, 21 Jul 2023 18:03:28 +0200
Message-ID: <20230721160533.049239401@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
index 6045bece2654d..b4d3b9cde8bd6 100644
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



