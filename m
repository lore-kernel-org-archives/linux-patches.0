Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA8198E78;
	Thu, 15 Aug 2024 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729365; cv=none; b=n1DlnBi7K8AJ1F6oKSm+RSAOQ7MCC2E62JafMKF27/nyKh9YBaLx6zPh1O0Vru3HUhKVjX3MQ4zVfot3Zkqndo9oAJoHZL5jVBGIGhzGL0dBhg9xj92i46uQmvgaGqoQw0fRZfO3ptvEfFbXb42JA5iMGwRtE7Vzc0wLvyq6ggk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729365; c=relaxed/simple;
	bh=1gjDi4rUD0VUZVoBpelEcSi6hIzsWOmgJKAI1T7BkDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBUX5O/eIc8uwCzzateRhN35QOj8nA1niDbFmui/oh02rCKcIybtMDRICFHDlK8Yib8aMSn3R34qBKL3kPIM0mSvGskMYlUDRRMNeXzbOLagrlPMW78PMcKy3gO7ZgNzDUN3lJ3S84fFr+U/bkpw5iZLYDXrhtO+q4PkjKGg/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/s9X9V4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/s9X9V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0C5C32786;
	Thu, 15 Aug 2024 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729364;
	bh=1gjDi4rUD0VUZVoBpelEcSi6hIzsWOmgJKAI1T7BkDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/s9X9V4tW8auZNtC31BbwVeYhPq1GZj+L7v7ff2LGlLmgnb9565OBmWhU0FBd+Yd
	 SX/vBrcs7PRAtUXDPyW8mMd8oCsU6RCnjuJ6J2jYmCQr2nSWiXrwLOQVFgMjFzuE+N
	 HV9URaXmXnKLJ99EI4FUE5b2FdrAEhBtGJbETUbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/484] selftests/bpf: Close fd in error path in drop_on_reuseport
Date: Thu, 15 Aug 2024 15:18:53 +0200
Message-ID: <20240815131944.184498891@linuxfoundation.org>
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
index 6db07401bc493..651c23d6836bc 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -964,7 +964,7 @@ static void drop_on_reuseport(const struct test *t)
 
 	err = update_lookup_map(t->sock_map, SERVER_A, server1);
 	if (err)
-		goto detach;
+		goto close_srv1;
 
 	/* second server on destination address we should never reach */
 	server2 = make_server(t->sotype, t->connect_to.ip, t->connect_to.port,
-- 
2.43.0



