Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98284431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE13C433EF;
	Wed, 15 Mar 2023 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883619;
	bh=M+jEZo/G0TdDBpQSFA7NpqpK31M80bqJFkKMAZKjnno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdnVvSyzSNK4QZdA7cTKnVg9EoEOX+ZeKo4GFHvK+l3qE6ervnwTuZ/GaD1zDLwkH
	 6wxE1tkJUBXiDLWHWh1iWrqEZDkEKRQWg/ym63dtE0MCJm3LO23SNdrppUB7Uj1W+x
	 EDHWcC3E7atINUSa0khBPYxi2BeoaRTID7ekGSwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/143] tls: rx: fix return value for async crypto
Date: Wed, 15 Mar 2023 13:12:33 +0100
Message-Id: <20230315115742.569483149@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4d42cd6bc2ac1b9be50ade13771daec90c9d18b1 ]

Gaurav reports that TLS Rx is broken with async crypto
accelerators. The commit under fixes missed updating
the retval byte counting logic when updating how records
are stored. Even tho both before and after the change
'decrypted' was updated inside the main loop, it was
completely overwritten when processing the async
completions. Now that the rx_list only holds
non-zero-copy records we need to add, not overwrite.

Reported-and-bisected-by: Gaurav Jain <gaurav.jain@nxp.com>
Fixes: cbbdee9918a2 ("tls: rx: async: don't put async zc on the list")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217064
Tested-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230227181201.1793772-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 38dcd9b401027..992092aeebad9 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2114,7 +2114,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted = max(err, 0);
+		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.39.2



