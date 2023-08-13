Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47BF9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B647C433C7;
	Sun, 13 Aug 2023 21:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962084;
	bh=U/tAFiepjzRhD3vPGqQwNC5zDCc2w6hzOMldCLtu5vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4KYtBCskba/gym+h668EnBGI2dgzlXC+xNzOAfehgPNhxRT7i5W6tqDZiZ0T994W
	 1syB4S94R7QKKvWSDlPWO1Mwj41IjuX+5iXns/Pe48ueLtmmTgIVHFc/WLgyPl9FYd
	 oO5Od6Iol4ezB+bjfnT67v8Ko8Z83wBYIRrdtGvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.4 108/206] selftests/bpf: fix a CI failure caused by vsock sockmap test
Date: Sun, 13 Aug 2023 23:17:58 +0200
Message-ID: <20230813211728.142037930@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

commit 90f0074cd9f9a24b7b6c4d5afffa676aee48c0e9 upstream.

BPF CI has reported the following failure:

Error: #200/79 sockmap_listen/sockmap VSOCK test_vsock_redir
  Error: #200/79 sockmap_listen/sockmap VSOCK test_vsock_redir
  ./test_progs:vsock_unix_redir_connectible:1506: egress: write: Transport endpoint is not connected
  vsock_unix_redir_connectible:FAIL:1506
  ./test_progs:vsock_unix_redir_connectible:1506: ingress: write: Transport endpoint is not connected
  vsock_unix_redir_connectible:FAIL:1506
  ./test_progs:vsock_unix_redir_connectible:1506: egress: write: Transport endpoint is not connected
  vsock_unix_redir_connectible:FAIL:1506
  ./test_progs:vsock_unix_redir_connectible:1514: ingress: recv() err, errno=11
  vsock_unix_redir_connectible:FAIL:1514
  ./test_progs:vsock_unix_redir_connectible:1518: ingress: vsock socket map failed, a != b
  vsock_unix_redir_connectible:FAIL:1518
  ./test_progs:vsock_unix_redir_connectible:1525: ingress: want pass count 1, have 0

It’s because the recv(... MSG_DONTWAIT) syscall in the test case is
called before the queued work sk_psock_backlog() in the kernel finishes
executing. So the data to be read is still queued in psock->ingress_skb
and cannot be read by the user program. Therefore, the non-blocking
recv() reads nothing and reports an EAGAIN error.

So replace recv(... MSG_DONTWAIT) with xrecv_nonblock(), which calls
select() to wait for data to be readable or timeout before calls recv().

Fixes: d61bd8c1fd02 ("selftests/bpf: add a test case for vsock sockmap")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20230804073740.194770-4-xukuohai@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index b4f6f3a50ae5..ba35bcc66e7e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1432,7 +1432,7 @@ static void vsock_unix_redir_connectible(int sock_mapfd, int verd_mapfd,
 	if (n < 1)
 		goto out;
 
-	n = recv(mode == REDIR_INGRESS ? u0 : u1, &b, sizeof(b), MSG_DONTWAIT);
+	n = xrecv_nonblock(mode == REDIR_INGRESS ? u0 : u1, &b, sizeof(b), 0);
 	if (n < 0)
 		FAIL("%s: recv() err, errno=%d", log_prefix, errno);
 	if (n == 0)
-- 
2.41.0



