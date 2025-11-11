Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D68342C8F;
	Tue, 11 Nov 2025 01:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823512; cv=none; b=twIDTCTpYnr/68phdTJnSVk16D8RNvNFKZ1qHgLZAlptm9Z7uZsEMmtjn1CE+Cp24qRdl0YWYYLFnpmgf5EE9jOqyrKP4eiMu/UyZDyamEFH9FjxBAE2ebcnaPbY80vX19jeQDfWwlqZC9yBznNMvUEsRBYBTzy+++2cabYtDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823512; c=relaxed/simple;
	bh=3hyLZpK3etgK03UQVPFxz3gcD/N2SOKjt7idMnpaxek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASdiczz5mGuPmvczBQoAy20eyWFvitssqQmVMMWN9CRA28f6uDPMw5G2fwA5Eh4vZDcADdG2N6EMc9tOmU9qd2fD6N+RchBTj5YixHOOLX/wfse6VN5m5r4x1u3ilsuk/mjYXUGvZ00OrgWxVmZSAtXO+Bn0b+HEs7x6+ugwPFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ6h1FOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ6h1FOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E010C4CEFB;
	Tue, 11 Nov 2025 01:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823512;
	bh=3hyLZpK3etgK03UQVPFxz3gcD/N2SOKjt7idMnpaxek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ6h1FOzYkZHjy2C7M0xCH5pbKtkz2zQKSbH6YL8Hbo88WbP6gS+K6OFrbeQMCv5n
	 PnrRLzfanTj+NpmQhcyrW0N4JwvU+dGzkXY7GsErw4GbpJLX6Wvi38HhqnfKvtl7Mi
	 7pPbvxCebi+a9NgO3coi+IsupTSJyZgnmrYu6EL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/565] selftests: drv-net: rss_ctx: fix the queue count check
Date: Tue, 11 Nov 2025 09:41:57 +0900
Message-ID: <20251111004532.767844398@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

[ Upstream commit c158b5a570a188b990ef10ded172b8b93e737826 ]

Commit 0d6ccfe6b319 ("selftests: drv-net: rss_ctx: check for all-zero keys")
added a skip exception if NIC has fewer than 3 queues enabled,
but it's just constructing the object, it's not actually rising
this exception.

Before:

  # Exception| net.lib.py.utils.CmdExitFailure: Command failed: ethtool -X enp1s0 equal 3 hkey d1:cc:77:47:9d:ea:15:f2:b9:6c:ef:68:62:c0:45:d5:b0:99:7d:cf:29:53:40:06:3d:8e:b9:bc:d4:70:89:b8:8d:59:04:ea:a9:c2:21:b3:55:b8:ab:6b:d9:48:b4:bd:4c:ff:a5:f0:a8:c2
  not ok 1 rss_ctx.test_rss_key_indir

After:

  ok 1 rss_ctx.test_rss_key_indir # SKIP Device has fewer than 3 queues (or doesn't support queue stats)

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250827173558.3259072-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/rss_ctx.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/rss_ctx.py b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
index 9d7adb3cf33b9..4a986a5524a30 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -101,7 +101,7 @@ def test_rss_key_indir(cfg):
 
     qcnt = len(_get_rx_cnts(cfg))
     if qcnt < 3:
-        KsftSkipEx("Device has fewer than 3 queues (or doesn't support queue stats)")
+        raise KsftSkipEx("Device has fewer than 3 queues (or doesn't support queue stats)")
 
     data = get_rss(cfg)
     want_keys = ['rss-hash-key', 'rss-hash-function', 'rss-indirection-table']
-- 
2.51.0



