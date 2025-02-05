Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5343376;
	Wed,  5 Feb 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766437; cv=none; b=hPrgH53z7N+Fg1uvefFev4+iSM++/os/WCtgj8nXyW8zgAuMJzj0NVwLLXNr+CbNlaEy8AscQRkhDDzmTy8uLsWVd+IAli6yzqAmCs1TSqCwwn2EySEqmryTmhCYzA/BO0Som2XmZEJQvR7obzV6qC1C0/vvZcPCLJkRiIEYKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766437; c=relaxed/simple;
	bh=gFlhvlbKUeGMIhP+1fGoH863LhU3jm6xQe1AzJelBBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUN/mqA4LrQMiYzpimUWVbpa5wdFUnBao52elOP+e3eP+/ekm0QsvR8jfZwY0yfKgmjgo7+OtgUp1fV1RE1TP90H+NwfEQ4IyPh84vdAF4e+b5bnj/Ap3Fo9sA7tjW7vjuXN/Oec47NNNob4fi06tg9EjLzxdoL2zVstsjpta68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRnr4SBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRnr4SBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F7AC4CED1;
	Wed,  5 Feb 2025 14:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766437;
	bh=gFlhvlbKUeGMIhP+1fGoH863LhU3jm6xQe1AzJelBBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRnr4SBrMySiEohOEYIeGuTKLpNpHeGI9XV9/z27Royph0pXmcFfcoQsdnY449T9S
	 waEzbGdXaHawZnFxs8yG0Fa1GuvCBAxXiXYYE2NtIwjEHj2OD0taZiF596f8JLEjl4
	 g0+M1dr2598imrBcHhw15V/xeuFMvvHKB372OJo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Leogrande <leogrande@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 254/623] tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind
Date: Wed,  5 Feb 2025 14:39:56 +0100
Message-ID: <20250205134505.948507838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Leogrande <leogrande@google.com>

[ Upstream commit e2f0791124a1b6ca8d570110cbd487969d9d41ef ]

Commit f803bcf9208a ("selftests/bpf: Prevent client connect before
server bind in test_tc_tunnel.sh") added code that waits for the
netcat server to start before the netcat client attempts to connect to
it. However, not all calls to 'server_listen' were guarded.

This patch adds the existing 'wait_for_port' guard after the remaining
call to 'server_listen'.

Fixes: f803bcf9208a ("selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh")
Signed-off-by: Marco Leogrande <leogrande@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://lore.kernel.org/r/20241202204530.1143448-1-leogrande@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index 7989ec6084545..cb55a908bb0d7 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -305,6 +305,7 @@ else
 	client_connect
 	verify_data
 	server_listen
+	wait_for_port ${port} ${netcat_opt}
 fi
 
 # serverside, use BPF for decap
-- 
2.39.5



