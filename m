Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBF831578E;
	Fri, 21 Nov 2025 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731025; cv=none; b=fvFNeuUopt6/YKfF1vRCVLCNk+9UAHiNYiMbdMfCwXcZG9/LOWCM90bGpfk+kbN94x0Whh8J8wCvLhUqxRY5log4ik7+5k0lkDvbTkK5lfbchWDoE8zagyBQAlf26P1/ec1cWmw8H3AWtvBUSQLV93pFubzoVcly4plHlo5bVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731025; c=relaxed/simple;
	bh=hXBdNy5z8sHNDuMijwYmcDBZtBUdHSllySBw8nocReg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd3YZv2CwQwEjChhsVcaXm7nXZ6D+eKp3xFqhaUE6kbpaG754/FNIRCri9bLlgBXzmqbvLRQH761yDglmMo0kIIZlx0yZzFMWGCmroxQLJKFe3ZVn/RjPf8BoxUW/vi6qNMJTx2uIRg9vdy3E4u+UCWjwtQfVAucRNSI48N55eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZPMi/oM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZPMi/oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5707CC4CEF1;
	Fri, 21 Nov 2025 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731025;
	bh=hXBdNy5z8sHNDuMijwYmcDBZtBUdHSllySBw8nocReg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZPMi/oMh/tjR/qZtjsC/BS1IzI/zNGTSnsDi1MHOznwjTr/bpN7GNrjlrEGeT4af
	 vGPsQde0n1NgyD1d44154conk5k0GTxAKYLU+7YUbVGT0NTVE1emBtr/bVy+gpNZPi
	 FiqmewGN36REtLT1f0qmaeMejYlPLBovoxU3pFAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 064/247] net/handshake: Fix memory leak in tls_handshake_accept()
Date: Fri, 21 Nov 2025 14:10:11 +0100
Message-ID: <20251121130156.899826615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 3072f00bba764082fa41b3c3a2a7b013335353d2 ]

In tls_handshake_accept(), a netlink message is allocated using
genlmsg_new(). In the error handling path, genlmsg_cancel() is called
to cancel the message construction, but the message itself is not freed.
This leads to a memory leak.

Fix this by calling nlmsg_free() in the error path after genlmsg_cancel()
to release the allocated memory.

Fixes: 2fd5532044a89 ("net/handshake: Add a kernel API for requesting a TLSv1.3 handshake")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20251106144511.3859535-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/tlshd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
index 081093dfd5533..8f9532a15f43f 100644
--- a/net/handshake/tlshd.c
+++ b/net/handshake/tlshd.c
@@ -259,6 +259,7 @@ static int tls_handshake_accept(struct handshake_req *req,
 
 out_cancel:
 	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
 out:
 	return ret;
 }
-- 
2.51.0



