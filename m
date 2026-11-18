Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020502;
	b=gQSAqUrIE6lcwC9op9Xw8XZ6bKubHg2rp7dIc/OfNmGthaqHoK/ulbr/3k/W35qix8E0
	 8CZ5WcoQ4udLpQcip19rH4FpR2NbbWR3WgP0FYKnP6C9d6j2WEKfcIH6NBx5hP6rquaOk
	 FO1ztU/2B2cV0QpPO0f0EiasLu9lWfC2S1lODTg6GHXc14FMDVwNI2cnH9skB52EWV/0/
	 LAwfaXwOs76piPZzCireLsgh2mHZKT/tORMXu7PAnOlAS431Vy86Q/u3xI831Shqh1JJK
	 ucfaSZxt7XkobKXTeaEfmba62GUPupRDnwTA8KImS6lfeh+qeprAZMwGqXr6EYeuqhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0K7vswElxDNgeJgFLawPwu2UwdtMUzGgLVM+FUTPJzw=;
	b=pnls3wMgVUbQMgNcItBE5Cod5/LkP3Oxb6JR1Fe8xV5po5q3dnRNvehuIXVks+x9iTgP
	 p/qB9Dd9UCOV40tSAx+hKXkDwD2/ok1Z6DY3TYrfhoNTYkP0Dpn/xIJV1ddXgXKkq4LlY
	 2EFFaYY2E4tvcwRmV/zCj6TjqvCpj6s2xmE0eq1mog0qA1jdBivDyghTxRUHfq+h1YvWz
	 jyjT3Wh4tQ/MX3Wqe9eXMBw4WEzAYIpQF33/D4609VToSmzAoeXj8I4pdJQAIatmQbd8W
	 7lGmKJDaF1QZlnpoIDVbljqksVhkFeVBy5UeOJejrolkyDPX9c6duv4a+iwDUCGmd+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gP6Ru+lT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99B606A31C;
	Wed, 18 Nov 2026 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gP6Ru+lT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B711F000C5;
	Wed, 18 Nov 2026 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020502;
	bh=0K7vswElxDNgeJgFLawPwu2UwdtMUzGgLVM+FUTPJzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gP6Ru+lT++ybxU1qVdb4eyTaEVDRL/a3k3ntDIzRaC3w7vxslpixBtgkI1Hn5Qpzx
	 D+u5YTg+Yvguhnjd7LzehRPrAYURsFSIdLReCNwYidtLbeVNgCXtDfgrKztd1zMqoU
	 qt9m0zcufE6OzBP2x61NvfKVLM52fJrlakqu4H/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Yun Lu <luyun@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1975/2651] selftests/bpf: Fix map fd leak in no-BTF wq test
Date: Wed, 18 Nov 2026 15:53:35 +0100
Message-ID: <20261118150357.539968024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit d3c9ecb8765d4befbc46ee325c8d76efd523eece ]

bpf_map__reuse_fd() duplicates the supplied file descriptor instead of
taking ownership of it. test_failure_map_no_btf() closes the original
map_fd only when reuse fails, leaking it when reuse succeeds, including
when the test passes. Destroying the skeleton closes its own descriptor
but leaves the original descriptor and its map reference alive.

Close map_fd immediately after bpf_map__reuse_fd(), before checking its
return value, to release the original descriptor on both success and
failure. The skeleton retains its own descriptor for the subsequent
program load.

Fixes: bca2b74ea9a8 ("selftests/bpf: Add more bpf_wq tests")
Reported-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261013030114.292157-1-luyun_611@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/wq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/wq.c b/tools/testing/selftests/bpf/prog_tests/wq.c
index 84831eecc935b..97926e35aaf26 100644
--- a/tools/testing/selftests/bpf/prog_tests/wq.c
+++ b/tools/testing/selftests/bpf/prog_tests/wq.c
@@ -64,10 +64,9 @@ static void test_failure_map_no_btf(void)
 		goto out;
 
 	err = bpf_map__reuse_fd(skel->maps.array, map_fd);
-	if (!ASSERT_OK(err, "map reuse fd")) {
-		close(map_fd);
+	close(map_fd);
+	if (!ASSERT_OK(err, "map reuse fd"))
 		goto out;
-	}
 
 	insns = bpf_program__insns(skel->progs.test_map_no_btf);
 	if (!ASSERT_OK_PTR(insns, "insns ptr"))
-- 
2.53.0



