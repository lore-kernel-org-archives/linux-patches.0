Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6909368D40;
	Tue, 21 Jul 2026 19:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662167; cv=none; b=W3Zo30HLAkWjLXCz3rsd29WBnnLxklWYTeRb2Tf75A04brBQ/HB0YAvCultEASkK4Ou0OICMVCr9lYvpYvA8ERG2voZg8zoThI4HWW17K46RipGxJSfTAKYjhHub5Lg+JoQ6Wg3swqOOBTiRAFCab8LBmlS9Ed/sh9pmwk7PnBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662167; c=relaxed/simple;
	bh=tVrMYJFP9VMfghI/WghyH0caenYAX3ByKodin4oTznk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c060nD1TIgjAYSdxHQ86Tbjff2ZJcPIc9Z3IX/0CVoPo41E8Kn0YG0Y5B0P/MReLbQ+tQJIyVXbqfV+0x38rWFdiEkiJYE7vKGU1ZFcgyQLgC6yozStUwK7EdhkueBdbOVXEgZ4J3Hp8W8Cq0ljlZ5rtB37z2O7KbeP8GV1/NpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUxxW0j4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUxxW0j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3300C1F000E9;
	Tue, 21 Jul 2026 19:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662166;
	bh=9xaX4Q2ZQPoR9UU3j48XaPrIbE829oBr/HgZRlMBCZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUxxW0j4KClZzdCC9tVhK7hwqthaTYzTWMxIlxzcFTbh0GNrdNO6QG+GB81GDaTMy
	 Cis8nIT1qGIC0lr8o0QxhWIz0ZW/w8o7iPYhT3EPeOG6WW2dlwiaD1Lz3lOjQIrfrz
	 lYsssE88DGvv0nKkRmrguwNPNTkQZ4L9Pz6OAXy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0342/1276] cxl/test: Unregister cxl_acpi in cxl_test_init() error path
Date: Tue, 21 Jul 2026 17:13:05 +0200
Message-ID: <20260721152453.757786449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 0d0c434426e7bf..ad583750e4429e 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1448,7 +1448,7 @@ static __init int cxl_test_init(void)
 	return 0;
 
 err_root:
-	platform_device_put(cxl_acpi);
+	platform_device_unregister(cxl_acpi);
 err_rch:
 	cxl_rch_topo_exit();
 err_single:
-- 
2.53.0



