Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CBD19E7F7;
	Tue, 16 Jul 2024 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145327; cv=none; b=bd6W6rxh145IArwtYtv/D2HRIOxVsSiWrib8IVfpD2FrBXMzkvFgop9mGpOdUFT1MBDm6vpGrQy6V9AYoTwHtNd4A6VIzHZc2M9etC3P9tx4ZrydbQO2dh50hF6VNdGVcihWiu7guxpfXw9+T/uWaCW4EQB5KhQVN0VfqJnMWrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145327; c=relaxed/simple;
	bh=g2jXP5oy6S1XKm8ZmFk4MgWRb+m+lTu4kd9K1Ygsolg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K79AvzuNSuQgTuOwacjGg0J91qKVi1JKs3mIsmPp0pP4SYLADtGeX3xNz7V78wxkKsDsY0aPmDq6oogItbSbFFi17T+lld2Z2I4YVSUSAswoUOnDz+SNVyyiYbLgACjr00Z7TAEvxpTWH2UrZZDbb6bPDEAV2MUjHSduo1u7mqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC8acTJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC8acTJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE8AC116B1;
	Tue, 16 Jul 2024 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145327;
	bh=g2jXP5oy6S1XKm8ZmFk4MgWRb+m+lTu4kd9K1Ygsolg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC8acTJfU9kKW9RNY7xKFZn+kmoi6C5jecNHad19RdKRRknh3jqbpFhGLLcCMixJI
	 LxB4Dp4Ygai81UR+Q4/TYGgpHJiv1QLyPoNjQKpKVoP1bvTixpFaloOWKn+NimEONQ
	 koC90NCpuF6CcfQMat/vOVtStppax+3vT4vCxx94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lex Siegel <usiegl00@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Neil Brown <neilb@suse.de>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/96] net, sunrpc: Remap EPERM in case of connection failure in xs_tcp_setup_socket
Date: Tue, 16 Jul 2024 17:31:40 +0200
Message-ID: <20240716152747.634862446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 626dfed5fa3bfb41e0dffd796032b555b69f9cde ]

When using a BPF program on kernel_connect(), the call can return -EPERM. This
causes xs_tcp_setup_socket() to loop forever, filling up the syslog and causing
the kernel to potentially freeze up.

Neil suggested:

  This will propagate -EPERM up into other layers which might not be ready
  to handle it. It might be safer to map EPERM to an error we would be more
  likely to expect from the network system - such as ECONNREFUSED or ENETDOWN.

ECONNREFUSED as error seems reasonable. For programs setting a different error
can be out of reach (see handling in 4fbac77d2d09) in particular on kernels
which do not have f10d05966196 ("bpf: Make BPF_PROG_RUN_ARRAY return -err
instead of allow boolean"), thus given that it is better to simply remap for
consistent behavior. UDP does handle EPERM in xs_udp_send_request().

Fixes: d74bad4e74ee ("bpf: Hooks for sys_connect")
Fixes: 4fbac77d2d09 ("bpf: Hooks for sys_bind")
Co-developed-by: Lex Siegel <usiegl00@gmail.com>
Signed-off-by: Lex Siegel <usiegl00@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Link: https://github.com/cilium/cilium/issues/33395
Link: https://lore.kernel.org/bpf/171374175513.12877.8993642908082014881@noble.neil.brown.name
Link: https://patch.msgid.link/9069ec1d59e4b2129fc23433349fd5580ad43921.1720075070.git.daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 05aa32696e7c2..02f651f85e739 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2333,6 +2333,13 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		transport->srcport = 0;
 		status = -EAGAIN;
 		break;
+	case -EPERM:
+		/* Happens, for instance, if a BPF program is preventing
+		 * the connect. Remap the error so upper layers can better
+		 * deal with it.
+		 */
+		status = -ECONNREFUSED;
+		fallthrough;
 	case -EINVAL:
 		/* Happens, for instance, if the user specified a link
 		 * local IPv6 address without a scope-id.
-- 
2.43.0



