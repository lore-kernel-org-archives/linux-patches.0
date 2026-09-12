Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFDF214A84;
	Sat, 12 Sep 2026 12:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216432; cv=none; b=pNv1F1GeAmoD2XuRfdxRVdqN//8kEEIRqGKP+FmJ0LMq1o5dFhB5PWwn5kgOWUovgt22n6udd5odDWv71mFsDnJBaquA+qvPauP6rrG0CPpjAkwTNDjQqQ1scFmAszcGhAZGYHhwagyqamJt6DhpKvEmxmxi7Rr4ihHTD4x7+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216432; c=relaxed/simple;
	bh=kCXHg6r+mryC7Yo0RPJzZ1ZGCMjOPRP886LV5LltfxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Egl9VguTyRVZYfBa6ybtXWYEQtNq3B2QmB3OywHkRqwu65WjxhWZv7DrH3xBgKJPQcKGTUHpT3EPyTY4IsxZ9MFfKPJJhCfYXj1ADyRRUv92WaGqDir+dYUNZf3s/foh7okpQChQWjKbMsCORKcVSqgTQDSL4yb34fc1JmQVZx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKb4XDNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKb4XDNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266C61F000FF;
	Sat, 12 Sep 2026 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216431;
	bh=lse0iH863HB3EOP3D9XEEn3YhInet3TeM9cZ6VehNC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKb4XDNGHRekrd5EMpcc7B3bv3Nem86wcA7mu/oJ7WTt9zl+9BIRPeLXMhuNb/1WP
	 O1PVAH8oEWtKu/vG2zCVu8bNeg9gI84fbfYnUA0kpQFVt6jPpQB4qz7GLQ8tu8oAZU
	 I3lWtww2leP2ZuejCPPKW7A8hM8VPFiH327D6Ozg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0734/1376] platform/chrome: cros_ec_debugfs: Unregister panic notifier
Date: Sat, 12 Sep 2026 08:52:40 +0200
Message-ID: <20260912065623.904608558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index ef93b34c7dd07..21b328ea9a331 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -544,6 +544,8 @@ static void cros_ec_debugfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec = dev_get_drvdata(pd->dev.parent);
 
+	blocking_notifier_chain_unregister(&ec->ec_dev->panic_notifier,
+					   &ec->debug_info->notifier_panic);
 	debugfs_remove_recursive(ec->debug_info->dir);
 	cros_ec_cleanup_console_log(ec->debug_info);
 }
-- 
2.53.0



