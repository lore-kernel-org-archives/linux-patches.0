Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC2513DBBC;
	Tue, 27 Feb 2024 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043945; cv=none; b=f/jOP1Dhm7PKcc3VfwEPRFLcO3SNxFwox+/+VCd7RjJCcqv41itKvFdEr5JUoU99Sep8BoMxSINICwU6WqBSW8yNo45ErWp4SxwWi8yXs0BcdVt0HwEaUFPVRxyg2Y8hRX2CxvovDm9zHmL8tNRQ9YxR1rlPdAv3c6DuolX6kug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043945; c=relaxed/simple;
	bh=dA31BvxS1aqAfri8l2ERPw5A1ZW5Q0hQnHYUTV/AmlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpGR7UM1quDUTljoNyZVxpYkX3dCdrTbPMfdxv66gERhabcE1EfeOj6ch+nrJ0iYvTBj4t+yWhP1D3/S4ubdw9ctUts07EFPIhbRuiRACnPAUKTfKTLDIwghK6FtzZaA76TyiPm2XiTBIWKOg8hjobfqbEUM7av5a/gRENn/F4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKrQOVRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKrQOVRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D95C433C7;
	Tue, 27 Feb 2024 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043945;
	bh=dA31BvxS1aqAfri8l2ERPw5A1ZW5Q0hQnHYUTV/AmlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKrQOVRyuqq+PiW8SZccTmA9EIRAQzIdu1L7i+qy+W2C8D5Z3soFAeHYNPH0RJAVr
	 H4x1WuTeZKKM/rbjhTc/hgv6OQuJqqt+837yiBnuktcVX3/FxM2SNaEUwkWk/oc+n5
	 itas1v3EaE+q9SfjsxWwJ1wEQTy1O08fODxeXVu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 79/84] tls: stop recv() if initial process_rx_list gave us non-DATA
Date: Tue, 27 Feb 2024 14:27:46 +0100
Message-ID: <20240227131555.442695028@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit fdfbaec5923d9359698cbb286bc0deadbb717504 ]

If we have a non-DATA record on the rx_list and another record of the
same type still on the queue, we will end up merging them:
 - process_rx_list copies the non-DATA record
 - we start the loop and process the first available record since it's
   of the same type
 - we break out of the loop since the record was not DATA

Just check the record type and jump to the end in case process_rx_list
did some work.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/bd31449e43bd4b6ff546f5c51cf958c31c511deb.1708007371.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fb7428f222a8f..910da98d6bfb3 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1780,7 +1780,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 	copied = err;
-	if (len <= copied)
+	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-- 
2.43.0



