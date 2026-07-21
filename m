Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A391B46DFE5;
	Tue, 21 Jul 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656715; cv=none; b=RZDB2Sx8qbhlKqpa5FnrIRRWITSDg+fEGWkBL91oUA/ufzBjG23ht1XKT1Kaxy80XaRWcp31fRwFkERMRxKi8NGyOXoJ+c6O0nYi3VkM9xVcAPIDo21NJ86GYPxmAsE/DxwDeZSWMRspbECPWlkqVbsiIFvvo2pOqDTfqnMHH5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656715; c=relaxed/simple;
	bh=/h9Dsw/Ey0ZCnRupul1RS83Pdrt1yIqpFrq1Hn7S5UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUyHNwJ2OoQB5GfavW2uuILcexDPeI+bmlQ4fy/AzPWTL3qvOUaULymX4ltgy48HvqDQshr6eDg69bVT23rxyUgJK1+uJLGPvQDnqOuZk+U4z3NIUEQgiErBx2Qbtj3r+WOWAEDbsp21Dnwhue0NP1V/F8TUXsD4dy3Zk5t+Zz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URByEL0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URByEL0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8601F000E9;
	Tue, 21 Jul 2026 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656713;
	bh=c9HY6lJ0dmmNO0rexXkcjMqym4/qoeBXeHIZonwUMVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URByEL0znWLyTxwptDbfb+cSVPHn5JHTJKfgh8Fnuf4YvDCbC0tNVYBo45PtFOCnJ
	 f5Vsh6LzwbgfsqoeBftnXicWA0POij5aRfO3EIUQl+rqKs64CNYYLjxyKM0LhLa/T9
	 8K4ywFEC2roxyL8wFNpfl7PdcwDEEn3N+UAcpHFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0491/1611] cxl/test: Unregister cxl_acpi in cxl_test_init() error path
Date: Tue, 21 Jul 2026 17:10:07 +0200
Message-ID: <20260721152526.382086606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 50cc34be04a0ea7522b739c9c7a71367cfbc489c ]

In cxl_test_init(), Once cxl_mock_platform_device_add() succeeds, all
error paths after needs to call platform_device_unregister() instead of
platform_device_put() to clean up.

Fixes: 67dcdd4d3b83 ("tools/testing/cxl: Introduce a mocked-up CXL port hierarchy")
Reported-by: sashiko-bot
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260611230355.198912-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 5771c75bc58893..a126a207126b43 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1526,7 +1526,7 @@ static __init int cxl_test_init(void)
 	return 0;
 
 err_root:
-	platform_device_put(cxl_acpi);
+	platform_device_unregister(cxl_acpi);
 err_rch:
 	cxl_rch_topo_exit();
 err_single:
-- 
2.53.0



