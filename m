Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6F450B433;
	Wed, 30 Sep 2026 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786292; cv=none; b=Ar7XVGCsqO6emiyDSUNY6AZ9bZHDuew6ee2VO6PDygYWt05zW5tFTkBKLU4HWhXzmmYrUDmLrSmn7ahvqJimozNBKsWCiUIj05QolgblKInHfg1OtimO6mN3S3e3bS3VlV165B6wqd3d7CAnVMXqSykwJjOgywP+aF4D9OZrlhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786292; c=relaxed/simple;
	bh=+iAGRgKaTtkcninZnyfdJrAIwl54zYDu1Y64NilPP0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6T8dQCdP6R4vCvXr7/UXCfhPHMfkoNUOCcRnqsNmCVzM0ixK2bTWxgwKsqUdwNk6Opr1su91lkGsAr+SA0NFET9VlCNHfYnxX1mCf2v9rG6skzvwB5jcfP+YXfn4YKYlPMwprSiMhUv97DWyB4VTshVqIt5TlOfIJbC1Ustqg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSzoOUVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSzoOUVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2161F000FF;
	Wed, 30 Sep 2026 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786290;
	bh=j3MOWG6snvTZdORDlon2tI385pG3an1A43JYkZVZ1PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSzoOUVIX44hBOYDC39bLXKvU4cacT8rYLKz5N+RejAhaSIWN5cO/MggAgv40r04H
	 fWyNjCQ7hlXbasXSbLhk18eMNkPgRB8e3pOfCYi2vhudet67X/LLOL7RT8Gt+rJWUA
	 jcotK2J7bhYcqjDV+MdlYN3qutzTzwuUg6RfCa1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 810/982] bpf: support access variable length array of integer type
Date: Wed, 30 Sep 2026 17:25:46 +0200
Message-ID: <20260930152434.155276588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Zhou <zhoufeng.zf@bytedance.com>

[ Upstream commit 2569c7b8726fc06d946a4f999fb1be15b68f3f3c ]

After this commit:
bpf: Support variable length array in tracing programs (9c5f8a1008a1)
Trace programs can access variable length array, but for structure
type. This patch adds support for integer type.

Example:
Hook load_balance
struct sched_domain {
	...
	unsigned long span[];
}

The access: sd->span[0].

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Link: https://lore.kernel.org/r/20230420032735.27760-2-zhoufeng.zf@bytedance.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: b0b3dc665296 ("bpf: Fix divide-by-zero in btf_struct_walk()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4fa37f58d97dd..2aa8afcebfce0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5626,11 +5626,13 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		if (off < moff)
 			goto error;
 
-		/* Only allow structure for now, can be relaxed for
-		 * other types later.
-		 */
+		/* allow structure and integer */
 		t = btf_type_skip_modifiers(btf, array_elem->type,
 					    NULL);
+
+		if (btf_type_is_int(t))
+			return WALK_SCALAR;
+
 		if (!btf_type_is_struct(t))
 			goto error;
 
-- 
2.53.0



