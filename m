Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0FB13DBB6;
	Tue, 17 Dec 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455738; cv=none; b=WkN8aKu/C53g4kYp37yeEdN/idgm2UAadKFwLYut/xDjYOnRX0SIifW5V9L8Rn995CqtOVruJel9qOw4fENendkqwY2DruInP42V+zmTgZ/w7tybjSS+6tdtGLsnTbBCuseuoYp8Cn6J2hkR/fF+uCAYbSbGbsHci4Rg2oi7A3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455738; c=relaxed/simple;
	bh=1ZVurX0KJhZKwAwjdTsWuneNcaFkkFcdzbEC9YMHi/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1HDidb/ZSdLCv/l4bgl0nw14KgG3Z9njdyvNXJ4WxcGuWfdLEtmpMTSelz6tf0DXYjQsYt0MBimq7EtzmlK80yV0MYuzkVN6WifnWRlcfJF39hNds7DPhzrG4Um90mDTrDFK8UgG0X7xmepsKpAkLUkRWi4uFmoMdI5hOvWUzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUa4TX1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUa4TX1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DB0C4CED3;
	Tue, 17 Dec 2024 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455737;
	bh=1ZVurX0KJhZKwAwjdTsWuneNcaFkkFcdzbEC9YMHi/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUa4TX1vor6Sx4sTlNOqparIrZ4szSa0Gkp92ONtoPtkmpw27JVH5R0jidhmPpWTi
	 HRluat5eIZS3U5T1JRFgUxPHRN1FPb3pPzfBLbPsRWFyVUrrwj+QsQcKj4yoe95jKU
	 0xOaZxR+0Vlwy2ABRUvOxavMv2nyDChcukg1FMSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MoYuanhao <moyuanhao3676@163.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 03/76] tcp: check space before adding MPTCP SYN options
Date: Tue, 17 Dec 2024 18:06:43 +0100
Message-ID: <20241217170526.384914632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

From: MoYuanhao <moyuanhao3676@163.com>

commit 06d64ab46f19ac12f59a1d2aa8cd196b2e4edb5b upstream.

Ensure there is enough space before adding MPTCP options in
tcp_syn_options().

Without this check, 'remaining' could underflow, and causes issues. If
there is not enough space, MPTCP should not be used.

Signed-off-by: MoYuanhao <moyuanhao3676@163.com>
Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Cc: stable@vger.kernel.org
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
[ Matt: Add Fixes, cc Stable, update Description ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241209-net-mptcp-check-space-syn-v1-1-2da992bb6f74@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -827,8 +827,10 @@ static unsigned int tcp_syn_options(stru
 		unsigned int size;
 
 		if (mptcp_syn_options(sk, skb, &size, &opts->mptcp)) {
-			opts->options |= OPTION_MPTCP;
-			remaining -= size;
+			if (remaining >= size) {
+				opts->options |= OPTION_MPTCP;
+				remaining -= size;
+			}
 		}
 	}
 


