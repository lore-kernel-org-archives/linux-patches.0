Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B80544B66E;
	Tue, 16 Jun 2026 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623450; cv=none; b=Mo2Nn2M1C/XYXg7m3NqMJ1XXtpQIkGQXhmz4J+P4+SO/SrbZX+C1Ba//wzHKGl4sb24YJFm9auRMphu7HmwLYVwKPs+z+AuzqV0bozGKb9D0KtmPGGPrFAOeDyjRj2EHG81wanWoW254XEye3+rRb6p3GqNtdofQqQmeDPv3z6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623450; c=relaxed/simple;
	bh=TCYywJd5oiyrITkL0XnmrSQ+/KsmxpVjHIZXykrY7eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2pRL1xrk4iTjF+/HsZZnrtLfKIbOy4CXAjOZK0o9eTMNJw07d2vgsFBrxd8H304oT2to3Rf3beiGqv18ZQW7k8bB8cv7jpy+aTyjRcSD/DE1jvHU8xODKw6VQqmZZKfUA4rDkXgj6k69so2e8Dm9esx62My0C3BBWQMejyZS9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZa9qTkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZa9qTkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634E71F000E9;
	Tue, 16 Jun 2026 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623449;
	bh=wFJCg2nZe3lj5pu76n/amKYyq58vHQgYZO46YwSwRj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZa9qTkZNbcQnXg7MjYbypwDmLHhXclQmAepX0k9aU49TfuKYvIxylqBesbYDrzeB
	 99TgKwIJv+Zli38gE/PXaoBXrHtaIP3VmQcfpHQGLc8VMvveWTtEJru85qwRV9n9Nl
	 vCjDx/E8HHJnzZJ470IuSkOCnT8fIYvRquV1Fozc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 151/378] net: txgbe: distinguish module types by checking identifier
Date: Tue, 16 Jun 2026 20:26:22 +0530
Message-ID: <20260616145118.198163439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit f2df54ddbfb04a006ee326a5d8270434a414e0af ]

Rework txgbe_identify_module() to validate module identifiers through
explicit type checks instead of relying on transceiver_type heuristics.
When using the SFP module, transceiver_type could be a random value,
because it was read from an invalid register.

Fixes: 57d39faed4c9 ("net: txgbe: improve functions of AML 40G devices")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260608070842.36504-3-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index a7e81f9e1be148..bdac654a236465 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -357,18 +357,16 @@ int txgbe_identify_module(struct wx *wx)
 	}
 
 	id = &buffer.id;
-	if (id->identifier != TXGBE_SFF_IDENTIFIER_SFP &&
-	    id->identifier != TXGBE_SFF_IDENTIFIER_QSFP &&
-	    id->identifier != TXGBE_SFF_IDENTIFIER_QSFP_PLUS &&
-	    id->identifier != TXGBE_SFF_IDENTIFIER_QSFP28) {
-		wx_err(wx, "Invalid module\n");
-		return -ENODEV;
-	}
-
-	if (id->transceiver_type == 0xFF)
+	if (id->identifier == TXGBE_SFF_IDENTIFIER_SFP)
 		return txgbe_sfp_to_linkmodes(wx, id);
 
-	return txgbe_qsfp_to_linkmodes(wx, id);
+	if (id->identifier == TXGBE_SFF_IDENTIFIER_QSFP ||
+	    id->identifier == TXGBE_SFF_IDENTIFIER_QSFP_PLUS ||
+	    id->identifier == TXGBE_SFF_IDENTIFIER_QSFP28)
+		return txgbe_qsfp_to_linkmodes(wx, id);
+
+	wx_err(wx, "Invalid module\n");
+	return -EINVAL;
 }
 
 void txgbe_setup_link(struct wx *wx)
-- 
2.53.0



