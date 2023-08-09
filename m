Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B9C53B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46409C433C7;
	Wed,  9 Aug 2023 10:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578351;
	bh=QD+2NvHvpYFesV9dgkYpnKxM7sapwZVDek+B14lqOc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q55WGGDwOpdpLf+iueKx9at0bI929a4i0hqttjlXHtnd987s/UzBSMh7TTeM5/LPH
	 ZWxtzGrTIJI2Hu2WzboqlTcNfltozrRk7EljWEo1AbdIx3W0fT133e9kk0AzwwKEYT
	 Waj1xjttrC0uUF1xqFZnJjCh0ozxTjCKxENZFd/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Lin Ma <linma@zju.edu.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/127] bpf: Add length check for SK_DIAG_BPF_STORAGE_REQ_MAP_FD parsing
Date: Wed,  9 Aug 2023 12:40:15 +0200
Message-ID: <20230809103637.589469422@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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
index 94374d529ea42..ad01b1bea52e4 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -531,8 +531,11 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
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



