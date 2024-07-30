Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33361183CCD;
	Tue, 30 Jul 2024 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355664; cv=none; b=rppQgoSohgGQ0PEhtPPhPKgdY7ZMD/YZ4zUb9ZySHGCUagkUcAQ4xFk32YIxNgrxr+BupSs594XqY3v99FLfK+MIGY9jbaOrBbsQK5dN4u88G6zQaRhAqdtGXlj37L9E0BEdHFI5Ddzl2Hm2PYlSVmWeLH9gQ5XpAGDR0Nbbuso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355664; c=relaxed/simple;
	bh=TDxNT3gzq0vJ3UAiVil0M3rDtE0POjqY7k5G/1QJNqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSiNXThghRZEU+jhod91KuTF9MTUdUnbsx1mIqUyokaVkPxHQdXS1UD1wiKhWyFB+D61hxJEGjHaXDxBMagEqz9irJBPXqgFKb5WWjW8A7gSzJ6iyVlFbcp+ZF9G9EO+zQkgGtg8m/j8ZMst/j91JkrUx+OVyid4IskvXivhyxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtbQjDx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtbQjDx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E6CC32782;
	Tue, 30 Jul 2024 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355663;
	bh=TDxNT3gzq0vJ3UAiVil0M3rDtE0POjqY7k5G/1QJNqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtbQjDx5BFnr2/adDaD2P0RCqdzv3wvm+wz0XVf1HK/xDAPls2X2xlpFl0Un/GVku
	 3CWlIhC2jSsqYGTwyTdtzyplS0OOYUX6BysKiDpUhfgANIYLnWgIotiqRzeA8qxoTc
	 j3z3KUuU7PzaN1ATAAbm++8bXV7i2dX0wuxZToiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/440] selftests/bpf: Close fd in error path in drop_on_reuseport
Date: Tue, 30 Jul 2024 17:45:52 +0200
Message-ID: <20240730151620.536771035@linuxfoundation.org>
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



