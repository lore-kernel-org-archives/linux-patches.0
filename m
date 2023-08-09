Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50710174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6028C433C8;
	Wed,  9 Aug 2023 10:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578675;
	bh=P3EFJPDAqXKsC5iQvWc+AQwsXYAjrUMGybJsKT1HB64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzWA6OcfPc9gcQFrjJZue4huWGirszu5zWMVjKxvRuADsF3iOPT65HcUc3bqicDPt
	 YuaUKvTMKXlnPA0jWm7gSuCPTlmYNfSif9QxAreReYu+S7JpkGNy91y/3IfsJCfmXH
	 wqDwU2Aagpw8XSfDmhNROP7dW4DJ60xOWW4SlnSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Lin Ma <linma@zju.edu.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/92] bpf: Add length check for SK_DIAG_BPF_STORAGE_REQ_MAP_FD parsing
Date: Wed,  9 Aug 2023 12:40:53 +0200
Message-ID: <20230809103634.194040442@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
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
index 910ca41cb9e67..4953abee79fea 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -521,8 +521,11 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
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



