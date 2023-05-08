Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05719168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608E9C433EF;
	Mon,  8 May 2023 11:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544627;
	bh=Be0Gr0J6u7pMKBcJ2cMXMPg950I8kiIaY3AvJN1XAbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKbNIe9I20HB4UbGcv0FxzPcB5xIrgCepEYfgKC8MJ7U7IT+Anp+CqZLnBWv5k8UA
	 YOdT2RnQsyEs9c3yt7k5EHZT/l49ToISjbWmop8G0AW5ewj7gSbQINhWtGSj5zCCL+
	 eTr69j4NlY4l1ornmpLZYRSlV7KDjHsDGjTCWM0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 471/694] bpf: Fix race between btf_put and btf_idr walk.
Date: Mon,  8 May 2023 11:45:06 +0200
Message-Id: <20230508094449.085726884@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit acf1c3d68e9a31f10d92bc67ad4673cdae5e8d92 ]

Florian and Eduard reported hard dead lock:
[   58.433327]  _raw_spin_lock_irqsave+0x40/0x50
[   58.433334]  btf_put+0x43/0x90
[   58.433338]  bpf_find_btf_id+0x157/0x240
[   58.433353]  btf_parse_fields+0x921/0x11c0

This happens since btf->refcount can be 1 at the time of btf_put() and
btf_put() will call btf_free_id() which will try to grab btf_idr_lock
and will dead lock.
Avoid the issue by doing btf_put() without locking.

Fixes: 3d78417b60fb ("bpf: Add bpf_btf_find_by_name_kind() helper.")
Fixes: 1e89106da253 ("bpf: Add bpf_core_add_cands() and wire it into bpf_core_apply_relo_insn().")
Reported-by: Florian Westphal <fw@strlen.de>
Reported-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20230421014901.70908-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 3140a7881665d..46bce5577fb48 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -572,8 +572,8 @@ static s32 bpf_find_btf_id(const char *name, u32 kind, struct btf **btf_p)
 			*btf_p = btf;
 			return ret;
 		}
-		spin_lock_bh(&btf_idr_lock);
 		btf_put(btf);
+		spin_lock_bh(&btf_idr_lock);
 	}
 	spin_unlock_bh(&btf_idr_lock);
 	return ret;
@@ -8245,12 +8245,10 @@ bpf_core_find_cands(struct bpf_core_ctx *ctx, u32 local_type_id)
 		btf_get(mod_btf);
 		spin_unlock_bh(&btf_idr_lock);
 		cands = bpf_core_add_cands(cands, mod_btf, btf_nr_types(main_btf));
-		if (IS_ERR(cands)) {
-			btf_put(mod_btf);
+		btf_put(mod_btf);
+		if (IS_ERR(cands))
 			return ERR_CAST(cands);
-		}
 		spin_lock_bh(&btf_idr_lock);
-		btf_put(mod_btf);
 	}
 	spin_unlock_bh(&btf_idr_lock);
 	/* cands is a pointer to kmalloced memory here if cands->cnt > 0
-- 
2.39.2



