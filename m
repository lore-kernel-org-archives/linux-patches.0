Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4C77222D;
	Mon, 29 Jan 2024 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548513; cv=none; b=oB0jXfncMwJx8G112lUBIwC+uZIkEER35+wWWfn0+fRurCkIF8kLHwTTlKQbyZIWdINgj8i8+QKTd/1Ft9CikJ2uZIHk7vrbfQnvgVUv+9kzoAZ/I0KPWsIi0lYEBRIy24ctShAes2GKXxKEjdPDP3XEIqmhrS64SY9b50rxQ2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548513; c=relaxed/simple;
	bh=cXjzHb379PvadLdZ9PEf7vYrvjnZdqn5GZT/42CdOtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGhhjTtBhdFHLA8e1Gq3qdiD6itR/2TiVBNzTR5Q/H+e/J6ppVh44fhCzHVsJI5xKicNhO8afX2vC8iZD66mdSPgd6x76plHuS5nNvTRSapdhN2XA66jNtcZaPbSWFTYIJxFqa/8+pdzy0pYhoU8YmUDj19Mb6cIOAe/AZ1GwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RugLGk9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RugLGk9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979F5C433C7;
	Mon, 29 Jan 2024 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548513;
	bh=cXjzHb379PvadLdZ9PEf7vYrvjnZdqn5GZT/42CdOtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RugLGk9whmSR+lA1kDZoO/Kx/Z4R3UGVvtpF2cGaFMDTOKyAbwApSJ6/cx6ndiVGP
	 rZs0K7TJlxEdvthb+mua5s9rd+xHJVdZ8PCiW1grZUzweT3v0vHKxbMe864Mk9Py5X
	 SR9v5kBx7o6Jz/L9FZVCaFDDSyiqz8BST4QFKOwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 146/331] bpf: move explored_state() closer to the beginning of verifier.c
Date: Mon, 29 Jan 2024 09:03:30 -0800
Message-ID: <20240129170019.203990614@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit 3c4e420cb6536026ddd50eaaff5f30e4f144200d upstream.

Subsequent patches would make use of explored_state() function.
Move it up to avoid adding unnecessary prototype.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231024000917.12153-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1786,6 +1786,19 @@ static int copy_verifier_state(struct bp
 	return 0;
 }
 
+static u32 state_htab_size(struct bpf_verifier_env *env)
+{
+	return env->prog->len;
+}
+
+static struct bpf_verifier_state_list **explored_state(struct bpf_verifier_env *env, int idx)
+{
+	struct bpf_verifier_state *cur = env->cur_state;
+	struct bpf_func_state *state = cur->frame[cur->curframe];
+
+	return &env->explored_states[(idx ^ state->callsite) % state_htab_size(env)];
+}
+
 static void update_branch_counts(struct bpf_verifier_env *env, struct bpf_verifier_state *st)
 {
 	while (st) {
@@ -14702,21 +14715,6 @@ enum {
 	BRANCH = 2,
 };
 
-static u32 state_htab_size(struct bpf_verifier_env *env)
-{
-	return env->prog->len;
-}
-
-static struct bpf_verifier_state_list **explored_state(
-					struct bpf_verifier_env *env,
-					int idx)
-{
-	struct bpf_verifier_state *cur = env->cur_state;
-	struct bpf_func_state *state = cur->frame[cur->curframe];
-
-	return &env->explored_states[(idx ^ state->callsite) % state_htab_size(env)];
-}
-
 static void mark_prune_point(struct bpf_verifier_env *env, int idx)
 {
 	env->insn_aux_data[idx].prune_point = true;


