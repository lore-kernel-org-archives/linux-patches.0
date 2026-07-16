Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BB1436BE1;
	Thu, 16 Jul 2026 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212153; cv=none; b=OJRT5jeKaHEN0H1f6OsgZ//7gPCkzq2t5b531d0VtC01OzH79QpEMFokBVaw2+n41Ix+I0tFnqVeROYOaxwgr5Ns6iLnWIgJlibS3ty9beNoP32IO30P35oPzug9YA0ExzLI3/ZuU3/2/ehZA4Zy/6t/mkUXu8N0jU5AZ5a0vbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212153; c=relaxed/simple;
	bh=d9r0E56TGxyhgUo3gt97GUBArKDIkR05AoCihytbK8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLySydFIHTARI0Kurpus+iQqC6fkVZmCVYFdgecI+SbRSis774byNeh0zeBuJ7S+LSyHu4sJ4wwZi1hxLuoMFwgj/z/TkoWG7I1BWG7lhf/Feo0TwjjZKQ5PReh8vwO/jAmCnnO/qmNrQhjI6H40rY0UCUISFZIHkZqJBeAzNpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+w2udgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+w2udgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7D51F00ADF;
	Thu, 16 Jul 2026 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212152;
	bh=U7tD4PBGVZnohviLgIBH8lyXEAzYry4xnmPwFCdFm8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+w2udgfU7cwrUf0IrsCt0wJaG+nMgT3RaLEiQNZsJj3jPZR8hPLPBjgRN5nA9IQc
	 z1zPZfw4XklDQDdHJyFZw6u56+5c1mvlr23Jwb1+ZlcoH+Psv6Oig3PGt3XpTLjERe
	 CNPVF0dNEBryhn5kAwX3qtVMgaXd9AdZQh9yk/mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 6.12 218/349] bpf: Validate BTF repeated field counts before expansion
Date: Thu, 16 Jul 2026 15:32:32 +0200
Message-ID: <20260716133038.241269074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3530,7 +3530,7 @@ end:
 static int btf_repeat_fields(struct btf_field_info *info, int info_cnt,
 			     u32 field_cnt, u32 repeat_cnt, u32 elem_size)
 {
-	u32 i, j;
+	u32 i, j, total_cnt, total_repeats;
 	u32 cur;
 
 	/* Ensure not repeating fields that should not be repeated. */
@@ -3547,10 +3547,9 @@ static int btf_repeat_fields(struct btf_
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


