Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FE71C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83556C433D2;
	Wed, 28 Dec 2022 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243434;
	bh=BDB3VCuhU2MsAOQBEy2IuWIMQbw75/ec0VuvdB0Fh9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnbRiJII9vzD9xyXEUTfuV13JhI9E001wGmjtv8LdwqQEqiFKyw7rUhXb/F9+eTsm
	 RGSwnLqahzgGaXlKyh1fJtX6DueJPO7bFgBtFXi1JlvpAbaNcqKReZEhLhCA6iCTKg
	 o1cgDzGlV5Db7Vw4E+pNgvPSKKUpSNxCjGZ9GIDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0492/1146] bpftool: Fix memory leak in do_build_table_cb
Date: Wed, 28 Dec 2022 15:33:51 +0100
Message-Id: <20221228144343.546860523@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fa55ef14ef4fe06198c0ce811b603aec24134bc2 ]

strdup() allocates memory for path. We need to release the memory in the
following error path. Add free() to avoid memory leak.

Fixes: 8f184732b60b ("bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221206071906.806384-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 0cdb4f711510..e7a11cff7245 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -499,6 +499,7 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
 	if (err) {
 		p_err("failed to append entry to hashmap for ID %u, path '%s': %s",
 		      pinned_info.id, path, strerror(errno));
+		free(path);
 		goto out_close;
 	}
 
-- 
2.35.1



