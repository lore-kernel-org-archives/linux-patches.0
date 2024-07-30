Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D921A6160;
	Tue, 30 Jul 2024 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356843; cv=none; b=GstBt2BXcQQq00PWOj9/XBfHPgqKTQaU0iaKlsXL+qThzkm158e9I7IkQZuE7vPy4UKZSuHrncF1z08kTRXX1fBWQ1FYdBIC6GTpAVAEGfhMN6VFj/JQ6p+tnSQE1KIwNQun+GI029KvgQl+/x6uzP0joyLgEavGkEQEFZf4Aj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356843; c=relaxed/simple;
	bh=soFiei8msYq+4Fw65ZL+LX7fOEA/hWfn64QyCzqL1sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtIKlHhX8Qtjv7K5pMkvdKe3Wv+WYKC8twi/0HZ3PWP1viyNxZrgm1IA6B0JjMctO1Zl72G2enOQ4dlmLj15NUVhcX21fDVwoXzfnuEpmIN/i2tRW5Jhwjul1jDzADVwdGt7kPv5w9NxYoc70YHR/Iy7nSHTbajaKwyjbVkJrsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSZkyj3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSZkyj3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F79C32782;
	Tue, 30 Jul 2024 16:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356842;
	bh=soFiei8msYq+4Fw65ZL+LX7fOEA/hWfn64QyCzqL1sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSZkyj3jIcWd9gIpMlZJXF8Pkmbtp4C3Hjp6k3AvViDUGxcwTpvEoHJY7ADlvmTip
	 qbS0Ls1WhHnSLkqFAhspbw0HLR9P+5z2lnAuCWX+9hIr5jEnunE7bDjdqitjknHu//
	 VMI2wiQ2Bm1BLoMChwhgoiP4MowqpE/Mhpu3Iyv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 180/809] selftests/bpf: Check length of recv in test_sockmap
Date: Tue, 30 Jul 2024 17:40:56 +0200
Message-ID: <20240730151731.720140313@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4499b3cfc3a68..a709911cddd2f 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -680,7 +680,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 				}
 			}
 
-			s->bytes_recvd += recv;
+			if (recv > 0)
+				s->bytes_recvd += recv;
 
 			if (opt->check_recved_len && s->bytes_recvd > total_bytes) {
 				errno = EMSGSIZE;
-- 
2.43.0



