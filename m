Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA967224F;
	Mon, 29 Jan 2024 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548514; cv=none; b=e4BhVtDUpKbYN27+2eqZB1iT1MtFRsXSEC2PhyoHTY00OO1CQjDw3JIP0vWR7I4nWPWw9nJ6s3z8bKuTXJj11EXAHHWp+T3UsfnqMwbmSeyOksQkJsGpa8VWjmDmcURz/ISdzIAcyXFDleENd+ohXoc0LR5z1CsTHEse4h1uGt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548514; c=relaxed/simple;
	bh=6EyYty3BXv1MCbazAoi8aZ4Bl6rH2nLtDOnpYtqiwQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/jd1uyKXrXQ2sZaOgMKf+lYfQvx4GwbrdvcdemwydvnRqgH7F+eX2WazXTHSQ3G/glMndHqsGL3ZqeL5RP3dAmhbw4HwBShml6CPt9ymvjS3lDRuDeictsf1LwV4BlLKooSIxyJMfegmgOF+oIdjp4Mz4Rc/5EFRofMdOhtRYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxOYaCeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxOYaCeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A5EC43390;
	Mon, 29 Jan 2024 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548514;
	bh=6EyYty3BXv1MCbazAoi8aZ4Bl6rH2nLtDOnpYtqiwQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxOYaCeFH7ys2H1O4mnOaS3Xh98XbMWIGmzMPHLS6xV3SiVWXrMWFdnxaI1PAz3Uc
	 mHKVlFAmvD8y+ZU0VPZsMAoPUJO+fG1ViFED3EsrRswWMXwVF+0e4cDXb8w2FaOBTW
	 njLhxnB3+jEyE43b4dpIz3UD4knsUZy9Db2SHuWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 147/331] bpf: extract same_callsites() as utility function
Date: Mon, 29 Jan 2024 09:03:31 -0800
Message-ID: <20240129170019.231770865@linuxfoundation.org>
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

commit 4c97259abc9bc8df7712f76f58ce385581876857 upstream.

Extract same_callsites() from clean_live_states() as a utility function.
This function would be used by the next patch in the set.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231024000917.12153-3-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1799,6 +1799,20 @@ static struct bpf_verifier_state_list **
 	return &env->explored_states[(idx ^ state->callsite) % state_htab_size(env)];
 }
 
+static bool same_callsites(struct bpf_verifier_state *a, struct bpf_verifier_state *b)
+{
+	int fr;
+
+	if (a->curframe != b->curframe)
+		return false;
+
+	for (fr = a->curframe; fr >= 0; fr--)
+		if (a->frame[fr]->callsite != b->frame[fr]->callsite)
+			return false;
+
+	return true;
+}
+
 static void update_branch_counts(struct bpf_verifier_env *env, struct bpf_verifier_state *st)
 {
 	while (st) {
@@ -15521,18 +15535,14 @@ static void clean_live_states(struct bpf
 			      struct bpf_verifier_state *cur)
 {
 	struct bpf_verifier_state_list *sl;
-	int i;
 
 	sl = *explored_state(env, insn);
 	while (sl) {
 		if (sl->state.branches)
 			goto next;
 		if (sl->state.insn_idx != insn ||
-		    sl->state.curframe != cur->curframe)
+		    !same_callsites(&sl->state, cur))
 			goto next;
-		for (i = 0; i <= cur->curframe; i++)
-			if (sl->state.frame[i]->callsite != cur->frame[i]->callsite)
-				goto next;
 		clean_verifier_state(env, &sl->state);
 next:
 		sl = sl->next;


