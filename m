Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FFA153800;
	Fri, 15 Nov 2024 06:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653397; cv=none; b=glViqUUMC1wh1KV1XOu+R7/ZVQj2Ui5QUZGMCKUk1ZscTOFUh+ZIO31CckgVpMOjTJbuO4XPPvJLvEREzkox820B8zzh4Tl8Wh+ZoekCkssGHfaWutGg2uNwlwTdH0i4EX7G3JycGHG9J4EmaO55LJPEJGgMVXICW94zHnKZYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653397; c=relaxed/simple;
	bh=bff7fT8gCg60q5GDyot6teOO5ISc32H1FTwv22RLrZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxRzZcNR8nCIqM8ZeN3s+eCHudLLmG9GNqctute+iO6kZ84XYG+2QGSsQB0Yui4pBoeMj8LeTHFfq4uYlxhW9vsegyp/K5KsrcSnnG+BVXKofDwSe4d/sr1C3umPqDziYmmHg3eACuhaXvVjcodXDoMCPg9y63nMru6pHxJtzQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/E2YVdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/E2YVdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0ECC4CECF;
	Fri, 15 Nov 2024 06:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653397;
	bh=bff7fT8gCg60q5GDyot6teOO5ISc32H1FTwv22RLrZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/E2YVduEBHIhS5eI/RcwLNV+nHcwGf4xzgFp9Q4byh2bb7lNcRHMeuXrPkWwRoTA
	 ddX8B7iSpY/58pYflgdnjOr3aC5qboy+S6Qab4hLkKj0vzJo640SvjWLu20JG6175n
	 fNCHrjbN4lIrw6FeqsW7yQ/4+LbCPZFdQz/+FOv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/48] bpf: use kvzmalloc to allocate BPF verifier environment
Date: Fri, 15 Nov 2024 07:38:00 +0100
Message-ID: <20241115063723.371127393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 67eb55a354bcc..4f19a091571bb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20230,7 +20230,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr, __u3
 	/* 'struct bpf_verifier_env' can be global, but since it's not small,
 	 * allocate/free it every time bpf_check() is called
 	 */
-	env = kzalloc(sizeof(struct bpf_verifier_env), GFP_KERNEL);
+	env = kvzalloc(sizeof(struct bpf_verifier_env), GFP_KERNEL);
 	if (!env)
 		return -ENOMEM;
 
@@ -20450,6 +20450,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr, __u3
 		mutex_unlock(&bpf_verifier_lock);
 	vfree(env->insn_aux_data);
 err_free_env:
-	kfree(env);
+	kvfree(env);
 	return ret;
 }
-- 
2.43.0



