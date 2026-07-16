Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8972FDC53;
	Thu, 16 Jul 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211170; cv=none; b=ZPMbWOZJqK23Gf7lk3Bn21fhB2116VzUYsjkLlzDijNyK+ujIPi89i/MBoNr84YdzaEdH8s8DOd3xjOLoJsYRFvFx4/aW03ytrcgm4FEO+J2G79hDSHM5xXwB2lVBJML8Ye9X8+cO36UNGkgIv6ON91ew5rs5qteq99AH+MYkmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211170; c=relaxed/simple;
	bh=aARZtZ3fpsOkyRp9AkXQM07AAea6N6/gpQycKGM4Hhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiB36g6Och+Z1/0+rcJG8e1i3pR8zKfjjMzssUe5jGCDsj3JxXmcR2xnAj8a5PkNeJPgYtxf1ESdp/Ys3m4U8X/fquons7ChtcQe7oUmuA3jmkIeft5K/1rjxKDWqJtFvAAd78hciPfrfzXEQZprr0TlG596orDJtAfpxFrqAzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+KG4Myd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+KG4Myd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313FE1F00A3A;
	Thu, 16 Jul 2026 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211169;
	bh=UI6+kKJ5aqAOJ534mcU5+e3DdV83FIKy3QRYJOdKBcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+KG4MydkkV5ja2Ygozn+DRSeH9GXUXr4UGiP//J4XxPQt6Y7kTXNf8ku4mnOrpVG
	 YPIW4R9kX/kqBokDaJjGmLYS8ERjGNAcl4soFQVK+B5ovJy2i82DFjeBjjmRxd/Jsg
	 czZ55Gi3dYBClmtkF18dbnhCZP8AAAdjatEdqlGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 6.18 282/480] bpf: Validate BTF repeated field counts before expansion
Date: Thu, 16 Jul 2026 15:30:29 +0200
Message-ID: <20260716133050.928533848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

commit b9452b594fd3aecbfd4aa0a6a1f741330a37dab7 upstream.

btf_parse_struct_metas() walks user-supplied BTF during BPF_BTF_LOAD,
and btf_repeat_fields() expands repeatable fields from array elements
into the fixed BTF_FIELDS_MAX scratch array used by btf_parse_fields().

The remaining-capacity check performs the expanded field count calculation
in u32. A malformed BTF can wrap that calculation, causing the check to
pass even when the expanded field count exceeds the scratch array
capacity. The following memcpy() can then write past the end of the
array.

Use checked addition and multiplication before copying repeated fields
and reject impossible counts.

Fixes: 797d73ee232d ("bpf: Check the remaining info_cnt before repeating btf fields")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Moses <p@1g4.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260605234301.1109063-1-p@1g4.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/btf.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3550,7 +3550,7 @@ end:
 static int btf_repeat_fields(struct btf_field_info *info, int info_cnt,
 			     u32 field_cnt, u32 repeat_cnt, u32 elem_size)
 {
-	u32 i, j;
+	u32 i, j, total_cnt, total_repeats;
 	u32 cur;
 
 	/* Ensure not repeating fields that should not be repeated. */
@@ -3568,10 +3568,9 @@ static int btf_repeat_fields(struct btf_
 		}
 	}
 
-	/* The type of struct size or variable size is u32,
-	 * so the multiplication will not overflow.
-	 */
-	if (field_cnt * (repeat_cnt + 1) > info_cnt)
+	if (check_add_overflow(repeat_cnt, 1, &total_repeats) ||
+	    check_mul_overflow(field_cnt, total_repeats, &total_cnt) ||
+	    total_cnt > (u32)info_cnt)
 		return -E2BIG;
 
 	cur = field_cnt;


