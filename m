Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902871339A4;
	Fri, 15 Nov 2024 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653107; cv=none; b=Rudgvr4UcqPuYkmh08u3fyfdNJHJPr42H/x+dIWN7Hf7VVH3gzsmPTeHOAYjtWF4mSYso85fQOj6EkRFdtKtn/LmVK5e8yc8JvzqRVBUlDlZH6o8DvIDK/J5bYwfLlQHAUWcz/gm6G4A0z4WLfktulaDov9QrG5gPWSx6c4ZO+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653107; c=relaxed/simple;
	bh=Cj6oOSDX/WevsPYF14SGFkW6BnmDOu3LLmY4JIYfDUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rrk/tZxzL3YVoAFAfxitvGZEsjbDnPSx0AKei0diJzg0a2y+ZG6GGqHmFuY4YQT7THbNxSBo4aSozxRwsyCxfxKvWVPc2XOdJgWRrc1nfksGuGIzNTmD7IT1GQWYVrqGtVXt4g54heQ39ouHMlFps+BONcEz3wUxfcN68toy5e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpRzTUI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpRzTUI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AD7C4CECF;
	Fri, 15 Nov 2024 06:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653107;
	bh=Cj6oOSDX/WevsPYF14SGFkW6BnmDOu3LLmY4JIYfDUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpRzTUI4WxZFM89v+xgr/15l0j8+8SJnp9FRV0H8VlDFm3tLzmPqyZ3OK15HCoJ4c
	 ahAw0BTh3dPpSHtc1LnPxZPpowOd6/Jo+TNez84NE3YKYq0euaj0knSnmA6nbvisFy
	 +i9U+DTn7AO+iVi7oGfVQgEu3BCcR8yxjvtRnnJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/66] bpf: use kvzmalloc to allocate BPF verifier environment
Date: Fri, 15 Nov 2024 07:38:05 +0100
Message-ID: <20241115063724.864390444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0901911b42b56..013b9062c47c3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9558,7 +9558,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	/* 'struct bpf_verifier_env' can be global, but since it's not small,
 	 * allocate/free it every time bpf_check() is called
 	 */
-	env = kzalloc(sizeof(struct bpf_verifier_env), GFP_KERNEL);
+	env = kvzalloc(sizeof(struct bpf_verifier_env), GFP_KERNEL);
 	if (!env)
 		return -ENOMEM;
 	log = &env->log;
@@ -9728,6 +9728,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		mutex_unlock(&bpf_verifier_lock);
 	vfree(env->insn_aux_data);
 err_free_env:
-	kfree(env);
+	kvfree(env);
 	return ret;
 }
-- 
2.43.0



