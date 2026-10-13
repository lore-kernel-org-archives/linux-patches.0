Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B484EF154;
	Tue, 13 Oct 2026 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894303; cv=none; b=Q60le3OLrLk4GiF+TzYAEH4oQB8ibP67TMa6cSjhUxkiQiTmaj4CNyUU1pY4/6TdGD2w2Sbyqu4DI7lHXbs3z32P+VJBbEJjd1HXTjXUHK7BMl4MOWAqjel9PB46DYRfhYSX9Q3rpWURD5UygzT50Ncn3JDSHzPG+h6rnIFEhIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894303; c=relaxed/simple;
	bh=v5/lML4y582aNGEpiYzgt+5evK0R41QYr9plKkaAu7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3Yq7EBVnKPqIxgVFNkGf+QjjPlwkIRmwqGxni+qEetUeVPYvNo93zW//QoA9QYHcCchtYWVVximHX+pr119syKZxS3iCYoN71xGAQFMiWgu+GH3BxOBGAL34Nf+FldoIA223cZQXqZycF10ovsXvsSy2FkOUPiL9DvK3j0PUUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgaAPNkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgaAPNkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1461F000FF;
	Tue, 13 Oct 2026 12:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894302;
	bh=qjC67kzRwzoZVWCxlnxyMrfs4wayh6q6QTsmxKMseV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgaAPNkECaKfBmv0PYDLluYO3ZLPe9hF+zY641lpjKSN1xzBYr0m7+ZuWNmB69uNB
	 Bf6MrNbIwbbjOLoSelSwS9jIirRTdjlppwp5CNYHywzzOVnyvYivvxLbfp7uHoRIvj
	 I/cxqHgn+2+I5c6+emvwsAgK8NitBKYmkO/9US1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/621] bpf: Dont infer non-NULL from a pointer with an unbounded offset
Date: Tue, 13 Oct 2026 13:38:29 +0200
Message-ID: <20261013112933.023415250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 67b529f521a6676cdfc78b91b0217d7eaa84216b ]

reg_not_null() decides that a register holds a non-NULL value by
looking at its type alone. For pointer types that allow arithmetic the
type only guarantees a non-NULL base, in case of an unbound offset
the runtime offset value might still add up to NULL.
Consider the followng program:

  r6 = bpf_map_lookup_elem(map, &0);  /* present */
  if (r6 == 0) return 0;
  r7 = bpf_map_lookup_elem(map, &1);  /* absent, NULL at runtime */
  r8 = r7;
  r8 -= r6;     /* pointer - pointer: unknown scalar, -r6 */
  r8 <<= 1;
  r8 >>= 1;     /* any non-negative offset is accepted by */
                /* check_reg_sane_offset_ptr() */
  r6 += r8;     /* verifier: map value;    runtime: zero  */
  if (r7 != r6) return 0;
  *(u8 *)(r7 + 0);  /* r7 is inferred non-NULL, both are zero */

At runtime both registers are zero, the comparison is true and the
load faults with NULL pointer dereference.

Require the offset to be within +-BPF_MAX_VAR_OFF in reg_not_null().

Fixes: cac616db39c2 ("bpf: Verifier track null pointer branch_taken with JNE and JEQ")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260904083325.2083493-1-eddyz87@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9ed6a1298a8ec..0e9218f74cf3c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -405,6 +405,13 @@ static bool reg_not_null(const struct bpf_reg_state *reg)
 	if (type_may_be_null(type))
 		return false;
 
+	/*
+	 * The types below guarantee a non-NULL base, an unbounded offset can
+	 * still wrap base + offset to zero.
+	 */
+	if (reg->smin_value <= -BPF_MAX_VAR_OFF || reg->smax_value >= BPF_MAX_VAR_OFF)
+		return false;
+
 	type = base_type(type);
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
-- 
2.53.0



