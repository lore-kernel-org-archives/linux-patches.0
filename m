Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649F343893;
	Sat, 12 Sep 2026 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206794; cv=none; b=HRPPFIMJhUk6tBBrvYvgqJzOP02+45wj2nTwU3efJzd3oQadwbcqV6ZYBUcLAr/hk+uSqibybA0TkIU1kQL7OUF2qifXzUEdXvGjTPOMPhTlWEqUeU80Jfhz5M/8s5H0HWLhyfaooAB5luxKTUOa0yA6wJvHsh2bM/xqZoFxlSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206794; c=relaxed/simple;
	bh=uxO7BPduwZIgYlyl4ACKzACb88ouUMRWxBkSvXqS5IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUR+Bb8mVx2vDAyYvSy3p3/d+PuGwU6pOJ8p+3AhEs6saWPJ2rocx0RA5NxEMwdE4nPbYXCvsZwHuEIuk57Z7vShD/L6YXeleBqzpgejN2Gbi2UHzTeKXRX0LWZiyN16k9w3J6PI5OIclLo1zahvk5zTu8mt63yDPYaSb7QxwNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6Ld43IP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6Ld43IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3CA1F000FF;
	Sat, 12 Sep 2026 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206793;
	bh=igk9MUs4tgciV0fZBurSU9DdoSpDiUAmOliBwZ0owiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6Ld43IP4ffoAeMrXfAFYXmEZjhQyzTEt7Gys0y0dGcFetr/0VRJKfxpXRpRITyw1
	 l04xiRq11je4SVWz7cv1IOKWAaIBdkrFAeyyQ/BuT1Njln8ROqjeuhqq7PD2d9r9uu
	 04nom2eYVJAlzkt0+3GSP7Cr3mURSlrVfkq1a5Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0237/1518] selftests/bpf: Fix memory leak in msg_alloc_iov error path
Date: Sat, 12 Sep 2026 08:40:06 +0200
Message-ID: <20260912065628.844779977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit 0bebfaa39deadec21638f6fba553eae12627a26d ]

In msg_alloc_iov(), when calloc() fails for an individual iov_base
allocation, the error path frees all previously allocated iov_base
entries but fails to free the iov array itself that was allocated
with calloc() at the beginning of the function. This results in a
memory leak of the iov array.

Add free(iov) in the unwind_iov error path to ensure proper cleanup
of all allocated memory.

Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260704122936.102394-1-malayarout91@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 76568db7a6642..6879918a8cafb 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -515,6 +515,7 @@ static int msg_alloc_iov(struct msghdr *msg,
 unwind_iov:
 	for (i--; i >= 0 ; i--)
 		free(msg->msg_iov[i].iov_base);
+	free(iov);
 	return -ENOMEM;
 }
 
-- 
2.53.0



