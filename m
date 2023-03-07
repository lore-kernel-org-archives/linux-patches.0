Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52252BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55F1C433D2;
	Tue,  7 Mar 2023 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215015;
	bh=nEuNiIa/4XvnYWh64U5c5bA/GrBkz9yuGhvDvdCZhLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szgyg4Se1Z0CSHOHu0rVK3uAQGNzxd17Fph2zzB8wkVVGHCeJGHkbolBEWc4+vfl4
	 8BRSpjZdBZeWCwsGFiNmjyJv1cAO8e6NyQj+oYV80iGLc8W65d4mgm5V6e/cI6HIS8
	 /B2JlGlnu5Jn7jq5/a8KPexT8Ov9IpysMaygn6sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Nguyen <theflow@google.com>,
	Peter Gonda <pgonda@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Rientjes <rientjes@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/567] crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2
Date: Tue,  7 Mar 2023 17:57:08 +0100
Message-Id: <20230307165909.870372187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Rientjes <rientjes@google.com>

[ Upstream commit 91dfd98216d817ec5f1c55890bacb7b4fe9b068a ]

For SEV_GET_ID2, the user provided length does not have a specified
limitation because the length of the ID may change in the future.  The
kernel memory allocation, however, is implicitly limited to 4MB on x86 by
the page allocator, otherwise the kzalloc() will fail.

When this happens, it is best not to spam the kernel log with the warning.
Simply fail the allocation and return ENOMEM to the user.

Fixes: d6112ea0cb34 ("crypto: ccp - introduce SEV_GET_ID2 command")
Reported-by: Andy Nguyen <theflow@google.com>
Reported-by: Peter Gonda <pgonda@google.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 900727b5edda5..15ef60cd4b149 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -667,7 +667,14 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kzalloc(input.length, GFP_KERNEL);
+		/*
+		 * The length of the ID shouldn't be assumed by software since
+		 * it may change in the future.  The allocation size is limited
+		 * to 1 << (PAGE_SHIFT + MAX_ORDER - 1) by the page allocator.
+		 * If the allocation fails, simply return ENOMEM rather than
+		 * warning in the kernel log.
+		 */
+		id_blob = kzalloc(input.length, GFP_KERNEL | __GFP_NOWARN);
 		if (!id_blob)
 			return -ENOMEM;
 
-- 
2.39.2



