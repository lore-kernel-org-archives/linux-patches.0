Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6523E1EA96
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B12C433C8;
	Tue, 25 Jul 2023 11:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283556;
	bh=6h0nfGQ13+BULzhFseUpvWqBtmb5GyEcnm+MSNsFRy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11xvfj49HX3O4QYTnD0v4dLN0ChhQ09DGBYQxtcZP3K4Sl0aWt1Pm4stPrYLtxrS6
	 pfg8sU3MnzW3irQA7oQJxgjb8cxsBnFYeSgllGn1BR6C0jTUsQeyzZYmspLIpXZAqZ
	 FllzxV0zWwJ56vjT0FoZr8J4KgmJmgChOKiLiGs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/509] pstore/ram: Add check for kstrdup
Date: Tue, 25 Jul 2023 12:39:39 +0200
Message-ID: <20230725104555.493838596@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index 184cb97c83bdd..b6183f1f4ebcf 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -577,6 +577,8 @@ struct persistent_ram_zone *persistent_ram_new(phys_addr_t start, size_t size,
 	raw_spin_lock_init(&prz->buffer_lock);
 	prz->flags = flags;
 	prz->label = kstrdup(label, GFP_KERNEL);
+	if (!prz->label)
+		goto err;
 
 	ret = persistent_ram_buffer_map(start, size, prz, memtype);
 	if (ret)
-- 
2.39.2



