Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4DB357D09;
	Wed, 30 Sep 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794266; cv=none; b=GHiFrTmDFP6ibb0NtrmfQc+t3WnbjbE+lZwcBwz5gm6jsidaTDjqIHqpZ0fz4hhRh6xy0LCxSVfE5ya7t8mSJkKDbno5FOKJUAumjqDxZAyYYn5LaEo/ZYINuMMIzOhLekIQkiktyBAwrUt3aoTAQQfXzDcu98MnuvKF3Zw8/Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794266; c=relaxed/simple;
	bh=gGwoeZwAPoJ8BhrgUn+NQXIGBFNXDZkz9+O6u0snybg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrrCefTKwHUCzH4EWITQzQZJGaPKXARECwY0gky1txXooQ72SCnUwFXuRc8IkKfPr5Enwjadjt7TTJtRBdsQQkFLrP3xAEqmBeCC5mE0CcN39Y3AoVE0B4ubZIYjMA4WCxK1ySDvcnlxk6lLiXjpCTTh8FhImfiL+sFXa+41E+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Q/Dg/Xi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Q/Dg/Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95DC1F000FF;
	Wed, 30 Sep 2026 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794265;
	bh=H9qrrHW1MZWgjPHub00aniLNlVaZHiBvdV20Ecd0cdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Q/Dg/Xi98nTQCOVKS+vrqk1KurVXDTBViZIqNdxFVyfcvTah1lkaPhOK8HK6UxPQ
	 ls4j+BBcdJhXvK76W0Ed23tWp9RKLF3HQcPm9Ic8c12LtEdkAsWzvipQsOtJ2VDGZZ
	 CeqY0ruiaVh+OdGZrZIYjweMHAN3Cg8tkBXUCO+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0148/1193] libbpf: Also reset {insn,data}_cur on realloc failure
Date: Wed, 30 Sep 2026 17:13:52 +0200
Message-ID: <20260930152437.496265873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d2f7bd066ed492aeaf82864fbf1f06770f9d9f9d ]

realloc_insn_buf() as well as realloc_data_buf() free and NULL
gen->insn_start / gen->data_start on -ENOMEM but leave gen->insn_cur /
gen->data_cur pointing into the old, freed buffer. Just reset the
cursors to NULL alongside the base pointers so the freed state is
coherent.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260529094119.307264-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index cf3323fd47b88..a3fd073b16c8b 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -63,6 +63,7 @@ static int realloc_insn_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->insn_start);
 		gen->insn_start = NULL;
+		gen->insn_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->insn_start = insn_start;
@@ -86,6 +87,7 @@ static int realloc_data_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->data_start);
 		gen->data_start = NULL;
+		gen->data_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->data_start = data_start;
-- 
2.53.0



