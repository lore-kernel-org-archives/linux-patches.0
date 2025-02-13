Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57670281375;
	Thu, 13 Feb 2025 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457451; cv=none; b=Wz63fk5k00KghZ8tjXqBtY7LeG9gXMyVWyU3QrLw9GJcj1oVKBFClFVOJxWmFKDg0yEzR3LgQegcPbMfcumSQwUHSuEy8UE/5JRQfxglOb/eJEtGinK91dF00+ocgQCSzaqH7qJN2rFYbtG/7h0zihzJo7SzVMopTgGQ4NK/DBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457451; c=relaxed/simple;
	bh=uTYEoTI8H+DUBTxo553Kx87k4O0htUud75eOYpvTPng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1WhiaZP/j4Bz0aNNz1b/F41QVr5xITOtX2QK/xmdZqd6YoKOkF2Zcnxd3KrIVTEySjKXvo4DYizgYbJdXEjgAkJTfD9j5rNwsk/Etn2xexnzTI5bNXeBsgVpdpiJXwbSyiguhJy2IS9Q4OGmZSpepg3dFz8WwYKZa4A38RfBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fixlo5kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fixlo5kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A2DC4CED1;
	Thu, 13 Feb 2025 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457451;
	bh=uTYEoTI8H+DUBTxo553Kx87k4O0htUud75eOYpvTPng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fixlo5kQVQ/kTYqJXhY9kquyLzrhLXyBOHsgJhDHwz4lewcd1qZR2YanJEnGWWnBI
	 dYzJld/FxnEKuqQ4NkDuzhOo10ExWAYuvQKXOj+fErxuQOL8j3Iztgi9/16Jf6yhSd
	 E01u5iICpjQ/VC8tFXcC3n/dhZGhrAVvAvcQoslc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/422] ethtool: rss: fix hiding unsupported fields in dumps
Date: Thu, 13 Feb 2025 15:24:23 +0100
Message-ID: <20250213142440.951777541@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 244f8aa46fa9e2f4ea5fe0e04988b395d5e30fc7 ]

Commit ec6e57beaf8b ("ethtool: rss: don't report key if device
doesn't support it") intended to stop reporting key fields for
additional rss contexts if device has a global hashing key.

Later we added dump support and the filtering wasn't properly
added there. So we end up reporting the key fields in dumps
but not in dos:

  # ./pyynl/cli.py --spec netlink/specs/ethtool.yaml --do rss-get \
		--json '{"header": {"dev-index":2}, "context": 1 }'
  {
     "header": { ... },
     "context": 1,
     "indir": [0, 1, 2, 3, ...]]
  }

  # ./pyynl/cli.py --spec netlink/specs/ethtool.yaml --dump rss-get
  [
     ... snip context 0 ...
     { "header": { ... },
       "context": 1,
       "indir": [0, 1, 2, 3, ...],
 ->    "input_xfrm": 255,
 ->    "hfunc": 1,
 ->    "hkey": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
     }
  ]

Hide these fields correctly.

The drivers/net/hw/rss_ctx.py selftest catches this when run on
a device with single key, already:

  # Check| At /root/./ksft-net-drv/drivers/net/hw/rss_ctx.py, line 381, in test_rss_context_dump:
  # Check|     ksft_ne(set(data.get('hkey', [1])), {0}, "key is all zero")
  # Check failed {0} == {0} key is all zero
  not ok 8 rss_ctx.test_rss_context_dump

Fixes: f6122900f4e2 ("ethtool: rss: support dumping RSS contexts")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250201013040.725123-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index e07386275e142..8aa45f3fdfdf0 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -107,6 +107,8 @@ rss_prepare_ctx(const struct rss_req_info *request, struct net_device *dev,
 	u32 total_size, indir_bytes;
 	u8 *rss_config;
 
+	data->no_key_fields = !dev->ethtool_ops->rxfh_per_ctx_key;
+
 	ctx = xa_load(&dev->ethtool->rss_ctx, request->rss_context);
 	if (!ctx)
 		return -ENOENT;
@@ -153,7 +155,6 @@ rss_prepare_data(const struct ethnl_req_info *req_base,
 		if (!ops->cap_rss_ctx_supported && !ops->create_rxfh_context)
 			return -EOPNOTSUPP;
 
-		data->no_key_fields = !ops->rxfh_per_ctx_key;
 		return rss_prepare_ctx(request, dev, data, info);
 	}
 
-- 
2.39.5



