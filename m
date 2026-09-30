Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EA65158B7;
	Wed, 30 Sep 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786996; cv=none; b=Hd6Y/6DWpUco99Y330ZNFTO6R67zeSdQueVSTvKlrVBXppixdle2CDqApij5LLTdN8voL/n/ATRU0ptl/6O2t5oUyYDyMFIFPyOjlUq016jR3TdTnSdXS8hvSRJwGSA6Qs/HImCPWut0sLgAwIa6ZSPkH7XQ23BsLIUVBUaE7LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786996; c=relaxed/simple;
	bh=SNWDUOBRtK2LowiUs5HLBc0R0PYLco9iJLGsPA2lPBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkHIf+yQ/yct26hgyp7DbTtmc9K+hr6k1eEp3WzRLsrrAo3eVpkjMBr0zymVDIcVkT+YN/QVuarbUVLs4GY2NxCXB04N5G3HkZv2kuX/QU2QUJeMIu+PC2WUK0hDBBV4NzBX7dgCztBBjBDnXkMBp0iBiOkJu0BhH4+ZSWYXlZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Bc/9MOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Bc/9MOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9FD1F000FF;
	Wed, 30 Sep 2026 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786995;
	bh=bV7V6/Zx3j7cQskrDN9B2jVC+f0ZdmSZKIkgTpZ6NwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Bc/9MOLod9hytxDxElZVxJ/67AGg6G87oRNQ7/K81GY6IU8VSFm2Zbga6XfcB82M
	 vSnDrRFyBg/jxIjB94Bv78/U4QlCE32I1lHoSMVvMb0Fg+CFrRppIk2mHxJWgr6Rz/
	 C36aauLNn3SvuYAe0vzlEuc+53kN5q4AguJ5YbBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 076/457] bpf: Preserve packet pointer class displacement in regsafe()
Date: Wed, 30 Sep 2026 17:23:01 +0200
Message-ID: <20260930152347.690183096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

[ Upstream commit fd16449a9b3b31a8f18944c2f0e29e4e218ca2cf ]

regsafe() maps packet pointer IDs between states and checks that each
current register range is a subset of the corresponding explored
register range. It does not, however, preserve the displacement between
registers that share a packet pointer ID.

This is unsound because packet range is shared by ID. A bounds check on
one class member updates every member, and a later access can consume the
range through another member. Commit 022ac0750883 ("bpf: use reg->var_off
instead of reg->off for pointers") folded the fixed pointer offset into
r64 and removed the old off equality check, so two individually narrower
registers can prune even when their displacement has changed. The
explored path can then license an out-of-bounds packet access on the
pruned path.

Require matching range bases for packet pointers with an ID. Together
with the existing ID mapping, this preserves the displacement between
members of each packet-pointer class without adding per-ID state.
Packet pointers without an ID remain unaffected.

Fixes: 022ac0750883 ("bpf: use reg->var_off instead of reg->off for pointers")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260917233222.2542500-3-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/states.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index 66fb11b6c6a76..6c88ad95b63b7 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -635,6 +635,9 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		/* id relations must be preserved */
 		if (!check_ids(rold->id, rcur->id, idmap))
 			return false;
+		/* Preserve displacements between pointers sharing an ID. */
+		if (rold->id && rold->r64.base != rcur->r64.base)
+			return false;
 		/* new val must satisfy old val knowledge */
 		return range_within(rold, rcur) &&
 		       tnum_in(rold->var_off, rcur->var_off);
-- 
2.53.0



