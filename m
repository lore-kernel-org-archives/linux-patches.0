Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529B92727F3;
	Wed,  8 Apr 2026 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674206; cv=none; b=ZfReTC+rF/TSWGqh8LBaDtP+k9AdWMEfZtx+Di/7w+QKKydDbzU0UFHvrezVYgwhF3dEIuFm/h51auP5BulHOIlYiCyzyv/jnsirIv/z5eXIqQy+8DG+VDfyC85DnKU5e6Zloqp0lNjrio7YeaAEa1S4OSKJuzb76HEIE971g6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674206; c=relaxed/simple;
	bh=TR2jjMXcVxeXm6RsCSZVlvjOHm49zvAhbzxrlDR1Zck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyjhBFWOZni8RPINqghow9nTHmCVGvbriGLAG2jUYUL4x1ovohsY88e3iWhK2jDNQhW+86i0cmzTRuuFiaxJuRDuoEiPPHpLQVHtOCVSCWKH61amvOWKOBGNLmZsfaTxskcfDejensvfm6rpahLngMjrghfHZb2CyuOc10+xKd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbVH8yW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbVH8yW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD09CC19421;
	Wed,  8 Apr 2026 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674206;
	bh=TR2jjMXcVxeXm6RsCSZVlvjOHm49zvAhbzxrlDR1Zck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbVH8yW6HvKWQ9pZ4LsOYRPqG19nAD23sf1N18wlJzxJCrfYaXUvy3OH39sFfAJO7
	 /z0c9doFD8x8FNqYH2IrJYZczWjT0NmpbxeiQFWC1FddOmWN0f5JQefuABuBzoFboD
	 c9tyUdaxmLdbVDQVejpnjGIGOjr06SfKfJc7BSWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 239/242] selftests/bpf: Test invariants on JSLT crossing sign
Date: Wed,  8 Apr 2026 20:04:39 +0200
Message-ID: <20260408175936.050905484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit f96841bbf4a1ee4ed0336ba192a01278fdea6383 ]

The improvement of the u64/s64 range refinement fixed the invariant
violation that was happening on this test for BPF_JSLT when crossing the
sign boundary.

After this patch, we have one test remaining with a known invariant
violation. It's the same test as fixed here but for 32 bits ranges.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/ad046fb0016428f1a33c3b81617aabf31b51183f.1753695655.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/verifier_bounds.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bounds.c
@@ -1028,7 +1028,7 @@ l0_%=:	r0 = 0;						\
 SEC("xdp")
 __description("bound check with JMP_JSLT for crossing 64-bit signed boundary")
 __success __retval(0)
-__flag(!BPF_F_TEST_REG_INVARIANTS) /* known invariants violation */
+__flag(BPF_F_TEST_REG_INVARIANTS)
 __naked void crossing_64_bit_signed_boundary_2(void)
 {
 	asm volatile ("					\


