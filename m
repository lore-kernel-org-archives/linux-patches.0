Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A024CB5B;
	Sun,  7 Jun 2026 10:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827578; cv=none; b=dtAe5IAxOLS39rJ0spK1Gu7zxPodP/sgBwCdRv1kNcMnsPVcaMJYnrQg2L7PbKeRmcaoQ3UQJkRk6bu4MJstzHv4kQRdRXQbJ00N+Tqly4QCpHXZV5KHzDIyH189TrgluZmDQZQP7WaQTx+8I5R1cVk8+7vjvf5ddpgMZ2kGNNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827578; c=relaxed/simple;
	bh=dM7dMIU/91w+ZgBOyDlFe3NTBnotuQki4z/tZcuhhhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pN1DnQqWVzUx4qfqOVmGc5Ibw7ugRf6uaaFsHi6NmS+GnCfy6PXRrnM5N5fr+oR2n3KXWMYCyu0/GqxSd8Zs46UCNLGrh09M9nAJk33mCro4mmqy8X70oMF/bynhGRNj6tE69dA6IEUdQOFfpINAzEiaLhxf7r5VGyqSb0/0OsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RInjNg4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RInjNg4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439F41F00893;
	Sun,  7 Jun 2026 10:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827577;
	bh=rZ1wsSHzvdbp7xM4v+OXyghsCxOQh1mSfyRPCpAZBsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RInjNg4+O2RiqLuE2GX+de3EJtebIN356eA49ZyscTTM83DtJWWEGWVrQlbf0wmBX
	 4n2hD0518nE4unolmg45J8pfphUsZXxqu6NYLCzbOadhMkKC95C7NS9L8fTQOpBjVd
	 BsUbcHy7FvhruGmD0+DKJESoY36KW6aLIu72vFTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/307] ethtool: eeprom: add missing ethnl_ops_begin() / _complete() during fallback
Date: Sun,  7 Jun 2026 11:57:47 +0200
Message-ID: <20260607095730.329867243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



