Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A09197A8F;
	Thu,  6 Jun 2024 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683283; cv=none; b=SjnRheZY3oYK60CxI3x2Ey3i1AtyhOqbn6aLuf279W2zHBnFBHknj6z+4Thg6xHeMvf4Zsx4onsZfDaOD2jgNNf5nqd5+Thefa1SQOjFH0jp/3teyAruE1OA1MdO9Q+Y+pAzmy6GqsJ6bW7km6SwoV4RSFSGkrraKODqdeK3xhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683283; c=relaxed/simple;
	bh=3echm78q7bfVRMy9llIJWbU7Pz+7jgvXhclvfgIoThg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuhOOQC8ZtMab5xJRk3Is3nVzNKqO+fP8vVQchqUx0hRJWutZSKVUfwQG2Pok2/IGjrNGzQeOdflZP4VcHUeIGOVYbU8C0muy2HYiLEBAO21cowUImLXvoj3dVluKeW4754bQBwPjIUmU3xzd11C73z8Dj8jCmfpoNKo/XdBEXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRMljDn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRMljDn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465AC2BD10;
	Thu,  6 Jun 2024 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683282;
	bh=3echm78q7bfVRMy9llIJWbU7Pz+7jgvXhclvfgIoThg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRMljDn8cHoVAQSjMAUhTXWXeCI3wDsODKhFYDNFj2W08FIpxGcO1osDVzWjBXMae
	 CNIvdEv7N0/xlb/3a+NztS0zo44MMDv3yVGp5INwXrJcsjXMUxXqQEmNjBJd2TcsbZ
	 F0Dd+bIMibabFj6zPHhSYbIhxy+3JzdGQHFUOb0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/744] selftests/bpf: Fix pointer arithmetic in test_xdp_do_redirect
Date: Thu,  6 Jun 2024 15:58:16 +0200
Message-ID: <20240606131739.580618084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit e549b39a0ab8880d7ae6c6495b00fc1cb8f36174 ]

Cast operation has a higher precedence than addition. The code here
wants to zero the 2nd half of the 64-bit metadata, but due to a pointer
arithmetic mistake, it writes the zero at offset 16 instead.

Just adding parentheses around "data + 4" would fix this, but I think
this will be slightly better readable with array syntax.

I was unable to test this with tools/testing/selftests/bpf/vmtest.sh,
because my glibc is newer than glibc in the provided VM image.
So I just checked the difference in the compiled code.
objdump -S tools/testing/selftests/bpf/xdp_do_redirect.test.o:
  -	*((__u32 *)data) = 0x42; /* metadata test value */
  +	((__u32 *)data)[0] = 0x42; /* metadata test value */
        be7:	48 8d 85 30 fc ff ff 	lea    -0x3d0(%rbp),%rax
        bee:	c7 00 42 00 00 00    	movl   $0x42,(%rax)
  -	*((__u32 *)data + 4) = 0;
  +	((__u32 *)data)[1] = 0;
        bf4:	48 8d 85 30 fc ff ff 	lea    -0x3d0(%rbp),%rax
  -     bfb:	48 83 c0 10          	add    $0x10,%rax
  +     bfb:	48 83 c0 04          	add    $0x4,%rax
        bff:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

Fixes: 5640b6d89434 ("selftests/bpf: fix "metadata marker" getting overwritten by the netstack")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20240506145023.214248-1-mschmidt@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 498d3bdaa4b0b..bad0ea167be70 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -107,8 +107,8 @@ void test_xdp_do_redirect(void)
 			    .attach_point = BPF_TC_INGRESS);
 
 	memcpy(&data[sizeof(__u64)], &pkt_udp, sizeof(pkt_udp));
-	*((__u32 *)data) = 0x42; /* metadata test value */
-	*((__u32 *)data + 4) = 0;
+	((__u32 *)data)[0] = 0x42; /* metadata test value */
+	((__u32 *)data)[1] = 0;
 
 	skel = test_xdp_do_redirect__open();
 	if (!ASSERT_OK_PTR(skel, "skel"))
-- 
2.43.0



