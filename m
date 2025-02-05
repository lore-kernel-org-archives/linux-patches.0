Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B5CF510;
	Wed,  5 Feb 2025 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764344; cv=none; b=DSua8X4B8Rh8RgI6qggh6LMK4xlc0tb2cI4yNQgVTykiZ+qQOeREtHUrjaiuUsbD0IWBxhlgT7DhDC0U2W/2wOvqowv4vabeONi3xSGy2QuAxg4EiCt2f8gSmu2mDorm9LZeFi5REdHFFUmLXhsU1kyQ6EkUwC9UjB0i7hkNeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764344; c=relaxed/simple;
	bh=UIDtfOLE+9UQb4pE09RXLo6xmeFlp/2sMDW9fabR67c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDdUqk3l2sMQf1Tab61jm3+NorHSv+zLmEzo1NWl0ek6zd9FQy2G8TXFMOQ1bQ2DAmQNc+fsnyP8LPXgmLLptaEqnDQEKk7UWfqI07om9PwDRylqbQg0hBqn2wDg03rmMyeuKCSl+nJm+PE+a4tBr5azuR4G/oz+JmcPliirLF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goVwdUbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goVwdUbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBB1C4CED1;
	Wed,  5 Feb 2025 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764343;
	bh=UIDtfOLE+9UQb4pE09RXLo6xmeFlp/2sMDW9fabR67c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goVwdUbBTRV/fLP/wcaa/ByxzvBc2t5Vxw03wu8i11lm7Gcy2BzdW9LHnAz8CRgIK
	 fnIe2WHM1YhHPLJTwQwmSa4EJWPXcRvnkpUrtS1XCp6uGRfMHvTYkiDx/4tDYi9SCL
	 AbaIgPJ9vgBVVA8wXMyk02e4gHUsU5KprfAL+tnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Leogrande <leogrande@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/393] tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind
Date: Wed,  5 Feb 2025 14:41:13 +0100
Message-ID: <20250205134426.193947094@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



