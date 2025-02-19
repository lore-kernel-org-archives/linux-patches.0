Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5591D6DB1;
	Wed, 19 Feb 2025 09:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956218; cv=none; b=kofqEPZ/XsJHUPMpw73H7vQZr/QfoAOpQjgxPSXtW+gyufWj+IBf7+To28XNpwslvuqGuvJwZOkvFPdJuMX5MMhDBzQzocmhf2e184swpZWVkbV5WUZ6v9TQrzkFoOSqm4EK0QXqZpAKWCx3WcBVr73AF9BnGoXGKAa0uxchGdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956218; c=relaxed/simple;
	bh=nZisILbqVzXQVekr06YZPeiKdurobpSgxbYA63uqn0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTMSABWs3QJz2WRAYSzYTytmSnr7gaMll/f3fU2kpKjOM/eno/5thhZetRESuNUoP+l31tE3J+xSD7wMQZ3Pz4zURY3fQZER7iQMYLWjq5BcUzrbxORpVoNWpB6rVGMyty+uEvPI/yGsGrbhXWDAwQb6MmThlOSk/IuMWQkwMCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYGO+n0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYGO+n0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371B8C4CED1;
	Wed, 19 Feb 2025 09:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956215;
	bh=nZisILbqVzXQVekr06YZPeiKdurobpSgxbYA63uqn0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYGO+n0k4Uww2x4enysBogltP+6S83R6+XEA4A/rGU79q/Hql+YIP+I5TiZcXZY8/
	 mlMGcsdZjgsuJQ6d7Jpsn6c3Gh8G1NC09+AAPLhGyNgqDPhzjhoVbIsAW6S0iimdqi
	 FezqTd154FS/5tVAdoaRnF0xnUt5eKgrcMrp6SWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Leogrande <leogrande@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/578] tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind
Date: Wed, 19 Feb 2025 09:21:47 +0100
Message-ID: <20250219082657.019592928@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 365a2c7a89bad..8766e88b5a407 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -296,6 +296,7 @@ else
 	client_connect
 	verify_data
 	server_listen
+	wait_for_port ${port} ${netcat_opt}
 fi
 
 # bpf_skb_net_shrink does not take tunnel flags yet, cannot update L3.
-- 
2.39.5



