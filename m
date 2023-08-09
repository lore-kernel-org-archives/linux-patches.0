Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279015AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ABFC433C7;
	Wed,  9 Aug 2023 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577917;
	bh=dozIg0AI47gtc5ZGFjZMCyWuX7KZFonahf6NewkCQLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntSOALiGWpgUNDdslEKHE53igm6ImYbZE5WoTCFp8dgr/lLHe5ynxnypNflaN8jn0
	 xSYb+ABC1dgUGTTQ3rAZzPRaeJdKn6uPqIW9LS9MNFYS5QI3hQkwwMokLsCxtm94Dh
	 gqUbLTyqsYdDY9THAhNtMDJp3Zv0rV/CtstfokFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Lin Ma <linma@zju.edu.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 041/165] bpf: Add length check for SK_DIAG_BPF_STORAGE_REQ_MAP_FD parsing
Date: Wed,  9 Aug 2023 12:39:32 +0200
Message-ID: <20230809103644.153793014@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit bcc29b7f5af6797702c2306a7aacb831fc5ce9cb ]

The nla_for_each_nested parsing in function bpf_sk_storage_diag_alloc
does not check the length of the nested attribute. This can lead to an
out-of-attribute read and allow a malformed nlattr (e.g., length 0) to
be viewed as a 4 byte integer.

This patch adds an additional check when the nlattr is getting counted.
This makes sure the latter nla_get_u32 can access the attributes with
the correct length.

Fixes: 1ed4d92458a9 ("bpf: INET_DIAG support in bpf_sk_storage")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230725023330.422856-1-linma@zju.edu.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index d4172534dfa8d..cca7594be92ec 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -496,8 +496,11 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
 		return ERR_PTR(-EPERM);
 
 	nla_for_each_nested(nla, nla_stgs, rem) {
-		if (nla_type(nla) == SK_DIAG_BPF_STORAGE_REQ_MAP_FD)
+		if (nla_type(nla) == SK_DIAG_BPF_STORAGE_REQ_MAP_FD) {
+			if (nla_len(nla) != sizeof(u32))
+				return ERR_PTR(-EINVAL);
 			nr_maps++;
+		}
 	}
 
 	diag = kzalloc(struct_size(diag, maps, nr_maps), GFP_KERNEL);
-- 
2.40.1



