Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EAD1AC896;
	Thu, 15 Aug 2024 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731990; cv=none; b=ovwFB07AIzCB6Ioh9xXkGg7FuenXPmgmxXidtO5yY3Eums86SNQwVgWvUwH2bIevoHlS1zn6H+aYqRsQiKAp6s1aO+fj9dfUxj7DF4+C3WFVnTw/HNSLrXVWnlkvePdcEtuuKCIboMvrH41sGOBS+o1YEemggb5dIAG0sDrpJfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731990; c=relaxed/simple;
	bh=HuVMTq0DyeDDopxu/D1NIeSIVimNSCDHOjIAyGY7IXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjFg3HclVko4HgS4u+uoDpUzagCqTNkVITTRZzPeITNgf6Jg0PWcxa3HGoQYS1+DYNFdSmmyG3unv4Ix/+O1/MTEAHgTCsaIzuIaVtY1g8LeDR+AOhNgmVwC91KAVL/A3ASUOhDpTZ7F9DuoVe9JON1vP6+bcT/2zGPtTvpPOeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1sF5YlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1sF5YlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D3AC32786;
	Thu, 15 Aug 2024 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731990;
	bh=HuVMTq0DyeDDopxu/D1NIeSIVimNSCDHOjIAyGY7IXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1sF5YlK5jT3eyfxIgfmX9bkGPWGlVcRLQsLdJR++TUhmMEkf1ZMpK4iDW6ehTAkd
	 s+YdG2TDxa/wSN2CEYw8gT8jOXmAT6Kdhs7RTRuHsWH+bResCrh9sX5++2OTljLFs1
	 uKz8ewhRfy50fRSPz/YxVAfzG4iqSTVceufIWZxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/352] selftests/bpf: Check length of recv in test_sockmap
Date: Thu, 15 Aug 2024 15:21:46 +0200
Message-ID: <20240815131920.782568613@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit de1b5ea789dc28066cc8dc634b6825bd6148f38b ]

The value of recv in msg_loop may be negative, like EWOULDBLOCK, so it's
necessary to check if it is positive before accumulating it to bytes_recvd.

Fixes: 16962b2404ac ("bpf: sockmap, add selftests")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/5172563f7c7b2a2e953cef02e89fc34664a7b190.1716446893.git.tanggeliang@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index daf848258410e..61be5993416e9 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -663,7 +663,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 				}
 			}
 
-			s->bytes_recvd += recv;
+			if (recv > 0)
+				s->bytes_recvd += recv;
 
 			if (data) {
 				int chunk_sz = opt->sendpage ?
-- 
2.43.0



