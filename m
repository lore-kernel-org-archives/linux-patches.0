Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848421440F;
	Tue, 12 Nov 2024 10:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408216; cv=none; b=Tz5/7yHexZJe5j0RGOl6DWSPKZb/wJlNT/rDQlowpmGlQg2JAvjTZz1yZqIS0xJ98aNTDoOROxTEx6QOkdylPuBRNT7i8Y6pZafAuCqP3qTaH7XOSOFdi08UypqXTjyITUm1AToMDExykR97TO1uTqKE+hNkdjyv1bz9wFl0LmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408216; c=relaxed/simple;
	bh=soqaGipknAl7bdDE62JXqZUY9yyPeQ8FbT0a9yWKIwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNTnr/7IURoq8OYgsSbONPXpdh9Tr0QPVIZiyLSKuzaBlwRqEKd2OYLGdZ0Mn8o9iGe00HZJLeMbnIY2l96F3V8HCEfeq6bDB8hY/Pu74vjH9D1atKUvlZs3YPLtlpw5fQ6SnTicHYOYkdoXTLta6HGCnETztT5hmW71bxVNrVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAndFtLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAndFtLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C513BC4CECD;
	Tue, 12 Nov 2024 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408216;
	bh=soqaGipknAl7bdDE62JXqZUY9yyPeQ8FbT0a9yWKIwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAndFtLIoxZ7mgEXRuyjO7N6l4MDsrwHbRTRexZrwKb5H6dmO25tjwy5AeZVgLM8W
	 BVYAUlH74wWuXrw4uYRt73sNCF4G0r1YXoevuTA8Bh6dv/0gYgDROvEweF/xXjZS6a
	 /afKst+gWrHG0H5rwG/eyHbqQjedLUniSS/oREKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <Wentao_liang_g@163.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 063/184] drivers: net: ionic: add missed debugfs cleanup to ionic_probe() error path
Date: Tue, 12 Nov 2024 11:20:21 +0100
Message-ID: <20241112101903.283423140@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <Wentao_liang_g@163.com>

[ Upstream commit 71712cf519faeed529549a79559c06c7fc250a15 ]

The ionic_setup_one() creates a debugfs entry for ionic upon
successful execution. However, the ionic_probe() does not
release the dentry before returning, resulting in a memory
leak.

To fix this bug, we add the ionic_debugfs_del_dev() to release
the resources in a timely manner before returning.

Fixes: 0de38d9f1dba ("ionic: extract common bits from ionic_probe")
Signed-off-by: Wentao Liang <Wentao_liang_g@163.com>
Acked-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://patch.msgid.link/20241107021756.1677-1-liangwentao@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index b93791d6b5933..f5dc876eb5009 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -394,6 +394,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_pci:
 	ionic_dev_teardown(ionic);
 	ionic_clear_pci(ionic);
+	ionic_debugfs_del_dev(ionic);
 err_out:
 	mutex_destroy(&ionic->dev_cmd_lock);
 	ionic_devlink_free(ionic);
-- 
2.43.0



