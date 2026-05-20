Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A62BE02A;
	Wed, 20 May 2026 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294786; cv=none; b=U0iCP3MUVl4W1+Ls9Vpe9Ux0Es5h37CtlPwBsBOALAGacGN/1h2/EjLQhmQp/cvRf9+fWncD1gUziI54Rmnf1LVMOUZBj2gK4qvFUjxWTIGnjqW+ihnOqRGh7lCx7ClUjKBP2Ribiop8rzxq1kE9JqWKQG+lFbOjTtqZiRy+Cbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294786; c=relaxed/simple;
	bh=X+SOnrVgkrH6izXsVbOE63MvZzaYhMGy0XmPDq1E84I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwO/HIi4j7Gce/Vxw+i+1GTuwWvvlB3nT1JiNLFBdsRkhgv4ASVZxjRIsvfSi9vKdw0nFBRgSCFWKTCY74PzlHWNJ2X9PrR2ETEUQ42OCGt2NLuPuI6CFxddVsPtVNuYp0HWh0mLlyh2I4bRLQjmhTgj0Nyq2qr9KH9Yb6J8Vq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWn/H62E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWn/H62E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E8E1F000E9;
	Wed, 20 May 2026 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294784;
	bh=Myzlm5m7UybRV0YKv5Pi6oUlZ2OTYyXMZ3eRZRk1WnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWn/H62EW/bOY4XInkFrn4uth/Ws3TfYxikmlQb3ki10wQxJJ8JEFZfV0hjxP1J3d
	 bODoJ1OjJIQJbSPvNd/EOMxUiaspqEfNmJFgEjljUR9o5elzUd9U9+bAStG9N/0Pie
	 bV+RQQZH/mh2zaDJ6fk9EGoIRNWz3mTBCKeZWmWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Amery Hung <ameryhung@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0131/1146] bpf: Fix refcount check in check_struct_ops_btf_id()
Date: Wed, 20 May 2026 18:06:21 +0200
Message-ID: <20260520162151.290315836@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e3814152b52f8..23b35605ae377 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24897,7 +24897,7 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 	}
 
 	for (i = 0; i < st_ops_desc->arg_info[member_idx].cnt; i++) {
-		if (st_ops_desc->arg_info[member_idx].info->refcounted) {
+		if (st_ops_desc->arg_info[member_idx].info[i].refcounted) {
 			has_refcounted_arg = true;
 			break;
 		}
-- 
2.53.0



