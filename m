Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6FD1C07DB;
	Tue, 15 Oct 2024 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997550; cv=none; b=uT0STNbhk1V40GhWE99JcKUoq+ERl58mWCtvoPqkfwVnNPgDTvfSOMngR2pdpqLcpQ9TYzsN0szrtmeG+owzzdrw8SeGIi33Hz8/oRXUhjjmv+BB2anBOkkvMzS2M3nUzXE6eUilPSx3ReIXfKYU9R+NgkTjSERMwlbrtWzwlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997550; c=relaxed/simple;
	bh=PChTGTrhfvUQXh5MDnNpVmYywyFiYKX2Ksio/DRske8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EauXW3XN5D/uBPFWbBH7FKYq+/h7zGDM0SYwA5DnEKTzf4lbrDF96z4GgTvSxe/qe1By9J1jlPiNcmoa96n6XcakttTbrSL9wuKBfvWAh/cjutnMXzAR2Cp97S8hPYLPv/dmO34SfFpDD2d22yiQF822wW+8a43I+CSMkaT8v6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKyF3ZIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKyF3ZIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B0C4CEC6;
	Tue, 15 Oct 2024 13:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997550;
	bh=PChTGTrhfvUQXh5MDnNpVmYywyFiYKX2Ksio/DRske8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKyF3ZIH4L8zvBm2ZCI5vZKnm8RMVhYbvir4lrMEulieQ5Q18lnc5eDG/yKzscZGs
	 xb8MoHcWvRsqDotqtdNPz8ZzvwyHjKoWcIS4qtYPBwuRlAj6qkGjWvasv0CD5JuH1F
	 Dgo6tnkMEgOzw4qj/GTIjiTr+ToOm9Y3FPDz+hxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.10 216/518] mptcp: fix sometimes-uninitialized warning
Date: Tue, 15 Oct 2024 14:42:00 +0200
Message-ID: <20241015123925.331546959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

Nathan reported this issue:

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 LLVM_IAS=1 mrproper allmodconfig net/mptcp/subflow.o
  net/mptcp/subflow.c:877:6: warning: variable 'incr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    877 |         if (WARN_ON_ONCE(offset > skb->len))
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  include/asm-generic/bug.h:101:33: note: expanded from macro 'WARN_ON_ONCE'
    101 | #define WARN_ON_ONCE(condition) ({                              \
        |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    102 |         int __ret_warn_on = !!(condition);                      \
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    103 |         if (unlikely(__ret_warn_on))                            \
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    104 |                 __WARN_FLAGS(BUGFLAG_ONCE |                     \
        |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    105 |                              BUGFLAG_TAINT(TAINT_WARN));        \
        |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    106 |         unlikely(__ret_warn_on);                                \
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    107 | })
        | ~~
  net/mptcp/subflow.c:893:6: note: uninitialized use occurs here
    893 |         if (incr)
        |             ^~~~
  net/mptcp/subflow.c:877:2: note: remove the 'if' if its condition is always false
    877 |         if (WARN_ON_ONCE(offset > skb->len))
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    878 |                 goto out;
        |                 ~~~~~~~~
  net/mptcp/subflow.c:874:18: note: initialize the variable 'incr' to silence this warning
    874 |         u32 offset, incr, avail_len;
        |                         ^
        |                          = 0
  1 warning generated.

As mentioned by Nathan, this issue is present because 5.10 does not
include commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling"),
which removed the use of 'incr' in the error path added by this change.
This other commit does not really look suitable for stable, hence this
dedicated patch for 5.10.

Fixes: e93fa44f0714 ("mptcp: fix duplicate data handling")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/20240928175524.GA1713144@thelio-3990X
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -871,7 +871,7 @@ static void mptcp_subflow_discard_data(s
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	bool fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
 	struct tcp_sock *tp = tcp_sk(ssk);
-	u32 offset, incr, avail_len;
+	u32 offset, incr = 0, avail_len;
 
 	offset = tp->copied_seq - TCP_SKB_CB(skb)->seq;
 	if (WARN_ON_ONCE(offset > skb->len))


