Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B36B168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BA0C433EF;
	Mon,  8 May 2023 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540584;
	bh=EbnGDtNoRpnCPG2x05i+3QEguP/OCwVEU/NUqughQew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuMuBABdAKz3mucLPPXpoDWtlCrQlP883BednxRVYZHNIztLt5OZOAkZ1x8gFqe0r
	 0NobFnrukK/gNohYw/LjA/r8RFrbwwFBO0xWG3qRH1COLIxezUGIFprIif3PUT67R5
	 7u/534tcX4z11u8ru+mw7MhMc59HtExEqWSlIpQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 387/611] bpf: Fix race between btf_put and btf_idr walk.
Date: Mon,  8 May 2023 11:43:49 +0200
Message-Id: <20230508094434.881071583@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index a83a3f2745561..a8838a32f750e 100644
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
@@ -7957,12 +7957,10 @@ bpf_core_find_cands(struct bpf_core_ctx *ctx, u32 local_type_id)
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



