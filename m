Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BAD30BF68;
	Wed, 20 May 2026 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297641; cv=none; b=H37uzGn8exDb5c/B7+7+ZX73ReGEP28Dc6TMXw7yQ+fPdgKBe/wqKVzsrN+TtmTMV/WW+yPcdk5bvgP3S1Dz9abehhLiMWvbbr9yveONUKFAfig3IwgE4rSHZN8foAIxj9dYNyVQTAEC/+Y65fa2zBJK2Z1tgCsB6lXUgT06pQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297641; c=relaxed/simple;
	bh=kzDLQEI0l0XdNMUELDa8mGJhfigWcTq75bB+1AtU5IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk2vvRp4Ah/Pyn9LGXPhF8rda/MwOGcEQzTr0wGjueakd5J2YEIFr0y26RwC6FGWnBSnI4eVOBmWKn5TsY1EiIhXKBthG7PNoQUEIS8SsTga2JMgCS9X3mt7NWx5DBPSCQrnPI92Q7DQR2BguROWuTqdd/zoWT+ibqAreNS5mI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih7pcpWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih7pcpWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C022D1F000E9;
	Wed, 20 May 2026 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297640;
	bh=SZuAxiadAHdDaPcvfikg+7AgTUtmcx305dPbLiFtRNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ih7pcpWfsorWtEEzU1Q9zF3amGrDdzAJUmBMI6aSMhZWzCkBi8Eg4+DwQuJ+YQyiu
	 /g9Om6MxLqktMlUL+iW4GwEengRPDioqQrT3O4fycBT0a2oBBG3KDrnxXO5j22XoTT
	 WUwYG/hZ93/AGKI+TkRHkNNig/qBdyQr12Gnx3ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Amery Hung <ameryhung@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/957] bpf: Fix refcount check in check_struct_ops_btf_id()
Date: Wed, 20 May 2026 18:09:51 +0200
Message-ID: <20260520162136.903515876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit 25e3e1f1096089a64901ae1faa7b7b13446653db ]

The current implementation only checks whether the first argument is
refcounted. Fix this by iterating over all arguments.

Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Fixes: 38f1e66abd184 ("bpf: Do not allow tail call in strcut_ops program with __ref argument")
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Acked-by: Amery Hung <ameryhung@gmail.com>
Link: https://lore.kernel.org/r/20260320130219.63711-1-keisuke.nishimura@inria.fr
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index db1c591a1da3b..76503ed088b5d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23687,7 +23687,7 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 	}
 
 	for (i = 0; i < st_ops_desc->arg_info[member_idx].cnt; i++) {
-		if (st_ops_desc->arg_info[member_idx].info->refcounted) {
+		if (st_ops_desc->arg_info[member_idx].info[i].refcounted) {
 			has_refcounted_arg = true;
 			break;
 		}
-- 
2.53.0



