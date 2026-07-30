Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D782C0F93;
	Thu, 30 Jul 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423788; cv=none; b=V1SwYB2ydrNCJV5xTI6eAzclr0n2c+rJ8ITtFI/rYJlaqCLTx3zROg5atwXmoq1Z5ODKjsy3kPe00aIilzBmSMuWu/kRz1mm2qS3l8wthBigWtEg0aq++G2+FzqVr6Ib1jHRxHXNML1VOcM0fsi7B3rCdES+BF5hjSgaaRd4q50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423788; c=relaxed/simple;
	bh=yv5Df7cAucguQfwrf5qlvgBuIYQM7HNwaFNCvjiSmhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmcUxeG6ruSveItgrsVkfvkcQWIk0s2Z6r1ner0QOn/qqeNx2k8JdxUsuhej6X99p48aT4lp2GudcH21OJ2fPzTZqW/al44FhZ8s2tyMuLu9hlMBR2diY9xLI+Q31PvWMLKHgIaIic/3Cwf4yB5UOU5wI1oa1reCKYkkyb2ZB2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4KZ2E6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4KZ2E6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE621F000E9;
	Thu, 30 Jul 2026 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423787;
	bh=ixD2JALwHELwoe44WRg3a0T9prhUMR4HcLgdGtwFPn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4KZ2E6sXRfEJXpxHOGjoKi+Lfhz50Qvcwv8ENZcNuTT+rGk9qWkGtLZT/1B6xM7O
	 bTAN4JS8oYQ+hwr0gxWmXGSEunjGwm3pAGOZEOwVPcXkEp6aZ4n45BVoh/Hhi9UzMf
	 4RvcCPqFhFiYOJgIzUOe1z2bTsM3p55dx3psq/iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/675] selftests/bpf: Adjust verifier_map_ptr for the maps excl field
Date: Thu, 30 Jul 2026 16:08:14 +0200
Message-ID: <20260730141448.624474029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: KP Singh <kpsingh@kernel.org>

commit 38498c0ebacd54dbaac3513a548a13f1a8455c4e upstream.

Adding the u32 excl field at offset 32 of struct bpf_map right after the
sha[SHA256_DIGEST_SIZE] hash shifts the ops pointer from offset 32 to 40.
Therefore, fix up the test case.

  # LDLIBS=-static PKG_CONFIG='pkg-config --static' ./vmtest.sh -- ./test_progs -t verifier_map_ptr
  [...]
  #637/1   verifier_map_ptr/bpf_map_ptr: read with negative offset rejected:OK
  #637/2   verifier_map_ptr/bpf_map_ptr: read with negative offset rejected @unpriv:OK
  #637/3   verifier_map_ptr/bpf_map_ptr: write rejected:OK
  #637/4   verifier_map_ptr/bpf_map_ptr: write rejected @unpriv:OK
  #637/5   verifier_map_ptr/bpf_map_ptr: read non-existent field rejected:OK
  #637/6   verifier_map_ptr/bpf_map_ptr: read non-existent field rejected @unpriv:OK
  #637/7   verifier_map_ptr/bpf_map_ptr: read ops field accepted:OK
  #637/8   verifier_map_ptr/bpf_map_ptr: read ops field accepted @unpriv:OK
  [...]
  Summary: 2/18 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260601150248.394863-7-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/verifier_map_ptr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_map_ptr.c b/tools/testing/selftests/bpf/progs/verifier_map_ptr.c
index e2767d27d8aaf8..d8e822d1a8bab6 100644
--- a/tools/testing/selftests/bpf/progs/verifier_map_ptr.c
+++ b/tools/testing/selftests/bpf/progs/verifier_map_ptr.c
@@ -70,13 +70,15 @@ __naked void bpf_map_ptr_write_rejected(void)
 	: __clobber_all);
 }
 
-/* The first element of struct bpf_map is a SHA256 hash of 32 bytes, accessing
- * into this array is valid. The opts field is now at offset 33.
+/*
+ * struct bpf_map starts with the SHA256 hash sha[32] at offset 0 (a readable
+ * byte array), followed by the u32 excl field at offset 32. Reading a u32 at
+ * offset 33 runs past the end of excl and is rejected.
  */
 SEC("socket")
 __description("bpf_map_ptr: read non-existent field rejected")
 __failure
-__msg("cannot access ptr member ops with moff 32 in struct bpf_map with off 33 size 4")
+__msg("access beyond the end of member excl (mend:36) in struct bpf_map with off 33 size 4")
 __failure_unpriv
 __msg_unpriv("access is allowed only to CAP_PERFMON and CAP_SYS_ADMIN")
 __flag(BPF_F_ANY_ALIGNMENT)
-- 
2.53.0



