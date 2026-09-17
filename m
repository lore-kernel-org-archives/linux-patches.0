Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34251AEFF;
	Thu, 17 Sep 2026 17:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665672; cv=none; b=g8Tdamz+65ay89CGpSFDmuQf7+1OaJY54TtoKG4hK3IzN1xu02hQALBGu/bu8Uvyc+gbKX0Cu065DZr6huROWNMY78XDnpMi3Re8uCCMJvxRZhbB8TB/w3ptD8oMxLGO0j4xSg6mQslUayWXhzJAjCudB70xD7mXmrPCNaBcRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665672; c=relaxed/simple;
	bh=ueX6gP+S/D3JlCir3lvhjXXvROl6wAl5DBLt61hFRcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9ZGdzcbJQu/uJxRoNZmvFHqk+itaWvF2LZGeyKS6jK1rbNxWZoCPZ6bueqc3arEtzeX40QbMe9fHjQaM8VhfI6CHFJLT7vOvoNBRSsSnknkozOe5fso28zV0L0sEmvMWGd5JjAt8j/SysrVsK0jp460es/avsIS6Ja3B0VfuYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QScJVSl2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QScJVSl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAD91F000FF;
	Thu, 17 Sep 2026 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665671;
	bh=8I5zWp6/4Pou4TS+OKXNeokeXJ5HMExlzchEULrRFmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QScJVSl2Lp4JsQs0fEdFisl+na+QimPkXOzvtDhFiVLJ/XrHY9wnda0GkivnAgoUO
	 sOjlaxw32J5VVg8ohHhHI59UU5JWhq9nKHqQQ/CjuhjRllhthXRbbnapRTgKR/kwKs
	 B9TOAT1Kxn5gsaV3sNCpa0vWC3Z08PsTNU1Qx0/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0783/1250] bpf: Require MEM_PERCPU for percpu kptr stores
Date: Thu, 17 Sep 2026 16:09:38 +0100
Message-ID: <20260917151613.115127874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index e0ec0f47febeb..bef18a2cc95a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5889,6 +5889,13 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
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



