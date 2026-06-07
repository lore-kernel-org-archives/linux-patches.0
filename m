Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A11D308F0A;
	Sun,  7 Jun 2026 10:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827251; cv=none; b=qzhK1t9b0+prcepohzU8itC0G0XwqhRYY6ZT01sYu7xRkRziqN0oMxMXbvPqfB6mbS+tepSiiYZf0rSsjPTGWvzMRC+6IAB8UIvv3axWjqIP7KVIi/U/nkNJ08KJWGcQ9WJvy7UN84xE7EqkcH1pC+7H9jg9Z5Z4xpxHqRNkNTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827251; c=relaxed/simple;
	bh=Yk7sQAK8bFqPWIfVOdksr/89MNVX7+L2oFvFsYoPSeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8r+s+xMGt9kVMXsd8KYfKzvOdYGjf5SrJmK4k7W+olj7wekupJi/vZKcqfMnmcKRmRfzgSxc/92KVfXQFwSxvG64JND8X0NP9ilIlCEMPDBOWiC8SE7pbwrX/JTKhU239pN7Ds5Dd34tkWM2/TxQi2JFintVx3gNRBHT+pk7u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODCkKbJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODCkKbJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE75B1F00893;
	Sun,  7 Jun 2026 10:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827250;
	bh=9b93u4VKf4CqtXjpPaW5NlA6qUqnGhw5mGpJ02qGvxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODCkKbJJsYZAxYztu4w74NUKwTwJeliXO6PRwEVU5PjG290haZsisuzV1nKTqx5M2
	 etcBxN7mRavHL/soO692Y39h4GDnTRegqElJS+CDAu0esqvH2qA18H4sQm0owhu3CN
	 z5kqwJ/QFHQSAq+K4xLbpycX1ybi+v8xZRvEOGIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 076/332] ethtool: eeprom: add missing ethnl_ops_begin() / _complete() during fallback
Date: Sun,  7 Jun 2026 11:57:25 +0200
Message-ID: <20260607095730.931582265@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2376586f85f972fefe701f095bb37dcfe7405d21 ]

All ethtool driver op calls should be sandwiched between
ethnl_ops_begin() / ethnl_ops_complete(). In Netlink eeprom code,
if the paged access failed we fall back to old API, but we
first call _complete() and the fallback never does its own
ethnl_ops_begin(). Move the fallback into the _begin() / _complete()
section.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-10-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/eeprom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 3b8209e930fd3a..03cb418a15823b 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -140,12 +140,11 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	return 0;
 
 err_ops:
+	if (ret == -EOPNOTSUPP)
+		ret = eeprom_fallback(request, reply);
 	ethnl_ops_complete(dev);
 err_free:
 	kfree(page_data.data);
-
-	if (ret == -EOPNOTSUPP)
-		return eeprom_fallback(request, reply);
 	return ret;
 }
 
-- 
2.53.0



