Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059264DDB41;
	Thu, 17 Sep 2026 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659447; cv=none; b=BeygpX/jRUjxDIiK6xMdN7KB7y0F7zRFH1PXqAo/Y2nJ4u2AVf4afiecPhv7JoRmvTNrXd3YaXNftGhPvc6VS+4njOdUEXAJhnb1kg9moXhSGXVfwSlkH9TX3+A7X3OEndU5BCAHGNjL0uy/elGB/9sZAIeTiWdiA7lpEhTOCng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659447; c=relaxed/simple;
	bh=lOCxMxObiCXBXoIW+tNRuvL1DEFpfD5aVxgmV9RZa5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJmZBiniP+ICZEhPMqirovudtWlh173KE/iYzUE9x5KBS8r4tPgx9Rpz6thBL0w+967L+Lor/pH8c2We9dUT9J8Vn+Z9M6sAIRVJpzy12+AgJ2zakIidNct5LMrG3XdmsU6ZsGQpmzhGgT0fjP2ZdvcgLLunBVSF80PmKWhI2xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdY4E+rk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdY4E+rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD5F1F00898;
	Thu, 17 Sep 2026 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659442;
	bh=dmh4+qRFo4qcY/ZhYTYqoGybP+TEq0MrARjD3sZWlRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdY4E+rky2+H1KEqgMSQTH7cRDq95+80ScygC5q59ddpjDWmwy4tjTP6sj0orVKSJ
	 iIWUq7Ul0CaWeckxuWg4IL5RBgmwK+aLqfBTfF5R0dZ0sADeiNu1eOuNGwWI+PDV3d
	 8lWA+CxR8JUWKzNkTTe2lbV7ys8w4jPOHD8BE5VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 259/733] bpf: Require MEM_PERCPU for percpu kptr stores
Date: Thu, 17 Sep 2026 16:09:27 +0100
Message-ID: <20260917151357.766868209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 048029ba1c793f8cabc4ad5eea765da01903f8f1 ]

map_kptr_match_type() treats perm_flags as the set of register type flags
that a kptr field permits. Adding MEM_PERCPU to that set for
BPF_KPTR_PERCPU does not require the source register to carry it, however.
The subset test consequently accepts both a plain bpf_obj_new() allocation
and a referenced kernel pointer into a __percpu_kptr map field.

Loads from the field are always marked MEM_PERCPU. Consumers then treat the
stored value as the cookie returned by bpf_percpu_obj_new(): per-CPU pointer
helpers relocate it, and map teardown selects the per-CPU free path. A plain
allocation can therefore provide an arbitrary kernel read/write, while a
kernel pointer can be relocated into an invalid address or sent through a
missing destructor.

Require the source MEM_PERCPU flag to match the destination field kind.
This preserves valid bpf_percpu_obj_new() stores and rejects both the
program-BTF and kernel-BTF variants.

Fixes: 36d8bdf75a93 ("bpf: Add alloc/xchg/direct_access support for local percpu kptr")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904084325.52250-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f913e3603a5ea..6d66a5dbf8dff 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4320,6 +4320,13 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	if (type_flag(reg->type) & ~perm_flags)
 		goto bad_type;
 
+	/*
+	 * A BPF_KPTR_PERCPU field is read back as MEM_PERCPU, so the value
+	 * stored in it must carry the same flag.
+	 */
+	if ((kptr_field->type == BPF_KPTR_PERCPU) != !!(reg->type & MEM_PERCPU))
+		goto bad_type;
+
 	/* We need to verify reg->type and reg->btf, before accessing reg->btf */
 	reg_name = btf_type_name(reg->btf, reg->btf_id);
 
-- 
2.53.0



