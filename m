Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EDE522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C2EC433C9;
	Sun,  9 Jul 2023 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901591;
	bh=o2HE8FSTJpG2d46A+YUA2qvrok8h2oVk4IK33mRwZdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ50+YrGLHJ8fXAzjGb7yATDp+5ejug1M68HBeC/LNcqQbHbxEKNmHloAd3I7iSVK
	 ulNVXUDrPuQmDLpMvp0YZwMhxIS5D80W2pgUIouN0TTd6Du7ySx1RxYAhOHxKMp0QI
	 aMCRKInaVKJz6Nv/JBJbZ8krgyuQ1l42JJhS0nJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 075/431] pstore/ram: Add check for kstrdup
Date: Sun,  9 Jul 2023 13:10:23 +0200
Message-ID: <20230709111452.913113658@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index 966191d3a5ba2..85aaf0fc6d7d1 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -599,6 +599,8 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 	raw_spin_lock_init(&prz->buffer_lock);
 	prz->flags = flags;
 	prz->label = kstrdup(label, GFP_KERNEL);
+	if (!prz->label)
+		goto err;
 
 	ret = persistent_ram_buffer_map(start, size, prz, memtype);
 	if (ret)
-- 
2.39.2



