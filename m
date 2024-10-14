Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E5381749;
	Mon, 14 Oct 2024 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917804; cv=none; b=Mr+GQYf1Qn32kcnzvtwUdFPHDX0rpFkWEvL6tV4QJsa3WsUFn4H7IcO14it2kBXKXEfACEd+yKZ+W7wTOYFGvitV5gzkvyCvNmBTcm+jCBytSYD9PBNHTRHh08ooaON19Ew9pct+1nNxs4+XYlp3/RmI2jNRnEzH6Rxss/8eiJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917804; c=relaxed/simple;
	bh=xDZ/bgXzB7YNmldGYa3sRHVv5cDwlGKmKH4J792U8No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE5NKgXOv3z16uvxLyt5/ktFFZ1t836Zs1mJFMMQFigFzyjctIxRQBDTSO/uD+w8XIdZrE/kswFSEckR107lJNUBJjHmxBobEEY6zv51Ons9t+kPGkZzZxI3VdeDHKDz99N7wS35c1bVppE1XoMM60GjUmqhHgP3wrnGFNhDDf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8JMTtaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8JMTtaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7D1C4CEC3;
	Mon, 14 Oct 2024 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917804;
	bh=xDZ/bgXzB7YNmldGYa3sRHVv5cDwlGKmKH4J792U8No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8JMTtaQsNGeC9KW3m0qo/Og4HqCTP4cHaihQSRuKo48ZpoSQLpkBUV4FpiHogTKf
	 yVIOAY95+jaX7UxNajG4Si/BtKsu5uULdzFICn8cPXBs/dYwtOhNFJFr7KBkRup5/0
	 sn6QMWUZJYVlcQvb7M04EDA1ELc6Re1mbU1ysS80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/798] selftests/bpf: Workaround strict bpf_lsm return value check.
Date: Mon, 14 Oct 2024 16:11:34 +0200
Message-ID: <20241014141223.419685858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



