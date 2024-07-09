Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EEC14E2F4;
	Tue,  9 Jul 2024 11:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524270; cv=none; b=fjiEZs6RBtJbxHttZYq7DxIiJDNHmOMS9rXoVrMHd70d0qVx6uix2NegzNNHUoyEh2u/CUtmCChE+xwLJPdgAzIOYLfS6jqQfITTv0u+bVGkfpeaKEcepafhSGjuQxihWy4/iiJNn1aozcRMwKxmT92uVASK1ciNt8OHcTP/wSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524270; c=relaxed/simple;
	bh=bf1RgSfzLto4IVYmjL0QdrI1RGcJlFifbgc6M2a77Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0bba0xI+A9SAW4OUOUKHqMp8a+CjIAvL4IOHzgM5t/HkujCNP6UgzL0aqOLanKaS+UH5G9zSIYLqzoan9ebgvmxExyvxssjbq28x73dEKsc4KzZPpJ/20wIfiS8ez653d5A65Rp5iI2XSDN7hKdPwBRVmaQBqBHJmXmDqLJcfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud/y6E8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud/y6E8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADE8C3277B;
	Tue,  9 Jul 2024 11:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524269;
	bh=bf1RgSfzLto4IVYmjL0QdrI1RGcJlFifbgc6M2a77Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ud/y6E8SUL4tjzzGcefYCzzwgNaEaWX+sszU3PTdXi8//V5J/7n6a8KIM+CpMUMik
	 PuJzUHRmXiEyLlH7uJbuBfBgR1oUi4s3/naBaIbJYiQP1qk5vDKNJckkCyv8QwnJos
	 n+uOiKnB4a6uwS851bjVJLr12cpRalknPGbTs5BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 126/197] tcp: Dont flag tcp_sk(sk)->rx_opt.saw_unknown for TCP AO.
Date: Tue,  9 Jul 2024 13:09:40 +0200
Message-ID: <20240709110713.830485920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 4b74726c01b7a0b5e1029e1e9247fd81590da726 ]

When we process segments with TCP AO, we don't check it in
tcp_parse_options().  Thus, opt_rx->saw_unknown is set to 1,
which unconditionally triggers the BPF TCP option parser.

Let's avoid the unnecessary BPF invocation.

Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20240703033508.6321-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 77109976fe836..7b692bcb61d4a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4220,6 +4220,13 @@ void tcp_parse_options(const struct net *net,
 				 * checked (see tcp_v{4,6}_rcv()).
 				 */
 				break;
+#endif
+#ifdef CONFIG_TCP_AO
+			case TCPOPT_AO:
+				/* TCP AO has already been checked
+				 * (see tcp_inbound_ao_hash()).
+				 */
+				break;
 #endif
 			case TCPOPT_FASTOPEN:
 				tcp_parse_fastopen_option(
-- 
2.43.0



