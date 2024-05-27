Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B876561FCD;
	Mon, 27 May 2024 19:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836862; cv=none; b=cB89XynnMloZAzP+Kevh9166EhqEsjjefMhWVGx4FDEnVXei7t/dF2uwxVtS4vLlWJoAlXEim1wO6Vq0XYrlFO2WUS6AyD0r2S0kjWRlyMgcbhZ8UeCDGDkZh4TgKbJtPz7BylsOGYmKW9yrS/iOiRXaxJoQ2/47njMvdvzNAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836862; c=relaxed/simple;
	bh=13I+CAkV9nCRiXJx3rSU40UmRmWJKEuHqlnNYV5fGKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=boFXH51MzIcyKbc9dcw5cjLzCfoRMdN1vn+ZCcLbuaU4u6+9SZLv/NLt4WQE1YrHMkFXXnvzMHzW2OGu/eInjOFxY+KVFuLY881hOYfCOjOAgQv6ombPlehHEcV3UMfbRtP/ZCB1TUmPkw9P4MiuaSU+8TDECNI/8fD57D8Fr4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvMm7zF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvMm7zF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522E2C32786;
	Mon, 27 May 2024 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836862;
	bh=13I+CAkV9nCRiXJx3rSU40UmRmWJKEuHqlnNYV5fGKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvMm7zF3gOqNPl18xUjcLYAibYDiFUsvArNIfbT7dJ3wkU+n4c63UdcciEryDrO22
	 CxELX4wvgeNZjqqKQmaowCvavN7TziQIfy0ed62kFTpwCtn515esq5ieXi37atQQWs
	 m7HUc1AiQnrwwzJcZURC2Ch0d2tdwNZIEVzxdh1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 216/427] selftests/bpf: Fix pointer arithmetic in test_xdp_do_redirect
Date: Mon, 27 May 2024 20:54:23 +0200
Message-ID: <20240527185622.680081451@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



