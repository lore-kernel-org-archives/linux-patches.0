Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F281ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3D6C433C7;
	Fri, 21 Jul 2023 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965559;
	bh=W1BQKvgZPmhn1jb6kwJynCExrpD/bui1wMvLgqeiato=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6uVZN0O8peb+CfkzUWcOPQoVVeG2vDWxVMTwveKHDsgyoyiBq24f4YHbTCYiZ7KY
	 hj4zCSHh5b3Q2deFHF814vJDhK+tgwaUD/ns3BIEY+eStOJERIf+6y0AoCnWOhk+lW
	 /xYsljQr+ztto5VxIpKyRW4f8YIo2du5ul/TSwaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/532] pstore/ram: Add check for kstrdup
Date: Fri, 21 Jul 2023 17:58:57 +0200
Message-ID: <20230721160616.449449115@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d97038d5ec2062733c1e016caf9baaf68cf64ea1 ]

Add check for the return value of kstrdup() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: e163fdb3f7f8 ("pstore/ram: Regularize prz label allocation lifetime")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230614093733.36048-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 155c7010b1f83..fd9bab137685d 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -591,6 +591,8 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 	raw_spin_lock_init(&prz->buffer_lock);
 	prz->flags = flags;
 	prz->label = kstrdup(label, GFP_KERNEL);
+	if (!prz->label)
+		goto err;
 
 	ret = persistent_ram_buffer_map(start, size, prz, memtype);
 	if (ret)
-- 
2.39.2



