Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F2912BEA0;
	Mon,  8 Apr 2024 13:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581993; cv=none; b=D9X6GLcnv8bzooPKRMnbEBluv/pgF25fmzXZRBuTJhZ9PffOB8Bhk62QsAPBstZ8QSt7rryYxweK3KL96CfcNPS8X1DF2d/PfHEOzoWlSgvHYZpA0SeGFT+K62l/ncNJE6tu2qvyd1cYpz5WpDHLxfLIdo1bZR2JiioaIrNbO/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581993; c=relaxed/simple;
	bh=A16dzNdHfdpZ0qTU0qj12nJHY5EP8NtL3kHpy23UgfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dekezO5UuW01iJc039aoj2UgWsDGnMZ2EZzKaD8HndQKxoy2dJUWL1AAZRnWMuRMQkhNmZe5gZS7536GPvuiRPn6qi5MqPqX48O1wACFSAzGb3IXO0+mzrlQ1LF3UEIhDr0sr36hh58rttvBndR+1Q1+2gPRdO+e1oas5ql9nMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaiFHDf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaiFHDf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCB5C433F1;
	Mon,  8 Apr 2024 13:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581993;
	bh=A16dzNdHfdpZ0qTU0qj12nJHY5EP8NtL3kHpy23UgfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaiFHDf5+LGsclcWMvRMigq8zSDuKGJocxTWdPqVNJ+oI7J08Tf5zKh6rLCrCZ5Mt
	 IXqJeHl0yEzHV9oydlAcLZyon80Fb7MQ9LNNJZda4AUAN4PYDGtD0q7zA3CNqtBqsk
	 LQp/kxGM2xbbSYJXaBWOzyJ5clQaH7OzjJr8t6pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 038/273] tls: adjust recv return with async crypto and failed copy to userspace
Date: Mon,  8 Apr 2024 14:55:13 +0200
Message-ID: <20240408125310.475239315@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 85eef9a41d019b59be7bc91793f26251909c0710 ]

process_rx_list may not copy as many bytes as we want to the userspace
buffer, for example in case we hit an EFAULT during the copy. If this
happens, we should only count the bytes that were actually copied,
which may be 0.

Subtracting async_copy_bytes is correct in both peek and !peek cases,
because decrypted == async_copy_bytes + peeked for the peek case: peek
is always !ZC, and we can go through either the sync or async path. In
the async case, we add chunk to both decrypted and
async_copy_bytes. In the sync case, we add chunk to both decrypted and
peeked. I missed that in commit 6caaf104423d ("tls: fix peeking with
sync+async decryption").

Fixes: 4d42cd6bc2ac ("tls: rx: fix return value for async crypto")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/1b5a1eaab3c088a9dd5d9f1059ceecd7afe888d1.1711120964.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3cdc6bc9fba69..14faf6189eb14 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2158,6 +2158,9 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek, NULL);
+
+		/* we could have copied less than we wanted, and possibly nothing */
+		decrypted += max(err, 0) - async_copy_bytes;
 	}
 
 	copied += decrypted;
-- 
2.43.0



