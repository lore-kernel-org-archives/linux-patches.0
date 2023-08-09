Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B17311C98
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90491C433C8;
	Wed,  9 Aug 2023 11:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581170;
	bh=q7ACcwhTLpTXHVYDgYeJ/ONBL8ICQftGY6t9cNLa8/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUDwA5EGGV7y76S5od9+ZDubEGWoN7EUzyzgXZTy35J8BmFZUzafb7Aif8D4k4eoU
	 9is82Lg3hQpH/Lb3TWiZ+4Ey6/9T7XEHaFQaEaHBSqoK5AX1eiV2X2p5UTIpDQ6v3s
	 v1DCX8CBpMeK1jlLO8VzXUw3gxpq41fRi2IEZW+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Lin Ma <linma@zju.edu.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/201] bpf: Add length check for SK_DIAG_BPF_STORAGE_REQ_MAP_FD parsing
Date: Wed,  9 Aug 2023 12:42:13 +0200
Message-ID: <20230809103648.115770500@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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
index d67d06d6b817c..a811fe0f0f6fd 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -446,8 +446,11 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
 		return ERR_PTR(-EPERM);
 
 	nla_for_each_nested(nla, nla_stgs, rem) {
-		if (nla_type(nla) == SK_DIAG_BPF_STORAGE_REQ_MAP_FD)
+		if (nla_type(nla) == SK_DIAG_BPF_STORAGE_REQ_MAP_FD) {
+			if (nla_len(nla) != sizeof(u32))
+				return ERR_PTR(-EINVAL);
 			nr_maps++;
+		}
 	}
 
 	diag = kzalloc(sizeof(*diag) + sizeof(diag->maps[0]) * nr_maps,
-- 
2.40.1



