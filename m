Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2061420D4;
	Tue, 27 Feb 2024 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042452; cv=none; b=Owmttk4ylmKNYzN4AxawD31p+r6mI73TTiqSxJj5uBuTC6LZ/4GtfH+skj8mHrwFM5s5HaFPsOfc3fn6/47gbAQFhcxcTNpTtOZ2BnUnXSDMoRP/oaX75s4VYHGZOptoSDB/IPVQ7krZb4Bud98rGRrJrnfKYw8x0OasnthPfko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042452; c=relaxed/simple;
	bh=9d+KeoL4zYIf6VgK/gI2GuUvLQnJthw8d0jYeDQIH6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEUgi6cMnZXHk3LDA8ggcn/x13r8EuY/CVY/vS1Istg4WZ7b2llokguQQONk5ORmU8ZiPbfb2erV68tQnenltOewnywSNUOFpOfPTCAsLRepqy4zDAHrQS3AGsVu2fjkCPAghi0Jxu39KG0FIAcTmbouc9kGvkviGvhYU/9ayB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObPJuaN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObPJuaN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C16DC433C7;
	Tue, 27 Feb 2024 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042451;
	bh=9d+KeoL4zYIf6VgK/gI2GuUvLQnJthw8d0jYeDQIH6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObPJuaN4i4YAoabJoc3IAFZxzOkBpWZLFlqzzjtM7e6DCbNC8b3hFLoggJssMrgVQ
	 38BLVN/M9Ojo5Kp27k7thHOsAvJAB5MEhbKCdZy1VXgiJbNmAwhE76/VJcKYn/vGco
	 1e/SVpnvleXD06tGpljQKNvqRGjUbYLsqF1EXrp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/299] net: mctp: put sock on tag allocation failure
Date: Tue, 27 Feb 2024 14:26:27 +0100
Message-ID: <20240227131634.559363383@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a47a58aa54b4..6218dcd07e184 100644
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



