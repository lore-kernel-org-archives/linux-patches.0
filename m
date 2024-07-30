Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD221A616E;
	Tue, 30 Jul 2024 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356233; cv=none; b=EuTdvdxDO56Jgm3AM9vddCJdFgMa2WFlQmvg2uDWpKv5x3DTxwH4ws8hR0MCgSJY4VgTVcMTyDLVIy9LsXRGA8PmOj8F7IOR+fidvReD4ea6iAv7XdCWGsbsxscWcZ4Wf2okDG5Vk8Ujx6yuroPJH4qccmIH8Kj/F0ujB/q6JUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356233; c=relaxed/simple;
	bh=032EvW4DNicSBoASSpjYIK3/xUhWPEzNfTn6wIW8UH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE7zi5U8O6bjvJTE915a+EpCk7c00/c7Pp0Y5Ui7oTYCD3qR0WlR14IsWtRo56tr3FilDDhCX/caOX6kIEVFbQGbHIgDHT3T7XS9/JGm4fyWu3KXojZAwkkgrJsbRy83pG35/zme7BZjel87/gd+4TgMlMveTrbOiDcDYqGpnlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bd5/myog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bd5/myog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E37C32782;
	Tue, 30 Jul 2024 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356233;
	bh=032EvW4DNicSBoASSpjYIK3/xUhWPEzNfTn6wIW8UH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd5/myogGiGkWRa5FkA8AcMKhDsw7PAfNT97VUsK2e+UyNcNOj3+8YPkAqdZlFV0y
	 M5/Q1dPxNygSJkKZocX6E4dYeqnu1ebIOJdv7fdpmPnYr+qdaKPScdHN6aZVBNt3Oa
	 TwdNCTtBHEkDswt1pvTYyeqKUrlbqAmqor2fI5Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/568] selftests/bpf: Check length of recv in test_sockmap
Date: Tue, 30 Jul 2024 17:43:53 +0200
Message-ID: <20240730151644.797663933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index e32e49a3eec2c..a181c0ccf98b2 100644
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



