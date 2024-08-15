Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C127E19E825;
	Thu, 15 Aug 2024 13:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728499; cv=none; b=NFmzQNDbSckuFbgYXjmFEM8eHn081o3ArtACyUu2SIJwyppFmQ2ByDEx4C6KAzN+V/OfxfB6KeWUjxONDdtrPzq13caucCGvI0ISfuToB8cclKffzwUFXr6bo1/pvSSpUss563xfyuX5VyBC8smy9F+V6gPhqhsE/oiiujq8pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728499; c=relaxed/simple;
	bh=0PlMFdAZC/qvK5JC37rs+P4Tr2+r2GYa2JzjHw2vF7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyrwIotcA/Xvx8GrabhNZ0cFWPR+DzaLosF3rgjR5Ww/YtQQNCEIvIqJiFoJ5PLJjQG2rfuxUBe/+sjZryFH02MY2zNswy/9G5bUv4tOFF/8nZ05YgZ+qywP8Uaf8+9uUNfkl2m4QVGCLjc/l8eK4qzLQWHrbg6d2oroGYyImX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr9H7t0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr9H7t0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37745C32786;
	Thu, 15 Aug 2024 13:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728499;
	bh=0PlMFdAZC/qvK5JC37rs+P4Tr2+r2GYa2JzjHw2vF7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr9H7t0A8ilkh6jN7oiRvr48AP2Bzw9j1ypU7Qh+0Y4vdvImr9RYzxrZ83sMV1+cW
	 kkewfIOl6CZcIK6yyreKaTifk2bRT1sYmia+3HOgOqWewpM/nkf60VlsRJec4FEVB4
	 BrMmGkA+kFzvZ+KtLsuur9xOSTIRhtome+DSRBV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/196] selftests/bpf: Check length of recv in test_sockmap
Date: Thu, 15 Aug 2024 15:22:17 +0200
Message-ID: <20240815131852.854144504@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a7fc91bb9119c..b9deed81656ba 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -395,7 +395,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 				}
 			}
 
-			s->bytes_recvd += recv;
+			if (recv > 0)
+				s->bytes_recvd += recv;
 
 			if (data_test) {
 				int j;
-- 
2.43.0



