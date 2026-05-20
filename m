Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903313CC9E9;
	Wed, 20 May 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294680; cv=none; b=Rh7QZ7OMfYLTHUoK8KJvhm1V3E0vkqUESA2zXNVoWlIRjWEQRShzNFNuHLIzDhupMWkyaNvsXbdggSsDIpfHJapzki8D9ak9iMeEVOvxB7VqLSFC62aLOOBOuaEXTrTHsvqM9HH9mLyyLhROM9oXJTvU3ux8kJ2Omjtr1eqDwu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294680; c=relaxed/simple;
	bh=Gmvux0jRIJqCAZHFRkxbJ/Dm/6HTkxpe4kZ9GI2YMug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTtnQosP9YLT5w9Yp6fAg8jlB32+8UXs1qArZki1hWaptEFa9GaB+p/UPo7SYR1NU3hmjKmaTMa4lYX3FW4eWLMboeiLwB1yzDqGfLXWT5OKkf56mbqifd6nh3/gttY+xhMienohle4oSU2HnBfoigtyDMWqrlCcupzSgAI7hvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YNNTjVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YNNTjVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021291F00893;
	Wed, 20 May 2026 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294679;
	bh=202LZ7FkOgKBzIOE0vhQcM7mCkSrfsZZWCqWgf2QIA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YNNTjVKJKdm8Ci8dW4hwyA3rzf1ZDJM1VK2lam3aQAurbZQ0ipc9Nv6tgUrUIwON
	 bWAKgy+s/0udYnCWXvcxtVlNqpurTlCLf+rqQNxg2lR0CC1bk3VCUr23tv58VBVQWv
	 bhe2VYci5Vfqj4k6qlw7D4ZqYgRyZqqnYU0iBFEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0132/1146] selftests/bpf: Fix sockmap_multi_channels reliability
Date: Wed, 20 May 2026 18:06:22 +0200
Message-ID: <20260520162151.312656839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit d9d7125e445dc06c2d9bd3dbd070dcbcd41a540f ]

Previously I added a FIONREAD test for sockmap, but it can occasionally
fail in CI [1].

The test sends 10 bytes in two segments (2 + 8). For UDP, FIONREAD only
reports the length of the first datagram, not the total queued data.
The original code used recv_timeout() expecting all 10 bytes, but under
high system load, the second datagram may not yet be processed by the
protocol stack, so recv would only return the first 2-byte datagram,
causing a size mismatch failure.

Fix this by receiving exactly the expected bytes (matching FIONREAD) in
the first recv. The remaining datagram is then consumed in a second recv
block, which is only reachable for UDP since TCP's expected already
equals sizeof(buf).

Test:
./test_progs -a sockmap_basic
410/1   sockmap_basic/sockmap create_update_free:OK
...
Summary: 1/35 PASSED, 0 SKIPPED, 0 FAILED

[1] https://github.com/kernel-patches/bpf/actions/runs/22919385910/job/66515395423

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Fixes: 17e2ce02bf56 ("selftests/bpf: Add tests for FIONREAD and copied_seq")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://lore.kernel.org/r/20260312072549.6766-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c    | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index dd3c757859f6b..d2846579285f2 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -1298,10 +1298,23 @@ static void test_sockmap_multi_channels(int sotype)
 	avail = wait_for_fionread(p1, expected, IO_TIMEOUT_SEC);
 	ASSERT_EQ(avail, expected, "ioctl(FIONREAD) full return");
 
-	recvd = recv_timeout(p1, rcv, sizeof(rcv), MSG_DONTWAIT, 1);
-	if (!ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(p1)") ||
+	recvd = recv_timeout(p1, rcv, expected, MSG_DONTWAIT, 1);
+	if (!ASSERT_EQ(recvd, expected, "recv_timeout(p1)") ||
 	    !ASSERT_OK(memcmp(buf, rcv, recvd), "data mismatch"))
 		goto end;
+
+	/* process remaining data for udp if secondary data is available */
+	expected = sizeof(buf) - expected;
+	if (expected) {
+		avail = wait_for_fionread(p1, expected, IO_TIMEOUT_SEC);
+		ASSERT_EQ(avail, expected, "second ioctl(FIONREAD) full return");
+
+		recvd = recv_timeout(p1, rcv, expected, MSG_DONTWAIT, 1);
+		if (!ASSERT_EQ(recvd, expected, "second recv_timeout(p1)") ||
+		    !ASSERT_OK(memcmp(buf + sizeof(buf) - expected, rcv, recvd),
+			       "second data mismatch"))
+			goto end;
+	}
 end:
 	if (c0 >= 0)
 		close(c0);
-- 
2.53.0



