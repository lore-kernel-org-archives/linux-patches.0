Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C0C183CC3;
	Tue, 30 Jul 2024 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355425; cv=none; b=eeYRbOKlxiXkvQ42JZamTpQwOhK2WVZPIeHE6EctQAkcE4TOqbthmlToknZjiYx+GyO3lumZnbcX3dyjMswzVBMuHxFqwW5e9tYMB/EkQuCVcv7L+G3yUHYLDaZf43kGUHTdORdtOI1OO7k2rGdIMtbCxuple0f15albqzQWzaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355425; c=relaxed/simple;
	bh=citVr7R9odsP8k9D4CG+gNJ4ANhRs59yzcAfJePrYpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLZfxNzD4b4l4ptNhterB4yDz2Vq+wXS1Erg8CUQ6mY4b2eCN3CMN1DwGLm/vfxN4MocxQINl5hXpvXfva1b9oTTzd4lOQvBXAp6FKuhN/WIkWdKBUagzxTlChf89FxUYyEBB4AqzsyTsEHMvrK13ZuM8kCXyqZw8/cfBurysug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHIXITX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHIXITX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEB4C32782;
	Tue, 30 Jul 2024 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355425;
	bh=citVr7R9odsP8k9D4CG+gNJ4ANhRs59yzcAfJePrYpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHIXITX1bKu0Lv8jaBK2c2+pRidc/EmDYdrwhL5MgZEsBQPBij/eGCaqfbqnfd25s
	 6fnqmqDTzb8gIot4VpZeSSMr68lFyFdgY4Qcc9fl0lIJHeGd9kq/ZzdefQ8c+faF23
	 1AStq+D41Kn28CSWziHpu87U6c/DsbSgsgtbFuwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/440] selftests/bpf: Check length of recv in test_sockmap
Date: Tue, 30 Jul 2024 17:45:25 +0200
Message-ID: <20240730151619.352552724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 2417300abf36c..25da05cad8f61 100644
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



