Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B4619EECF;
	Thu, 15 Aug 2024 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729302; cv=none; b=WvtdcYHqjKk7LNBLPfMIpilE6eJE3WHouFhfpSgzGdNUxmr5YjsT+VBh0TqCnjCP4zRDbQmurWsZY+Cw029rXV1Io3OgZOmUzepiExPL7x32K4demVqDFm7UEuTW8JmHSgKs+eKPCkPbN3GjdaGH5rjpG5/CcsTeqIXmaQ/XSB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729302; c=relaxed/simple;
	bh=juMOvlzHQCVoU8z9VmPRpxBC1wYirhvOWaRnfddnkVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA5G4ile5arJDkcSct8piBFllU3fR6E1to8I2fBgQ9HjIXvSkQR4F46MtHix0hclT2BTeX3arFAHuENabREh5vTILfLGdp0npKXPNRsu1veQ/BVT+0OOUdqbsO8oH86EGETbGt6w6UKqHl6/E8+o71GouVcIRylgEEOBsc4daiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xr3vhQHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xr3vhQHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6DDC32786;
	Thu, 15 Aug 2024 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729301;
	bh=juMOvlzHQCVoU8z9VmPRpxBC1wYirhvOWaRnfddnkVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr3vhQHDijBBkWpT+XJ6Lb130D216lzwO28WY/NWMIeCZCihWjP6w5Vsj23XIjt7u
	 OaQoFuUiwaHcT2gmGeNwQjTqOBG3BoSH2T1cnwScd26BOutBSCvoZywD5rTkR6CwIT
	 dS25BNCLLwSU7ky81hE2vAymcse6ZYNF5J3xEpjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/484] selftests/bpf: Check length of recv in test_sockmap
Date: Thu, 15 Aug 2024 15:18:32 +0200
Message-ID: <20240815131943.370272369@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 72f88a38c3229..230ca335a9919 100644
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



