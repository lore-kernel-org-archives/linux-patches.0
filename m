Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C24522A;
	Wed,  5 Feb 2025 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765666; cv=none; b=XszOiHUzN8ZEhc9n07W/BGCNMzZM2jEqkT29dkAHF62aN9zgx4F5F4H4sf9s0l92xNCNZyz95DEbMGKozTGoGyJNkIXO+LyaFgbMNQr/CpzA1x37sixoWbLcVqOxNFVlBPu+aNiKvtja6jpHRh2rgjdMPhniverMi3ZMKq/l7sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765666; c=relaxed/simple;
	bh=36PrKp+gUZ14vbqybkYa5G2pAmzxon3VnViepLb04BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9aeESLX7IrV/mJ3edR3V5M0VebhW+omzhwjcxTUVxGo99EtFoCAKXG+0WoKSFAb2YO6Wgs/0IFcIzeLmQzeJh839HOly1abZB4ajjGDPWL1EQuQAFpeLWad7e3kjciRNvSx3B4UdBvXkVbonZ7Dc3NxjldBj4ZaLwNenRCCMzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT64XF9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT64XF9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D6FC4CED1;
	Wed,  5 Feb 2025 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765665;
	bh=36PrKp+gUZ14vbqybkYa5G2pAmzxon3VnViepLb04BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT64XF9e3qY6UdWz5Fra8O3rl+ajqzRICfpxC/Bl7Eve9dLOIZRvkYOl9e1D8VF6F
	 WHVprRazYHYM6PDFZW9m9g8evKAHxio8LB8A2jKj8oRMuWJpO1gbZaVYN05lB9hv1R
	 U7y0nwGsi8qDFyLFobBhlZOF/pyyLnWI7wX01BQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Leogrande <leogrande@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/590] tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind
Date: Wed,  5 Feb 2025 14:39:56 +0100
Message-ID: <20250205134504.503690125@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



