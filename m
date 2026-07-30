Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E455443A89;
	Thu, 30 Jul 2026 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424921; cv=none; b=O50PCUf4OdO+2X50f/jXXrarkdbqC7kA7juTzeobvPVA5MpLkIh0NbkO4oEs6yccSawRg6/gANnODW28ESYId6V89AI3Qjm2t6xrXBjOSzQt1HAtHZZjH+3cYpISTUlx4Af9M5mpuiirvmHhO1ZxZQE9b9iDiwhVt1Nfay14sE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424921; c=relaxed/simple;
	bh=7ufSTjcETpHsTb8NRtcTwbiqnrxzDkRuMl77bNvoUZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VI5X5bg4hpci7EElxKE3QJt0zkmtjH3t5+XIzZ+dH4x1KPbSsBqJ6BIP6WtosqhhVDn/K25cGw+wsJsWgYtcmnRmrai7cHHyhe55NenDKyFQmUNJ+zVKBjex6BCd1/SCPundjLgttGlAg9V66rT07zn3i3JcWQDCDbRqFmfaQ8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEUPmDyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEUPmDyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AE11F000E9;
	Thu, 30 Jul 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424920;
	bh=xwnbTOVXgWuUSccEoJE0fsXzOwAOSlOpseBIEsaNZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEUPmDyZ5maUIn8Ktxnx8fxrLXWUAc8h9UXGMIsasts0qfpZaVYCeMa2n0SFrRfQb
	 lLK9CmMYRLjkON+73ES1PU+OI55RP3AtjlXjYqSv+WAstoxkta1o3jNk6ABB8puuRc
	 9N8iGTo5PfQgqxF8C3ZB6DwPfINm0vGat5/eRW2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 564/675] tcp: initialize standalone TCP-AO response padding
Date: Thu, 30 Jul 2026 16:14:54 +0200
Message-ID: <20260730141457.119068013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit e1a9d3cc11829c5414a75eb39c704f461936eb24 upstream.

tcp_v4_send_ack() and tcp_v6_send_response() construct standalone TCP
responses with TCP-AO options.  The option length carries the actual MAC
length, but the TCP header length includes the option rounded up to a
four-byte boundary.

tcp_ao_hash_hdr() writes the MAC only.  Thus, when the MAC length is not
four-byte aligned, the one to three bytes after the MAC are left
uninitialized and may be transmitted.  For the normal TCP-AO hashing
mode, those bytes also have to be initialized before computing the MAC.

Initialize only the alignment padding in the TCP-AO branches, before
hashing the header.  Use TCPOPT_NOP, as in the normal TCP-AO output path.
This avoids adding work to non-AO TCP responses while preserving a valid
authenticated header.

Fixes: decde2586b34 ("net/tcp: Add TCP-AO sign to twsk")
Fixes: da7dfaa6d6f7 ("net/tcp: Consistently align TCP-AO option in the header")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260713105631.8616-1-zhaoyz24@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    3 +++
 net/ipv6/tcp_ipv6.c |    2 ++
 2 files changed, 5 insertions(+)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -998,6 +998,9 @@ static void tcp_v4_send_ack(const struct
 					  key->rcv_next);
 		arg.iov[0].iov_len += tcp_ao_len_aligned(key->ao_key);
 		rep.th.doff = arg.iov[0].iov_len / 4;
+		memset((u8 *)&rep.opt[offset] + tcp_ao_maclen(key->ao_key),
+		       TCPOPT_NOP, tcp_ao_len_aligned(key->ao_key) -
+				    tcp_ao_len(key->ao_key));
 
 		tcp_ao_hash_hdr(AF_INET, (char *)&rep.opt[offset],
 				key->ao_key, key->traffic_key,
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -941,6 +941,8 @@ static void tcp_v6_send_response(const s
 				(tcp_ao_len(key->ao_key) << 16) |
 				(key->ao_key->sndid << 8) |
 				(key->rcv_next));
+		memset((u8 *)topt + tcp_ao_maclen(key->ao_key), TCPOPT_NOP,
+		       tcp_ao_len_aligned(key->ao_key) - tcp_ao_len(key->ao_key));
 
 		tcp_ao_hash_hdr(AF_INET6, (char *)topt, key->ao_key,
 				key->traffic_key,


