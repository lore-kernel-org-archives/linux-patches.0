Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301C72EA752;
	Tue, 22 Jul 2025 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193594; cv=none; b=h1c/K1ULE8JhlaFzkrKfgNOnRBAv7zx/UH83BTQkwOndl4+2HPa0BTESRr2FF8MCRubVpe+IUUJtpnqaBHpDfH0RJ4roHUT6PQ0f97vPZ6a8XDHUmQmqws4hEONYM4rTjQVS5jcEQZXZDbSFEy9OhMX3HiL8G5hQ0OLkReO5MiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193594; c=relaxed/simple;
	bh=KcA3SSB71rE/wuHB68wHlwIAP9hOq0Zwg100lHshdg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUOqfqJt1LxlHn56wU/2/lsSkvbsj6bZw2AyyxRLMhx2unPpduOG/RWxzC3cH7h7gA9LfH9Xr3P4QLd8L0p66jJREIFSHBJ6zt73FpqZCM5VfmBDiAs2tZbFMR0vxTR3qN+9ukGOBUojE0KM4TQbG/3cXOvQ0Jwyzni1/qEEIIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wt3YuILM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wt3YuILM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A62C4CEEB;
	Tue, 22 Jul 2025 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193594;
	bh=KcA3SSB71rE/wuHB68wHlwIAP9hOq0Zwg100lHshdg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wt3YuILM2RLXdjhk4s98QN3WDyDZ+1icT/E/yutDANEeyQi3gPaHF2zEcbS64IYyS
	 ocEM4pBBzTmD76/bB/mhZHjgiyVMx0ajhjg+uqXrOLEg0N1wbs68+OdbC3yZdXA97a
	 Y4qAkIz0osRwBTRODdlx+mq7GTcET9CKCLxd6pW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Auld <pauld@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 106/187] selftests/sched_ext: Fix exit selftest hang on UP
Date: Tue, 22 Jul 2025 15:44:36 +0200
Message-ID: <20250722134349.717945809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9451782689de1..ee25824b1cbe6 100644
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
 		SCX_ENUM_INIT(skel);
 		skel->rodata->exit_point = tc;
-- 
2.39.5



