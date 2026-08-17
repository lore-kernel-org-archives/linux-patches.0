Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8916E43CE51;
	Mon, 17 Aug 2026 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974767; cv=none; b=n08cH7jCYFMmVEYoTud/MZX/MrsRjEhjVJrfXksw7VPiULh7UZLxOACqy+C4SwC0iQO6bz6/ut5n6mZW8H3e9Mj8Xko0ehAwUpCEOhiiWUHOr5HcmnRNUKzw2f8dxFqYu0F5+CI05ay9X+AY7K9yzVtTNMejZL/YBlf/n+7M75U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974767; c=relaxed/simple;
	bh=Cl/gbCORGvSSb0dCo+2BguIufNCXqrb8c1SMvEbIWpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGpxgsMZBD08/Aysf/ln8FbbqFH6verbq98tZqkXtiCk/HOOzYHyzIKY1cDALOwUtBFC9tvHgRLsawRwlpqxhbm8TVhw6FYAafzTCY4Rnu+XmeKbogODxKKh3MFoncPJo6vaQbOVrw8/0Vz3mPwndzyOcptcuM7vd5phqmYPO+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBE57t4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBE57t4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFEA1F000E9;
	Mon, 17 Aug 2026 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974755;
	bh=M9VCdR2WX50GiIn94Kg6qxnMM24NaqOmjzagAP9/Ki0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBE57t4VuB54vWtGj9GaEO1JDtpFsYrqhS3BJugDvRKdMFmNPuwTGrdLvhz2OaTVU
	 Xy83ZUSj8Cxgg8DisWfKOzdOIc1F4a+D8B+wnY7TFAmguW42ssq2j4ODARaLQOjj7n
	 v3P/qCC4RQiS3y7TPpCA7pXZzDLdBtga4EfJqhN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/250] bpf: split check_reg_sane_offset() in two parts
Date: Mon, 17 Aug 2026 15:30:05 +0200
Message-ID: <20260817132538.253959355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

[ Upstream commit ed20a14309e09216d1fa86e12b1578fa822119b4 ]

check_reg_sane_offset() is used when verifying operations like:

  dst_reg += src_reg
  ^          ^
  |          '-------- scalar
  '------------------- pointer

To verify range for both dst_reg and src_reg. Split it in two parts:
- one to check a pointer offset
- another to check scalar offset

This would be useful for further refactoring.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260212-ptrs-off-migration-v2-1-00820e4d3438@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: cdf19b1b3c01 ("bpf: Propagate untrusted pointer state in commuted arithmetic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17c1ccff3ac20..80710cb8421ef 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14291,9 +14291,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	return 0;
 }
 
-static bool check_reg_sane_offset(struct bpf_verifier_env *env,
-				  const struct bpf_reg_state *reg,
-				  enum bpf_reg_type type)
+static bool check_reg_sane_offset_scalar(struct bpf_verifier_env *env,
+					 const struct bpf_reg_state *reg,
+					 enum bpf_reg_type type)
 {
 	bool known = tnum_is_const(reg->var_off);
 	s64 val = reg->var_off.value;
@@ -14305,12 +14305,6 @@ static bool check_reg_sane_offset(struct bpf_verifier_env *env,
 		return false;
 	}
 
-	if (reg->off >= BPF_MAX_VAR_OFF || reg->off <= -BPF_MAX_VAR_OFF) {
-		verbose(env, "%s pointer offset %d is not allowed\n",
-			reg_type_str(env, type), reg->off);
-		return false;
-	}
-
 	if (smin == S64_MIN) {
 		verbose(env, "math between %s pointer and register with unbounded min value is not allowed\n",
 			reg_type_str(env, type));
@@ -14326,6 +14320,27 @@ static bool check_reg_sane_offset(struct bpf_verifier_env *env,
 	return true;
 }
 
+static bool check_reg_sane_offset_ptr(struct bpf_verifier_env *env,
+				      const struct bpf_reg_state *reg,
+				      enum bpf_reg_type type)
+{
+	s64 smin = reg->smin_value;
+
+	if (reg->off >= BPF_MAX_VAR_OFF || reg->off <= -BPF_MAX_VAR_OFF) {
+		verbose(env, "%s pointer offset %d is not allowed\n",
+			reg_type_str(env, type), reg->off);
+		return false;
+	}
+
+	if (smin >= BPF_MAX_VAR_OFF || smin <= -BPF_MAX_VAR_OFF) {
+		verbose(env, "%s pointer offset %lld is not allowed\n",
+			reg_type_str(env, type), smin);
+		return false;
+	}
+
+	return true;
+}
+
 enum {
 	REASON_BOUNDS	= -1,
 	REASON_TYPE	= -2,
@@ -14741,8 +14756,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	if (dst_reg != ptr_reg)
 		*dst_reg = *ptr_reg;
 
-	if (!check_reg_sane_offset(env, off_reg, ptr_reg->type) ||
-	    !check_reg_sane_offset(env, ptr_reg, ptr_reg->type))
+	if (!check_reg_sane_offset_scalar(env, off_reg, ptr_reg->type) ||
+	    !check_reg_sane_offset_ptr(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
 
 	/* pointer types do not carry 32-bit bounds at the moment. */
@@ -14871,7 +14886,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	if (!check_reg_sane_offset(env, dst_reg, ptr_reg->type))
+	if (!check_reg_sane_offset_ptr(env, dst_reg, ptr_reg->type))
 		return -EINVAL;
 	reg_bounds_sync(dst_reg);
 	bounds_ret = sanitize_check_bounds(env, insn, dst_reg);
-- 
2.53.0



