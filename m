Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056149;
	b=uDBYH2M8km1ET/eh/pqWbJG+c2DLaaQ4rbM66iub+yiySXUcJwi+EJUnxzfHc7Fl9QeG
	 JnYVr9KHns/98owzn4AOEfl/PiaWLKScqUYY42/wVQA8Mk027Bnyjp0KcoCDu2N4jqVVP
	 BGJ160EihgJrdOBSX1t9AzAzOb+x98O915TOHxNI0BmlFsBUknOEhQD+wg5ZLkK3AkF03
	 EafTzt7mMHCPLNj1cMPKhXvTVqkNpKphwqMHhODMxY2fiha2tjMDyMcCb1WqhYEQ6kIPV
	 y23eTo2RQHsuH5AOv2Kj4oxSWY7794oAEaxhrCwQpssocaFkPRCtRD2yyIVeTDRcb0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yfyfykmpI47RXb6UgAEdw4DwXOHBAqic2bic2HzXsy0=;
	b=HXjSiktgpnGknGsC6JdSt4gAoKmpoq/GGMQsvDgXr0oEwwnyGkIB8lZODJUO7f8FwvvU
	 A+kCFKAl6azm0WO6NmY+4Bt/S2nLPQ62jaR2Cen1z+1DODZeE22hb9YeP0LOQutr1azyI
	 oTEYx5WHXViYsmiHqeO6EDiibdSC9Z1q2ocvgtvj3Od5dCFdLhOgPPcr9LLAogo23xHlr
	 zCMG1xD3QXnX0ybQvyH9GQiCMTDIcCTU1GFDM4wZpS9a9MlKxIvpblfBnMTzNvFichHah
	 sPHJ8onee4zn2/O4Bvx7UoIMpO1DQLrhoW8eW2Ze8tdAkwFCm4dYsZXMeF+TO0rfP3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e74H83kl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E69606A31C;
	Thu, 19 Nov 2026 02:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e74H83kl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207C11F000C7;
	Thu, 19 Nov 2026 02:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056149;
	bh=yfyfykmpI47RXb6UgAEdw4DwXOHBAqic2bic2HzXsy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e74H83klIYu1puNpLxv/BLn6TI6N+43QPdLvXigvPJh849Ikm+tSQxUpkXj7BzrkY
	 M4qRI52wQOuvKHrC9KRvd4ttXR2fJmDlAWBwkcJifklB7D5PuYHD98IkFUPTvJtlS/
	 TkPLecgPWwqXcLus6NYRUmo3BzGEQeMI+TlqX1IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1885/2214] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 15:59:21 +0100
Message-ID: <20261118150126.639581402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 2ba01cf7b2598571486425a0605f1434909b532d ]

The uprobes code emulates some instructions, and with that also
PER storage-alteration handling, in case a debugger is attached.

The PER storage-alteration handling contains an off-by-one bug, which
may lead to PER traps which should not happen. Adjust the comparison
in sim_stor_event() to fix that.

Fixes: 8d1a2427d8fc ("s390/uprobes: fix user space PER events")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index bd3ef121c3798..eed94574764ca 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -254,7 +254,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
 		return;
 	if (!(current->thread.per_user.control & PER_EVENT_STORE))
 		return;
-	if ((void *)current->thread.per_user.start > (addr + len))
+	if ((void *)current->thread.per_user.start > (addr + len - 1))
 		return;
 	if ((void *)current->thread.per_user.end < addr)
 		return;
-- 
2.53.0



