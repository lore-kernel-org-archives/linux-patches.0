Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7B41A2C25;
	Tue, 22 Jul 2025 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192891; cv=none; b=IuD/ov8wsa9WKRUOCh4XzUq2uyqkV9A5g6U4Dmiw9FSU9EiGMPxtwZAF1S39juiAKekCFna7dK0cXCgVmpC8LkjvnFOxoWrbTBJWxcA9rm24/Qn7TyyZGaBxt5ctG8c/tMp6AnUiwLMbGpMk8S2WkSNWqLjaca1NlcAPxQHQjm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192891; c=relaxed/simple;
	bh=+kbQoGurZUfdAUN/nSad5lQhdzWuPyku1kl8mEu3LWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K41zMLOTa4O7i+4j2CjX82Sscl/fCKOapGYpYbnXgfURqGqXhZ/8Vcmp22P/rLL394S/gDs2yotiknZ84mpSu0ti2ag2lggMofDxMJGvIegpWz9aqTNweYvhv3FZNDg7PUJUQ13YcO9GeYhH7B2uVHRurgXx8VpXCPQ+WhD8dls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5fK2QNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5fK2QNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4616CC4CEF1;
	Tue, 22 Jul 2025 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192890;
	bh=+kbQoGurZUfdAUN/nSad5lQhdzWuPyku1kl8mEu3LWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5fK2QNCJrWc8P6VQ6iooEU8LxcV7DGJeW0qL3I+5hKPMB7d5RulVMuRNA57Uj8Bp
	 JZxjYmwzLsxCSfVYuazi61FrgcBost3ThbPFHGx+btMlpv2NgIlW7rrYmP64uvrzyy
	 OzbivGABqUjfrpIzOtRMIe8DCViKpvxRiSG7pho4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Auld <pauld@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/158] selftests/sched_ext: Fix exit selftest hang on UP
Date: Tue, 22 Jul 2025 15:44:32 +0200
Message-ID: <20250722134344.048837715@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 7980ad7e4ca80f6c255f4473fba82a475342035a ]

On single-CPU systems, ops.select_cpu() is never called, causing the
EXIT_SELECT_CPU test case to wait indefinitely.

Avoid the stall by skipping this specific sub-test when only one CPU is
available.

Reported-by: Phil Auld <pauld@redhat.com>
Fixes: a5db7817af780 ("sched_ext: Add selftests")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Phil Auld <pauld@redhat.com>
Tested-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/exit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/sched_ext/exit.c b/tools/testing/selftests/sched_ext/exit.c
index 31bcd06e21cd3..2c084ded29680 100644
--- a/tools/testing/selftests/sched_ext/exit.c
+++ b/tools/testing/selftests/sched_ext/exit.c
@@ -22,6 +22,14 @@ static enum scx_test_status run(void *ctx)
 		struct bpf_link *link;
 		char buf[16];
 
+		/*
+		 * On single-CPU systems, ops.select_cpu() is never
+		 * invoked, so skip this test to avoid getting stuck
+		 * indefinitely.
+		 */
+		if (tc == EXIT_SELECT_CPU && libbpf_num_possible_cpus() == 1)
+			continue;
+
 		skel = exit__open();
 		skel->rodata->exit_point = tc;
 		exit__load(skel);
-- 
2.39.5



