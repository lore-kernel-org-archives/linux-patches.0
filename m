Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6329C25EF94;
	Tue, 11 Mar 2025 15:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705434; cv=none; b=QMbg//kGGrod9Ork/jeytM4/VEAFioyBRusWXxLC3s1JotLMSBbmTryWW6bz5rVO02nYjOtT7cHD86xFoNJ5smYxhbEpGpAhqx8YiEOMBpR4FMLnf506PjKLVAnG8nfq4w1PbjJCbdUOG9YPJidNiTVxpYbSTUNmE1PDzM6QBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705434; c=relaxed/simple;
	bh=yhs2CyrUL12GKyst24ykoAYnRc2qLrQ3ET1PFYZwGsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/x+Q3nuDx9KSluAAMnFlBViUEzZQv2375wEpYTED9ACyDmnO75kEXYNdBbXOmT9Ns6VKu/Gceo25liodGfgB/GR+2MdY93mxNim0GM35/dO5cDFpwkI17BLM5JJDlG87rThxUITQKdnpwQpdMktXCtqz0ljGTy5ZnvQ8MHf5VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmvJxId0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmvJxId0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFE8C4CEE9;
	Tue, 11 Mar 2025 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705434;
	bh=yhs2CyrUL12GKyst24ykoAYnRc2qLrQ3ET1PFYZwGsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmvJxId00Rhhhq9QX2gKHtvn6IDeFMchQIH9eWxYB+4a9WblC9wFCqfsxArGVZ6xZ
	 SjXkfcpO7CFPQ0FBf3ulBsPS2VUHodSRjhe5l/IPEI1khAxfzjtm5gv0AkeToL5eqh
	 b0semschHWDALeulmfCVU29++Qkbru8T/WEBaYck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Leogrande <leogrande@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/328] tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind
Date: Tue, 11 Mar 2025 15:56:43 +0100
Message-ID: <20250311145716.212299943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 21bde60c95230..e42d8959cbf1c 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -286,6 +286,7 @@ else
 	client_connect
 	verify_data
 	server_listen
+	wait_for_port ${port} ${netcat_opt}
 fi
 
 # bpf_skb_net_shrink does not take tunnel flags yet, cannot update L3.
-- 
2.39.5



