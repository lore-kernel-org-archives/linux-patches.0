Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAFE5475F;
	Sat, 12 Sep 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224130; cv=none; b=M249ni3NyFxfv1KQqLdkmbjM+DuTXnMVp0rNbrLxyi8M6z83uzfiAvl0kk0G+W5//nrxfnDvA1av6+U1xQeOWYN3O1/KzkjRjwAMt3ADLr5uoXbGuswkr9Ln1V1qfwbyQng4SWaWYPKhrdI4bQ9XtBS/hUCbCSAmo1HdeM4xf/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224130; c=relaxed/simple;
	bh=2CXAOmotUNgl8XPTQllWn8csQFiqAH22milwogYmixE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGXkmEmg4odXEdJNFmHZCxPGb91YzfiDIAQX5k4jp2BC+vS2xNY2saMw4UJ1QJuHHMQLAagDSdQ1iVgQO6/7e4hsaftWzmvwjS85CAQFoIDKLSKTMOQuvdgo8/1vIzUjyJpgTTnpzZUYSwyz5050o7igtwoWKHsDSmQdYk8vtEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6vbR+nZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6vbR+nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA951F000FF;
	Sat, 12 Sep 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224129;
	bh=BMm81lgafU4bYHHHUovGXIM3m5GaV/9Svzo3LwGXAZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6vbR+nZ+/ubIpJKvZwx6mtMgAG7HsqjfKCzCxlW0vnfO5owG01JN/ETujTvzeWSv
	 0LDDLoYaYvQdfT3hIJSANdy18jnyLjTzhZLFrmIq28YZtKX8hHASnkKQXG5ZDYeRza
	 JtzLcy+5fXvApynW3aZXkXj+sA5Th0+ARkNxGys8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0930/1424] platform/chrome: cros_ec_debugfs: Unregister panic notifier
Date: Sat, 12 Sep 2026 08:56:02 +0200
Message-ID: <20260912065628.149874891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0c01ffd72de26..f0289839c029e 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -540,6 +540,8 @@ static int cros_ec_debugfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec = dev_get_drvdata(pd->dev.parent);
 
+	blocking_notifier_chain_unregister(&ec->ec_dev->panic_notifier,
+					   &ec->debug_info->notifier_panic);
 	debugfs_remove_recursive(ec->debug_info->dir);
 	cros_ec_cleanup_console_log(ec->debug_info);
 
-- 
2.53.0



