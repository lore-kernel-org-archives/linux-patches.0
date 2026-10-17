Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2363890F8;
	Sat, 17 Oct 2026 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260839; cv=none; b=HsPq63Z4Zm2PPa/umOIi+72YJUhgpVWzZJb7Ka2noP8XmUZYgh3DA1TCdWAeAZJTR7lRIi2pIZ2OElyL+hwgkSNVheQ4WK0f0hjQbgOyOEmIy8tvQ1+4RLEBzmicmolmTt+x5Y/dV9Xjj3PmCFKbI6DstDLmuPvqYm5mA4M+V9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260839; c=relaxed/simple;
	bh=zdgAgCxXomXHpyBorD3wyK5tmNU6hUO/cex0Ug+pfRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7qXjGACS8Fh3pJlonXuhz8BePgFiiZWSK7yg8cSEEgwPVqAZLPD7EOc+1n/7nzuORybfsi3HA3l2FKnQWROJJefXP7g242so0mRdl8M8Uei2cVFgnnNGd0NyyNHR1tsLNgL//X+t90l5M7XyBxbno11hPahyHTJxT44paoxDig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKAP8CfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKAP8CfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235151F000C4;
	Sat, 17 Oct 2026 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260838;
	bh=9VqBKF1Uv5CWBhPYByhlZjd7+Z5iUVWiemJHr1dp/w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKAP8CfWMzlaTpLm928LGGYi8T+M+2qoDNFieHQlps4ahfr8B/dGgQQJgceKGcezo
	 7nRL+rml8H1gmUXmbil5fyqNrmSaw2GURJnCuGvAj5/JlOiTGiHYQxFtwWcc9TOxd5
	 sI5/Rfk9kZJgfzHwJ1V+PisJSRpLYyZPMaKeuMg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1627/1674] bpf: Improve JEQ/JNE branch taken logic
Date: Sat, 17 Oct 2026 18:04:59 +0200
Message-ID: <20261017160512.844385247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 42d31dd601fa43b9afdf069d1ba410b2306a4c76 ]

When determining if an if/else branch will always or never be taken, use
signed range knowledge in addition to currently used unsigned range knowledge.
If either signed or unsigned range suggests that condition is always/never
taken, return corresponding branch_taken verdict.

Current use of unsigned range for this seems arbitrary and unnecessarily
incomplete. It is possible for *signed* operations to be performed on
register, which could "invalidate" unsigned range for that register. In such
case branch_taken will be artificially useless, even if we can still tell
that some constant is outside of register value range based on its signed
bounds.

veristat-based validation shows zero differences across selftests, Cilium,
and Meta-internal BPF object files.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/bpf/20231022205743.72352-2-andrii@kernel.org
Stable-dep-of: e51179a4e098 ("bpf: Don't predict JMP32 pointer vs zero comparisons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 044205cf456dd..4493df7e837e5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14087,12 +14087,16 @@ static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
 			return !!tnum_equals_const(subreg, val);
 		else if (val < reg->u32_min_value || val > reg->u32_max_value)
 			return 0;
+		else if (sval < reg->s32_min_value || sval > reg->s32_max_value)
+			return 0;
 		break;
 	case BPF_JNE:
 		if (tnum_is_const(subreg))
 			return !tnum_equals_const(subreg, val);
 		else if (val < reg->u32_min_value || val > reg->u32_max_value)
 			return 1;
+		else if (sval < reg->s32_min_value || sval > reg->s32_max_value)
+			return 1;
 		break;
 	case BPF_JSET:
 		if ((~subreg.mask & subreg.value) & val)
@@ -14164,12 +14168,16 @@ static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
 			return !!tnum_equals_const(reg->var_off, val);
 		else if (val < reg->umin_value || val > reg->umax_value)
 			return 0;
+		else if (sval < reg->smin_value || sval > reg->smax_value)
+			return 0;
 		break;
 	case BPF_JNE:
 		if (tnum_is_const(reg->var_off))
 			return !tnum_equals_const(reg->var_off, val);
 		else if (val < reg->umin_value || val > reg->umax_value)
 			return 1;
+		else if (sval < reg->smin_value || sval > reg->smax_value)
+			return 1;
 		break;
 	case BPF_JSET:
 		if ((~reg->var_off.mask & reg->var_off.value) & val)
-- 
2.53.0



