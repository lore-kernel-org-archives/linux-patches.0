Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70AF4EB853;
	Thu, 17 Sep 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659437; cv=none; b=E8R5WU85HjPXkjbSchp2eES3jGbs/wG1mifcHRH/ddrw9ATgfk2uzLvhyPdLxc326lxP77CUyFJ2w0ffR0glN32RQXjy194KF204IHu83eiWoymuGQjqra+hSlqFiNkdLveGzhZP2B85Dv4nreImzdQTNmgzWMUVbfhMYJGrszc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659437; c=relaxed/simple;
	bh=MAqVGiuq8mNgKbMUT7FffHO2Lsn56fnLZkfgoHyKVHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1Kjr0+4UXwymorx9DNdJytd4EYhvVJtiMxE4AKPlXtrs1vCacxJZK9zX5yIfSD8VaffWNh6t0XLyuUq/iId7ER3Bb/2wQHIes9e+SLTnl/cNu53lzC7QY7mS7+5HUlhVsDhTy9tIl+UHcONVDdDceu09yDsJfAhQ7rc+X2YXGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dx9DiUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dx9DiUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602B11F00898;
	Thu, 17 Sep 2026 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659427;
	bh=BOKnLYT7Nk8yTxmO3JA4/oQRbNsbcxPt1w0rispw034=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dx9DiUdJXiectC4fxZwYEOJYVwbwnDrfrVSOdoAB94+q319odsSk10Pj6A9TONn8
	 TufgrwnaFAZP8bl9nPLwjKBbM0+KUq8iXMVgSKjXByndlSvN7oBwtimGUpz/Qn650o
	 sDdSEjc4hzAgcspDrqRtehUa6bJvsjPOai/rhHzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 254/733] bpf: Dont infer non-NULL from a pointer with an unbounded offset
Date: Thu, 17 Sep 2026 16:09:22 +0100
Message-ID: <20260917151357.627157212@linuxfoundation.org>
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
index 96aaa9155e59e..84b05958c3250 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -367,6 +367,13 @@ static bool reg_not_null(struct bpf_verifier_env *env, const struct bpf_reg_stat
 	if (type_may_be_null(type))
 		return false;
 
+	/*
+	 * The types below guarantee a non-NULL base, an unbounded offset can
+	 * still wrap base + offset to zero.
+	 */
+	if (reg_smin(reg) <= -BPF_MAX_VAR_OFF || reg_smax(reg) >= BPF_MAX_VAR_OFF)
+		return false;
+
 	type = base_type(type);
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
-- 
2.53.0



