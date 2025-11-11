Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40973054F7;
	Tue, 11 Nov 2025 01:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823861; cv=none; b=oDQ0sT8dAV6oLcJshImdtIQbMUiCEn06qoeP71UKM34gkC1voobMuVP7LC/zKYeA3MnQXRKN0ABXvpkHZjVUg470Kbrl1Yb8Fx3h4RDDdrOtWCO/zlldXyno8qtqPRjxVZ5dFNT1DmaQFuTsof4l1P8fSfQv4wKnLzLFb8bToRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823861; c=relaxed/simple;
	bh=tHAdwIJBUrzUoup4Nkpp5ZdRStxDS4MRDLTl53/84GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWht1bCz8jjt8Dypyufzb9LRrhdkvhkCoFN5x4G6QXOh5jOli9h5Y7eoqy0cdWVWget6krK3UTT4WnpPx8oYx90yU7C/nOeJh7fiW+8tcBwOgjb+02/5rtp3eA2yC3d3kXHhXSr9QGkZ8mIX22vii1US23h3ahK7YhtdSwazcgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhLA4tv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhLA4tv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F480C19421;
	Tue, 11 Nov 2025 01:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823861;
	bh=tHAdwIJBUrzUoup4Nkpp5ZdRStxDS4MRDLTl53/84GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhLA4tv1iGf2/Ivu1H/XKSGPt7Q5d1PIJQlomjKBx936rzVtFa3Xf4vBOzRZf5NXE
	 kNWKKHnecbotkiidjY0iNHw+o/HTCoLYHX07QFOUE28Xuc8feKcXGhi6bnIW5dylWr
	 C/z913MvBqPAMz5xO3r43wPOeG7dEq8Hx0fJ043w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 386/849] selftests: drv-net: rss_ctx: fix the queue count check
Date: Tue, 11 Nov 2025 09:39:16 +0900
Message-ID: <20251111004545.763573698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 7bb552f8b1826..9838b8457e5a6 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -118,7 +118,7 @@ def test_rss_key_indir(cfg):
 
     qcnt = len(_get_rx_cnts(cfg))
     if qcnt < 3:
-        KsftSkipEx("Device has fewer than 3 queues (or doesn't support queue stats)")
+        raise KsftSkipEx("Device has fewer than 3 queues (or doesn't support queue stats)")
 
     data = get_rss(cfg)
     want_keys = ['rss-hash-key', 'rss-hash-function', 'rss-indirection-table']
-- 
2.51.0



