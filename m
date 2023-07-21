Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED4B1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0D9C433CB;
	Fri, 21 Jul 2023 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955970;
	bh=yaVAOtrtw2wy0/Y4Ej9XfoF8BhlaWZN+/ifYz82jf6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVFJoZtjUP0hFx3dH8DUQ4tzpDXW3P0SVTjR6A0AF8OKmpm0pDLLnExZu8BNY8iU/
	 3b8DELPnp5Jj7FYEU3el8MvJeCcrWq/gO4+53GvHJLjUsyLm0N3P8uo4IwwHqrKgbs
	 62YQHYbFE3byl76/Z5nhKrYq5rpeuG9evQrRQSco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@google.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 094/292] xdp: use trusted arguments in XDP hints kfuncs
Date: Fri, 21 Jul 2023 18:03:23 +0200
Message-ID: <20230721160532.836795071@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 2e06c57d66d3f6c26faa5f5b479fb3add34ce85a ]

Currently, verifier does not reject XDP programs that pass NULL pointer to
hints functions. At the same time, this case is not handled in any driver
implementation (including veth). For example, changing

bpf_xdp_metadata_rx_timestamp(ctx, &timestamp);

to

bpf_xdp_metadata_rx_timestamp(ctx, NULL);

in xdp_metadata test successfully crashes the system.

Add KF_TRUSTED_ARGS flag to hints kfunc definitions, so driver code
does not have to worry about getting invalid pointers.

Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
Reported-by: Stanislav Fomichev <sdf@google.com>
Closes: https://lore.kernel.org/bpf/ZKWo0BbpLfkZHbyE@google.com/
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20230711105930.29170-1-larysa.zaremba@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 41e5ca8643ec9..8362130bf085d 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -741,7 +741,7 @@ __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
 __diag_pop();
 
 BTF_SET8_START(xdp_metadata_kfunc_ids)
-#define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
+#define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, KF_TRUSTED_ARGS)
 XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
-- 
2.39.2



