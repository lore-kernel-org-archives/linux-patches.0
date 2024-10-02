Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACE11EF1D;
	Wed,  2 Oct 2024 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879617; cv=none; b=N8byZe9oF43/UrOySh/391YYHIe3FRn4LCenDoS0QAxVhkmDZ9LhzCIYFkQhf9GDst+2ruelcrboN1OnMTfv/2Y90njtb6LLD7osbZ8t+oFBaKEwJHWfgdhk3DYYpFo0snGSEGHiziMCj8pewOCGQtbnPDp4AYZduN7DchnnIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879617; c=relaxed/simple;
	bh=kU0oLZhCcKqycGZsyMiA3xddJL0jtBx/OJV//PIsmpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCeLCbxRlASSdETTiRBPwqOi5pIj2HuF/RHdlMO0bm/m0DEk7BRx1GHjGEYurSzWCOXogKJZHeC6e0zsf5kh/n2cd8exS8iuetVyBC/aeI4Ll98odQHgkwmffPoG5Uq3kNRchJv/rppwsVhj+py3iRlzsgWbu2MOSogIVIxTfww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBSKgphQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBSKgphQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D24C4CEC2;
	Wed,  2 Oct 2024 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879616;
	bh=kU0oLZhCcKqycGZsyMiA3xddJL0jtBx/OJV//PIsmpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBSKgphQFMaUIw8WOvJ27hMz31roBlUo3F7g+bRDL4sezHl064yZgveLt7Lkm1lke
	 /uvYkHoyFtg6uF67S/QQLYR+zrLodbF3sVV6HfK0OqkRbcN6erQGadbS4rfM4nyhGd
	 xtNhw8gB5lLFS2eEUbhS7XmdF38a8zluvG0fZy9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/538] selftests/bpf: Workaround strict bpf_lsm return value check.
Date: Wed,  2 Oct 2024 14:56:59 +0200
Message-ID: <20241002125759.361184906@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit aa8ebb270c66cea1f56a25d0f938036e91ad085a ]

test_progs-no_alu32 -t libbpf_get_fd_by_id_opts
is being rejected by the verifier with the following error
due to compiler optimization:

6: (67) r0 <<= 62                     ; R0_w=scalar(smax=0x4000000000000000,umax=0xc000000000000000,smin32=0,smax32=umax32=0,var_off=(0x0; 0xc000000000000000))
7: (c7) r0 s>>= 63                    ; R0_w=scalar(smin=smin32=-1,smax=smax32=0)
;  @ test_libbpf_get_fd_by_id_opts.c:0
8: (57) r0 &= -13                     ; R0_w=scalar(smax=0x7ffffffffffffff3,umax=0xfffffffffffffff3,smax32=0x7ffffff3,umax32=0xfffffff3,var_off=(0x0; 0xfffffffffffffff3))
; int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode) @ test_libbpf_get_fd_by_id_opts.c:27
9: (95) exit
At program exit the register R0 has smax=9223372036854775795 should have been in [-4095, 0]

Workaround by adding barrier().
Eventually the verifier will be able to recognize it.

Fixes: 5d99e198be27 ("bpf, lsm: Add check for BPF LSM return value")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
index f5ac5f3e89196..568816307f712 100644
--- a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
+++ b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
@@ -31,6 +31,7 @@ int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode)
 
 	if (fmode & FMODE_WRITE)
 		return -EACCES;
+	barrier();
 
 	return 0;
 }
-- 
2.43.0



