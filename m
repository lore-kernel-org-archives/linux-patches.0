Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147D51A6803;
	Tue, 16 Jun 2026 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630366; cv=none; b=qlLTWDSs5FVBvLkWVUkVBD7CctxATFzRuBQoE07R+pw3cmiDr5GJ6cSCp4yegB+qWxccVHHXnRfAcXLLVvGvXhyI8gGQCD1GVvQMNLaHJyJt80sHibm7EIQHvpTcSp5gqCRCXNe144GWtnPd9iXpfHbPTZc9DGv7FN3G6DrsTfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630366; c=relaxed/simple;
	bh=jsl4OoZ0mheyRzy5kl0NqKCUmluNt+KFEGQmBcIrFSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSffKtf8ja4CiQCsNxXna1I7FGt/CAxG19lQ0vMyIzhuE+a0fK3zWSo4xhEAa+Md/f7PU0UD8ZU5wvKyQQaT3B61RsvwoiQzAVLg70OGAou/MVsPJ0dDv0D0tkIFfDkrxYPV31bkf94EU7X09jLP5wDdEOrez0nveGTkTMyO4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tlibf1Jj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tlibf1Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05021F000E9;
	Tue, 16 Jun 2026 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630365;
	bh=leWajpUQG5lyLPFCTyfydrsq6ATNbOruh9X2lZabyIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tlibf1Jjm6FcoQ+YWo4gDBd35pFDACzBn8p2sgWAc5kYqMnxk7vXehqIrrFWrk2wV
	 X1ArBaRyMtyXInvpnWAiVuPASpPtsF5v3UkPHIKa4mo+gkDR/OopRxbvAwXrgYYPp+
	 Ba4BrhynOtr11DIjSkdC/E9HHZN8Rzk+Qt4UhxL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/522] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Tue, 16 Jun 2026 20:22:34 +0530
Message-ID: <20260616145125.717105510@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit f4268b466190dae95a7585f69b4f1f8ad097632c ]

llcp_sock_release() unconditionally unlinks the socket from the local
sockets list.  However, if the socket is still in connecting state, it
is on the connecting list.

Fix this by checking the socket state and unlinking from the correct list.

Fixes: b4011239a08e ("NFC: llcp: Fix non blocking sockets connections")
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://patch.msgid.link/20260429134115.3558604-1-lee@kernel.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index cd0fd26196b8b6..6cdcc49a58bcd5 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -633,6 +633,8 @@ static int llcp_sock_release(struct socket *sock)
 
 	if (sock->type == SOCK_RAW)
 		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else if (sk->sk_state == LLCP_CONNECTING)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	else
 		nfc_llcp_sock_unlink(&local->sockets, sk);
 
-- 
2.53.0



