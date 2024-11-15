Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE17818871E;
	Fri, 15 Nov 2024 06:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653908; cv=none; b=shU8juSmkQdjx1C6d88rY6qmao9hIVMEREzIVrCx5bow5n80HVY7TdPp0yv6/6Y6IFlG3x/Vk6BB1J2U0j0VyeuKRU3Yx7L2m2LW4Qpl6RygWGvQ3n8LgfsKKzlW+uSEHOcFd2zFOZxr0oGJNZTJF6Q5jIKxJaBX8msYEsetTHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653908; c=relaxed/simple;
	bh=vf9qysD/ykRUCiUoQOBo2ocaKTcPbip+4dqEtorSf7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hD1LNGFgjrZNAJHbvX5Tv34UHzmDLcXCQxrMhCB/nsFnfqCo7k2QmiD5qaTpHgBID4PWO2AFkZu8lguP+XYOCQNnJ6bMGLIDGTGGM1nwPm6PuH94tvXFpzoplt4qBo26WL/MyTlOJJK05cz/6qikGEUSf3lyhJOMgpDqhNuwH2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4dw3wxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4dw3wxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEBCC4CECF;
	Fri, 15 Nov 2024 06:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653908;
	bh=vf9qysD/ykRUCiUoQOBo2ocaKTcPbip+4dqEtorSf7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4dw3wxf0vlXWFox02V1o6MAfcElV3NcXzORuDmvBAGNBGZSAb0b8ks5O/q2Jpgoe
	 gXEwNTTkrADmfkR2epKPOvL+kBYB0FkwecwAOBljERq5m31TyXX9k/AeRtHob7DouU
	 v0kEBk93oOv3ezAlQcO0rD3mvV7DFpSIfHQFQApc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 72/82] bpf: use kvzmalloc to allocate BPF verifier environment
Date: Fri, 15 Nov 2024 07:38:49 +0100
Message-ID: <20241115063728.143626145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 434247637c66e1be2bc71a9987d4c3f0d8672387 ]

The kzmalloc call in bpf_check can fail when memory is very fragmented,
which in turn can lead to an OOM kill.

Use kvzmalloc to fall back to vmalloc when memory is too fragmented to
allocate an order 3 sized bpf verifier environment.

Admittedly this is not a very common case, and only happens on systems
where memory has already been squeezed close to the limit, but this does
not seem like much of a hot path, and it's a simple enough fix.

Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/r/20241008170735.16766766@imladris.surriel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 60db311480d0a..931611d227369 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12564,7 +12564,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	/* 'struct bpf_verifier_env' can be global, but since it's not small,
 	 * allocate/free it every time bpf_check() is called
 	 */
-	env = kzalloc(sizeof(struct bpf_verifier_env), GFP_KERNEL);
+	env = kvzalloc(sizeof(struct bpf_verifier_env), GFP_KERNEL);
 	if (!env)
 		return -ENOMEM;
 	log = &env->log;
@@ -12755,6 +12755,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		mutex_unlock(&bpf_verifier_lock);
 	vfree(env->insn_aux_data);
 err_free_env:
-	kfree(env);
+	kvfree(env);
 	return ret;
 }
-- 
2.43.0



