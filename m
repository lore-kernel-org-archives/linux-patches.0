Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC591714A1;
	Thu, 13 Feb 2025 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458950; cv=none; b=Fd6eUnt+xILhCkgKpttO7GXlBkKhEgBDuepCVU3S6/7H8H8t1fGJk7vnzfprAQuceOXIllBVkzsVyIUan/sTgEq7+J7uwuaxzvEc4sjbKICMjSEOWRiU8MjX2QkbRiWXkwBOQoxmoFMXtFwgKzQ87xhFJcQYS2pyuufwe/MgkBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458950; c=relaxed/simple;
	bh=7m7Ie0h5PAXjrP5IJiWJ0nWGDujqQmLaeZtjOWdOCRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4h+p8HrMKJiQnWcTyzlA8JEnD7AzfRgxhuZK8V+b+H0hfKP9Za5zIIH8FFoirHHydoiGy0VO0wNx2e+BdM1h6dWo4p6RESsz/8HihqeYC3uWMT+YkZDvE1QelYDP5OmuXAxBDO41Vmu7crKUTngPNvOFX45HShnujnS0Rq40sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGacWaow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGacWaow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B54C4CEE4;
	Thu, 13 Feb 2025 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458950;
	bh=7m7Ie0h5PAXjrP5IJiWJ0nWGDujqQmLaeZtjOWdOCRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGacWaowFUxSsy9Uy5ynGZMxsCpMA1wTbAeJXwuZvvtumQZnk0XzZE5YyLsYJL29U
	 y0ckKq/FjCAn53K77pCB+6epAAhUKi6xfTuxrccvxlC3otqnUgf8EnuTBgET0103l3
	 TJpG4AWOHw6jaUDfRKqWFDSINBLdzN5XdMfTU/Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 124/443] ethtool: rss: fix hiding unsupported fields in dumps
Date: Thu, 13 Feb 2025 15:24:49 +0100
Message-ID: <20250213142445.396180159@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 7cb106b590aba..58df9ad02ce8a 100644
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



