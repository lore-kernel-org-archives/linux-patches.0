Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCA130DD3F;
	Mon, 13 Oct 2025 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369978; cv=none; b=OEp2YyfdTTDokGIFzqrM706VUcf5G1P3u+GNxhLPIPotDrrJEJOEi/X3ULQnOf/Pm7Sd37ENSZXwwY80M6oNDxcxpf01F+bkXInYNUAoFE1FTkUj8ppgrn0Dmz0yos7E1zSSeiH0BQNtLTguEnt0Z6V3aoLCJjLlWIsdIAEBwzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369978; c=relaxed/simple;
	bh=wq6RFpRR3tnS0xnWmtxbX7tHOw1YV/08bejSR8GmIkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExgJyA6Mrjr9d9OCWpCYdCpY3KwWZxCCLfcxpVAzXx/ASJI88vyJNW0aptAhnFkUsy9I1/xDkc14HbFzui04TmGKjNxioL9kME3ZqgomUC719UOxIMsBJxUPYSXcGmoAlATQGdXJNjxFC0HMwQr9fTbCpvgUwFgortgn89qLk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1TKiYWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1TKiYWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A587C4CEE7;
	Mon, 13 Oct 2025 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369978;
	bh=wq6RFpRR3tnS0xnWmtxbX7tHOw1YV/08bejSR8GmIkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1TKiYWFL0jupvWU91eVC5/u+gvVRAiuizTvYNO9bZFdybxq8by6lVCq2ONyKwjD4
	 B0PjFFvKkp1EnAF3thM9RdiofPfA+Nx/e8uG7pqClBCpPiZ2rwydBZTBvnHGCeQHJk
	 pvyp8GwcUieAIb7nn+K0vM52g5QlwWJ4caM0Bc78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadfed@meta.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 435/563] net: ethtool: tsconfig: set command must provide a reply
Date: Mon, 13 Oct 2025 16:44:56 +0200
Message-ID: <20251013144427.042187699@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit e8ab231782e92bc26e5eb605263525636a2f7ae7 ]

Timestamping configuration through ethtool has inconsistent behavior of
skipping the reply for set command if configuration was not changed. Fix
it be providing reply in any case.

Fixes: 6e9e2eed4f39d ("net: ethtool: Add support for tsconfig command to get/set hwtstamp config")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20250922231924.2769571-1-vadfed@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/tsconfig.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/tsconfig.c b/net/ethtool/tsconfig.c
index 2be356bdfe873..169b413b31fc5 100644
--- a/net/ethtool/tsconfig.c
+++ b/net/ethtool/tsconfig.c
@@ -423,13 +423,11 @@ static int ethnl_set_tsconfig(struct ethnl_req_info *req_base,
 			return ret;
 	}
 
-	if (hwprov_mod || config_mod) {
-		ret = tsconfig_send_reply(dev, info);
-		if (ret && ret != -EOPNOTSUPP) {
-			NL_SET_ERR_MSG(info->extack,
-				       "error while reading the new configuration set");
-			return ret;
-		}
+	ret = tsconfig_send_reply(dev, info);
+	if (ret && ret != -EOPNOTSUPP) {
+		NL_SET_ERR_MSG(info->extack,
+			       "error while reading the new configuration set");
+		return ret;
 	}
 
 	/* tsconfig has no notification */
-- 
2.51.0



