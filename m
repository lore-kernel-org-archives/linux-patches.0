Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE21D13B7AB;
	Tue, 27 Feb 2024 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043625; cv=none; b=D74Ou87+WK3GssRMMnFUvsCX7pLaVyinzB+5SQtakdIj1XNH37YV6CoN+ri5cPfEcSiKBLwIQp1CljOMOxhsEJ8TTfEF1UVUWUXP+qXWjEap4u2fVYRWJvmjo/PVoROkAHHfQy2pVbPDcO+AFIqJra+fPs2sl+DKi/UMNVQM/pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043625; c=relaxed/simple;
	bh=qyxKUWJF9A0f4JAfhcFXPINjtRFQBSu4I+s2fc44s0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbBl+GaMjLF6juLc1nxpCcidWi8XDNrd3obNyw7hCcrx85hEw4BpH1yBkOwV68WnlHJcfAjAQeBAPJZVpAuh0kp3tWFYeQJTqR5iPZmAVjz9FFwk3UexAFranR+B2WiYRW/rjQOwFhYNh0ybHXuE//h50vy+RrgeaxLvPN6vQpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asTxmh32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asTxmh32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B165C433F1;
	Tue, 27 Feb 2024 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043624;
	bh=qyxKUWJF9A0f4JAfhcFXPINjtRFQBSu4I+s2fc44s0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asTxmh32Esj0qwbcWGH+vDqt73cRyM84s4wTv3ZZIHy/nLvz/UNII5qeZZxUFablP
	 VICM3drApteRP6DS6u4GtaSVFgl7G0sM0JbLs2XlpXPgZDlDEiyQZUSNFHquzx1ynF
	 PpMWsM3hxzLzuGBc6aIpJbqAi4UKwYasd4oqrgU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/195] net: mctp: put sock on tag allocation failure
Date: Tue, 27 Feb 2024 14:27:17 +0100
Message-ID: <20240227131616.215598146@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 9990889be14288d4f1743e4768222d5032a79c27 ]

We may hold an extra reference on a socket if a tag allocation fails: we
optimistically allocate the sk_key, and take a ref there, but do not
drop if we end up not using the allocated key.

Ensure we're dropping the sock on this failure by doing a proper unref
rather than directly kfree()ing.

Fixes: de8a6b15d965 ("net: mctp: add an explicit reference from a mctp_sk_key to sock")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/ce9b61e44d1cdae7797be0c5e3141baf582d23a0.1707983487.git.jk@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 68be8f2b622dd..256bf0b89e6ca 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -663,7 +663,7 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 	spin_unlock_irqrestore(&mns->keys_lock, flags);
 
 	if (!tagbits) {
-		kfree(key);
+		mctp_key_unref(key);
 		return ERR_PTR(-EBUSY);
 	}
 
-- 
2.43.0



