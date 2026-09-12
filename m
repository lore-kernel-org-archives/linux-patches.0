Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644FF19D8BC;
	Sat, 12 Sep 2026 10:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208714; cv=none; b=hLQYCIlIFtuQtYVmNJsv4oBGH16h3Mbel0wyGGbV8GhrEenkkp6NsDJEQtHnUqGZgkoDAUW5vPCuyiWxXwagqB0nAhwwwvVLLPZyvuRW3/dhNxyusYEivVNOUkr/x4cvIWpXfnmx9aeo9QNbqojyHEXEOsHL2bjyvuQ3NIij7Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208714; c=relaxed/simple;
	bh=+HCoh5no1BnMbrnffVD8TEzgN8fz9G+GDXruf4VPd9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5GINJxCIX09wHzy8eSQA1BW7+LOrWpkYdKsgZNQsAttCRg8GLUJTkCgSSjVB92wMsJR10/qZPo06o9nYKvB9ATF1Xmm3BZlC+cl9w+6f5orVDbjMS61uvIDLBRoW/WFzV11uO3pjtwKXytPlwKq8o3BMrasuKfVkIae16xBcuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECRts7ur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECRts7ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4071F000FF;
	Sat, 12 Sep 2026 10:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208713;
	bh=Z3rqHHHAjjcRNxoLodWNfKm/S4VReFI9NrcixDrGtAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECRts7ureOxFiMAdSlraMus/QUMm4v9lHWzSo2Q/4HzvVeTBF7Tmlry8aTRsfC9ng
	 aTj0VqBpOKHo6zj8icOHXciEebPkrbf3o5OxjW80r0ACYBJAVB8CUsYwPt+tF905PX
	 0zkmtydWXq7ykYvYH+FdQ9LVsdnu5+/NctIcLAhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0646/1518] platform/chrome: cros_ec_debugfs: Unregister panic notifier
Date: Sat, 12 Sep 2026 08:46:55 +0200
Message-ID: <20260912065638.045397568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e5954d3031fb55dd31aa59bae477d63c68e941c0 ]

cros_ec_debugfs_probe() registers notifier_panic with the EC panic
notifier chain. The remove path tears down debugfs and the console log,
but leaves the notifier registered. A later panic notification can call
back into the removed instance and queue work that accesses released
data.

Unregister the panic notifier before tearing down the debugfs and
console log state.

This issue was found by a static analysis tool.

Fixes: d90fa2c64d59 ("platform/chrome: cros_ec: Poll EC log on EC panic")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/f3ab74ef8034be63bb45a325f3d54656d658817f.1785320940.git.getshell@seu.edu.cn
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index 01993ad696b04..e482b23b9f635 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -532,6 +532,8 @@ static void cros_ec_debugfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec = dev_get_drvdata(pd->dev.parent);
 
+	blocking_notifier_chain_unregister(&ec->ec_dev->panic_notifier,
+					   &ec->debug_info->notifier_panic);
 	debugfs_remove_recursive(ec->debug_info->dir);
 	cros_ec_cleanup_console_log(ec->debug_info);
 }
-- 
2.53.0



