Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192821F5404;
	Tue, 21 Jan 2025 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482449; cv=none; b=rc22RNsLJgs0sHygHFjH71HO05Y8d3vp9TCAwobtv162rn2oCVyGdVRKVw5By91Eoin5ARJHa29fdLegri32C+MjN8ifgjQUUBjOm7ao5JjN+BkAWR6BHAHlSA4fXkaDqFx/zDWxNTZOXPKgxm2XZZf6leucf2kwnuFYxJabB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482449; c=relaxed/simple;
	bh=cNDiuF/FqNVWFgCpr8tvq4uAq4ClICzzuSgegD7JSs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQTz/29ZH/XOdam7wnkSeJVhMBv0BugrhZQ0oD7T19p+6HmIprup3Cq89RIFpcsqjQDgw28K4QpzpP9EVGPJlYqIu2w0ip/+DszUhR249/lOb0ttyhMNsPbSRSNwlBBBnHPRRfVKcH7+04Ccqm2+wzxUnZDI75E3Ap5ecF9E3AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkgnZ6OG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkgnZ6OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95819C4CEDF;
	Tue, 21 Jan 2025 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482449;
	bh=cNDiuF/FqNVWFgCpr8tvq4uAq4ClICzzuSgegD7JSs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkgnZ6OGp6EQ+CO9egcSxDi5Uq72vZy7gviWWdqXGHRucvfgV/1NwFpNWWXRBQQOO
	 ByvL8LqydU68FiYSbYX9+82pPU+/SWvvPjRakxrfIISpyX2dT2kdjn6DuoLNyj2TuI
	 J59kDgDBlWO9rofIDIGjpsGlPBV3yYRqk+8xU4vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 081/122] mptcp: fix spurious wake-up on under memory pressure
Date: Tue, 21 Jan 2025 18:52:09 +0100
Message-ID: <20250121174536.132771540@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit e226d9259dc4f5d2c19e6682ad1356fa97cf38f4 upstream.

The wake-up condition currently implemented by mptcp_epollin_ready()
is wrong, as it could mark the MPTCP socket as readable even when
no data are present and the system is under memory pressure.

Explicitly check for some data being available in the receive queue.

Fixes: 5684ab1a0eff ("mptcp: give rcvlowat some love")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250113-net-mptcp-connect-st-flakes-v1-2-0d986ee7b1b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -760,10 +760,15 @@ static inline u64 mptcp_data_avail(const
 
 static inline bool mptcp_epollin_ready(const struct sock *sk)
 {
+	u64 data_avail = mptcp_data_avail(mptcp_sk(sk));
+
+	if (!data_avail)
+		return false;
+
 	/* mptcp doesn't have to deal with small skbs in the receive queue,
-	 * at it can always coalesce them
+	 * as it can always coalesce them
 	 */
-	return (mptcp_data_avail(mptcp_sk(sk)) >= sk->sk_rcvlowat) ||
+	return (data_avail >= sk->sk_rcvlowat) ||
 	       (mem_cgroup_sockets_enabled && sk->sk_memcg &&
 		mem_cgroup_under_socket_pressure(sk->sk_memcg)) ||
 	       READ_ONCE(tcp_memory_pressure);


