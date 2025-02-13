Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676B281349;
	Thu, 13 Feb 2025 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457303; cv=none; b=Q+/p/KBZAwSzbbU+m93MEcek9uTPM2HqjODVRpv6ns2Ewpfo5gLenk4Rjm0MN4U2xIv5+ksjpjLSyxn1ea9DtKRcgqmRhjP4pZZStB9FlasskMjApdZVUqMSvsE9rheZ0YCRdlcrD4QToBi2IAbxjYWdi6/+eHc9X3vNbqwwhjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457303; c=relaxed/simple;
	bh=PSCH1uWI5mhWZ9/s9CkcLQdF7Vazxj94NG+nLOk+ocI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXBr/86Q9oddguh1HLWO/9UQRa2OmJ6CkAA2/fvKdObH5cOZ91a7CtLHcca3hWOU8tCnrEY+5QZgXVPUI914C3lm9cM2zRPvrLqo8cQYuaaMQqwaFxbjXE4mpEl79ZMq4p9P7/yr1zS7fL673nQhUHQFeqEct58UoVRmTkKM3nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dR8sEeG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dR8sEeG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55962C4CEE2;
	Thu, 13 Feb 2025 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457302;
	bh=PSCH1uWI5mhWZ9/s9CkcLQdF7Vazxj94NG+nLOk+ocI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dR8sEeG3pZjmY4S4BAR2y1HBHm/KHBuGK5Nq1nRGm+dMMcEwqaKUSShxb3fhRnpVD
	 HW7ho9Xsm1hbkJUKPXK7Ng97F94DuPgk7ei9BztOJiFsOPuxYJlzc8AVDLiBxFY1ik
	 bcnr4A4OOJycM8kvde4rtAhfGfprOOZ7tvQk2etA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/422] tipc: re-order conditions in tipc_crypto_key_rcv()
Date: Thu, 13 Feb 2025 15:23:42 +0100
Message-ID: <20250213142439.374559158@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5fe71fda89745fc3cd95f70d06e9162b595c3702 ]

On a 32bit system the "keylen + sizeof(struct tipc_aead_key)" math could
have an integer wrapping issue.  It doesn't matter because the "keylen"
is checked on the next line, but just to make life easier for static
analysis tools, let's re-order these conditions and avoid the integer
overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 43c3f1c971b8f..c524421ec6525 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2293,8 +2293,8 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
 
 	/* Verify the supplied size values */
-	if (unlikely(size != keylen + sizeof(struct tipc_aead_key) ||
-		     keylen > TIPC_AEAD_KEY_SIZE_MAX)) {
+	if (unlikely(keylen > TIPC_AEAD_KEY_SIZE_MAX ||
+		     size != keylen + sizeof(struct tipc_aead_key))) {
 		pr_debug("%s: invalid MSG_CRYPTO key size\n", rx->name);
 		goto exit;
 	}
-- 
2.39.5



