Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792E81A00F8;
	Thu, 15 Aug 2024 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731230; cv=none; b=AXuTtO3QuQBGi42RB/Ixlc8KNmtox/0HH7/4SRaYTs5pjDURdZZrSjLKZb5TLAHi/p2v7MESY049drjDdOTrMw3XwWXdGvMleAaVnTgNqPUlxsYscE3ItDKRN+nOfSWUfQeXQ6bL08O1pI+Y1GTvyI8wafzfWD2EHgYF/o2cRbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731230; c=relaxed/simple;
	bh=xijjj36egfT6yOp5QhTsJ1rZc2c0RZnnLAbmeo0t7s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmTkXg/UBeOGK6d9DDbsGk4ZMR/N/KEIJ3HIZh+m6kdM1rsR+9KGXmdg8hjLp6RomjP/CvdtPNzauJRcigq3SuDE3jm6Csembigjx3SdM86l3zc0QGVPYw8WyOQ9/Du4jKj2ckPsqjOoHyq6gGQX8xKzI4WlWOtkwddZjGr9QFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKk6LC+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKk6LC+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E39C32786;
	Thu, 15 Aug 2024 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731230;
	bh=xijjj36egfT6yOp5QhTsJ1rZc2c0RZnnLAbmeo0t7s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKk6LC+gIuho/2d3PiBSK4YtI7ynSR0qsaooxmmvit7Wp1v7Q8n00y5G9hZAfoOIK
	 hQsW/HwAYVsi4MOR8TJCgSmL3yMvk2HqoODVa4zvusH1FCtHtw+ls9TW6MgsnZvXob
	 N4CaGu3t2ZLOh2N3+H6GalvvogOlYd+ixK5GahIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/259] selftests/bpf: Check length of recv in test_sockmap
Date: Thu, 15 Aug 2024 15:22:45 +0200
Message-ID: <20240815131904.037320634@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 779e11da979c8..5e5648ed0b11f 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -552,7 +552,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 				}
 			}
 
-			s->bytes_recvd += recv;
+			if (recv > 0)
+				s->bytes_recvd += recv;
 
 			if (data) {
 				int chunk_sz = opt->sendpage ?
-- 
2.43.0



