Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B832D3EEE;
	Wed, 25 Feb 2026 06:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002734; cv=none; b=swQZe3U3HszapmWTPuEd8PJ/aUTlXL7+FydTQsScn/qq8rEan/6zvr4EQ96CBuS2QIZTe21/74VonwqAMUq9LWs66voEFmHReAtF2u9Rc3XrJutiRPqh5SVbyQ8sN6e1hxK2aC71eC6Puzv2Av1HahBMv/QwEXZyHWr+BRph2Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002734; c=relaxed/simple;
	bh=9UH7RRP+VK2ii3Z9aBDAsZh2ZP2zedgnw0ayOYkxso8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/F5L7poSiY/L7C9TESY5jpPMNMTNQNlBo93dfbiHgE996GE9HEjemYBgUE37QLvbzCHIAbITAHfqnDGzEUqTz7tZXvRtioP3p2RL6x0YpRv+AqC537xdh0qWd9Vb//Jv7/vbnv9BB88pBtrJMtogAA/+BXtS/w+noAW+6lKr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inouRTIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inouRTIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D53C116D0;
	Wed, 25 Feb 2026 06:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002734;
	bh=9UH7RRP+VK2ii3Z9aBDAsZh2ZP2zedgnw0ayOYkxso8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inouRTIJYq6S7PH9H8du5d5aBzlv4nOfazRpxtobJZNK7/53KGJMySqkK9+NXUbzJ
	 FqFIuz7gpnY4Sbk1LtKtNAdPGIU+j4f2KRSwE1pVYm3hUDKxyS3Z6PGtyNgPmtdSwv
	 G8KqAzBWDv6/Y1Mk6ml5qPxEmoQ4+0FF+4a2xuU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 549/641] selftests: tc_actions: dont dump 2MB of \0 to stdout
Date: Tue, 24 Feb 2026 17:24:35 -0800
Message-ID: <20260225012401.828305978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 32b70e62034aa72f8414ad4e9122cce7ad418c48 ]

Since we started running selftests in NIPA we have been seeing
tc_actions.sh generate a soft lockup warning on ~20% of the runs.
On the pre-netdev foundation setup it was actually a missed irq
splat from the console. Now it's either that or a lockup.

I initially suspected a socket locking issue since the test
is exercising local loopback with act_mirred.
After hours of staring at this I noticed in strace that ncat
when -o $file is specified _both_ saves the output to the file
and still prints it to stdout. Because the file being sent
is constructed with:

  dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$mirred
                                ^^^^^^^^^

the data printed is all \0. Most terminals don't display nul
characters (and neither does vng output capture save them).
But QEMU's serial console still has to poke them thru which
is very slow and causes the lockup (if the file is >600kB).

Replace the '-o $file' with '> $file'. This speeds the test up
from 2m20s to 18s on debug kernels, and prevents the warnings.

Fixes: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260214035159.2119699-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/tc_actions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index ea89e558672db..86edbc7e2489b 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -223,7 +223,7 @@ mirred_egress_to_ingress_tcp_test()
 		ip_proto icmp \
 			action drop
 
-	ip vrf exec v$h1 ncat --recv-only -w10 -l -p 12345 -o $mirred_e2i_tf2 &
+	ip vrf exec v$h1 ncat --recv-only -w10 -l -p 12345 > $mirred_e2i_tf2 &
 	local rpid=$!
 	ip vrf exec v$h1 ncat -w1 --send-only 192.0.2.2 12345 <$mirred_e2i_tf1
 	wait -n $rpid
-- 
2.51.0



