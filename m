Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207D01A6192;
	Tue, 30 Jul 2024 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357275; cv=none; b=Q3w+VBoE0Ev05UpLM9+ajBRqIIzKN+zCoGmWcOzzzSzIPfaK1uDFuxo7nIKGMqPAK+Hu2+1diTAuyM0cfJBwkl2L/31rowscrfJ6pr5gBqbimCFvROX4zz4Rj12mtFxuLnW4FsQu1Hps5BXLP4gOFrW/9+iId/HIl5asYZ0b5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357275; c=relaxed/simple;
	bh=HsXYxnK4/WAfqjAXQdC8eu4RpkPamV/CqYsgs6PUxYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/mniLmvTiDLevzdwd58x5bY/f4h7fv8CoMxlG9bkan4e9X0UrlQfGQ4ZcxWw/kmZMXwz1x50s/kRy9Wn1Zz+U62TiDORgXOq6O6y/pJl2EBfICZYHuTQhFEYjn3a8oVxllMVgfQQFIbb6mh+BVyU9lQa0/npRb5DLczPcYFavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxfGWiMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxfGWiMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99626C4AF0A;
	Tue, 30 Jul 2024 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357275;
	bh=HsXYxnK4/WAfqjAXQdC8eu4RpkPamV/CqYsgs6PUxYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxfGWiMjaUTgw8vsnPtnhWYFs5tHaAUaE5wRof41yKafN2V7IxQhVO2mRGCJqOwJc
	 KtjVMkQFhlorHsEEWBL+h/Z5ubi1TM9Av1lBobmjgpBO3ujBVn/t6ctbGYnXPa6lu0
	 +of/l2qRtjNVw6s7Teku25iQWqAmhndOFjOvu0bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 239/809] selftests/bpf: Close fd in error path in drop_on_reuseport
Date: Tue, 30 Jul 2024 17:41:55 +0200
Message-ID: <20240730151734.043972115@linuxfoundation.org>
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

[ Upstream commit adae187ebedcd95d02f045bc37dfecfd5b29434b ]

In the error path when update_lookup_map() fails in drop_on_reuseport in
prog_tests/sk_lookup.c, "server1", the fd of server 1, should be closed.
This patch fixes this by using "goto close_srv1" lable instead of "detach"
to close "server1" in this case.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Link: https://lore.kernel.org/r/86aed33b4b0ea3f04497c757845cff7e8e621a2d.1720515893.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 597d0467a9267..de2466547efe0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -994,7 +994,7 @@ static void drop_on_reuseport(const struct test *t)
 
 	err = update_lookup_map(t->sock_map, SERVER_A, server1);
 	if (err)
-		goto detach;
+		goto close_srv1;
 
 	/* second server on destination address we should never reach */
 	server2 = make_server(t->sotype, t->connect_to.ip, t->connect_to.port,
-- 
2.43.0



