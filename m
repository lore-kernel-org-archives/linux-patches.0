Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56B6175A75;
	Sun,  7 Jun 2026 10:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827372; cv=none; b=t2RDhnBKxhPiNYLVjq6oYzJ5ycz0uIBWa88X0MtyKWePCZ//D31iv29zFOT3wWF1GgbKrkY2B0R2L3zGtNuEKZrR9/hWURCDo33Dx6mLLr6yZRpWx4DE6hj1aXYQ2tqqpEo4/yEEkokvwU7d03bN7jh+aHFqsjdvIcyKVq9UQJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827372; c=relaxed/simple;
	bh=3XEo4qFqDARvNKWnk/yWX+tSZypywgJNkPOmm8swsBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4TyaKvkV2Eu/YjjOgACPjv4bPM61r9L8BsQKqeZaKQXT9zJ6VoUA/nm+tfgAee3gbm76rsPjRymoHJE5APbwDuS5EOpmVxLWgLdv4Y7o7WH5VICgBwuA+75pbYIRYrD3rdzHf6cDfpdj5QT9OVNX5v1eDLk0qi1cqq0zYjwHV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReQDiSJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReQDiSJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E7E1F00893;
	Sun,  7 Jun 2026 10:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827371;
	bh=ilMgWaqN0Y1tZ/Db1VcTyNdprmA1o6XfOM89JxCDlOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReQDiSJw7S7ag4aXVj/+fQMTjdRGPKlGODajrDF9Bn6cxxjI0ttRAqnk1QGV7Ub7w
	 GCxdPCNDoOVVStd001/EnQ16DMILcyl2F8tgkJp9pL3qEsJMcGoB1glXnDRSIVDAAR
	 LrYU6HwU+UQSqaS/WJ3mjQkmuntEaPj9AeH5FzV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/315] ethtool: tsconfig: fix missing ethnl_ops_complete()
Date: Sun,  7 Jun 2026 11:57:35 +0200
Message-ID: <20260607095730.109739126@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6386bd772de64e6760306eb91c7e86163af6c22f ]

tsconfig_prepare_data() calls ethnl_ops_begin(), we need to call
ethnl_ops_complete() before returning the error.

Fixes: 6e9e2eed4f39 ("net: ethtool: Add support for tsconfig command to get/set hwtstamp config")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/tsconfig.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/tsconfig.c b/net/ethtool/tsconfig.c
index 041de8687472bd..a121928038b055 100644
--- a/net/ethtool/tsconfig.c
+++ b/net/ethtool/tsconfig.c
@@ -69,8 +69,10 @@ static int tsconfig_prepare_data(const struct ethnl_req_info *req_base,
 		if (ret)
 			goto out;
 
-		if (ts_info.phc_index == -1)
-			return -ENODEV;
+		if (ts_info.phc_index == -1) {
+			ret = -ENODEV;
+			goto out;
+		}
 
 		data->hwprov_desc.index = ts_info.phc_index;
 		data->hwprov_desc.qualifier = ts_info.phc_qualifier;
-- 
2.53.0



