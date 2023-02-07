Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B02919
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9C5C433EF;
	Tue,  7 Feb 2023 12:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774766;
	bh=65hwGgIvCMkExfJRsYVu7I5nLGI+k6SS/gP9hroCNis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW+eQmzh1XC7ZWAhRW2ugEbO5vFdE7vMCRqbm952AwTc64oUbLPkX7IEyjCfg21C4
	 KNuhBVRVRdJ/uEXZxYtvVXa8y0hKnazkxo3IlIEk4aQeeEq0a0tmxPxkURwKWlOT8L
	 mOkbkD+l1vQv58LdQudR38Hv1FHmh5yvdVWMxprw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/208] bpf: Add missing btf_put to register_btf_id_dtor_kfuncs
Date: Tue,  7 Feb 2023 13:54:33 +0100
Message-Id: <20230207125635.190907823@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 74bc3a5acc82f020d2e126f56c535d02d1e74e37 ]

We take the BTF reference before we register dtors and we need
to put it back when it's done.

We probably won't se a problem with kernel BTF, but module BTF
would stay loaded (because of the extra ref) even when its module
is removed.

Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Fixes: 5ce937d613a4 ("bpf: Populate pairs of btf_id and destructor kfunc in btf")
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230120122148.1522359-1-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index efdbba2a0230..a7c2f0c3fc19 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7607,9 +7607,9 @@ int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_c
 
 	sort(tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func, NULL);
 
-	return 0;
 end:
-	btf_free_dtor_kfunc_tab(btf);
+	if (ret)
+		btf_free_dtor_kfunc_tab(btf);
 	btf_put(btf);
 	return ret;
 }
-- 
2.39.0



