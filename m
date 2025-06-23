Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8F1798F;
	Mon, 23 Jun 2025 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684637; cv=none; b=sAMN7rK/nHs03Es6ai1kUB7NF0Q0cUXX9GnAR5Rv9B/TILGYGzPz4DIy2TvnmjmIH9aedshg9YWiqbcs8JkOFwKlEPbBzRcovtN/a0xDVtAf+upEP9mDRaDsab+8rCfLP/5XwBwXHv7BXbiIV7gIRmGUatrvYPMo4VW4vPQuJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684637; c=relaxed/simple;
	bh=nQbTnln+nsAv9jovMwXcuXzhh6TS7UkAMNb9VBFGzEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNGR3mmWnAKenr4acAoFGdywsNrbOZ3MV3D4O2nMtftY+eamG25RTSn2IgTaCZhyD0R2JCZie75h/Oo/8qOQPPSpCs9JVg3/68cPpLqMfI35zBhkP9MhPY2Ipk5sKNXyDM49EJckB0UAokW4zNFNlbN11BfbA4um98zGaQuOErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rj6FfjMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rj6FfjMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0289C4CEEA;
	Mon, 23 Jun 2025 13:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684637;
	bh=nQbTnln+nsAv9jovMwXcuXzhh6TS7UkAMNb9VBFGzEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rj6FfjMNKS1+OZFCcSq/Ytr/lC0rR0j9v2AUqx2eq6YWCKcl++flH+FlqM0Fgl+bx
	 aarCbWokUj4TxP38TUqo/oS12cOfZ+duDBDo2l8DE9gf71OrTBHVO9OihvL3oAmn7B
	 OJQR3dE/N8ID0csaL0pfb+WnwAoNtszBJURWPaFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sami Mujawar <sami.mujawar@arm.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Cedric Xing <cedric.xing@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.15 143/592] configfs-tsm-report: Fix NULL dereference of tsm_ops
Date: Mon, 23 Jun 2025 15:01:41 +0200
Message-ID: <20250623130703.680496349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit fba4ceaa242d2bdf4c04b77bda41d32d02d3925d upstream.

Unlike sysfs, the lifetime of configfs objects is controlled by
userspace. There is no mechanism for the kernel to find and delete all
created config-items. Instead, the configfs-tsm-report mechanism has an
expectation that tsm_unregister() can happen at any time and cause
established config-item access to start failing.

That expectation is not fully satisfied. While tsm_report_read(),
tsm_report_{is,is_bin}_visible(), and tsm_report_make_item() safely fail
if tsm_ops have been unregistered, tsm_report_privlevel_store()
tsm_report_provider_show() fail to check for ops registration. Add the
missing checks for tsm_ops having been removed.

Now, in supporting the ability for tsm_unregister() to always succeed,
it leaves the problem of what to do with lingering config-items. The
expectation is that the admin that arranges for the ->remove() (unbind)
of the ${tsm_arch}-guest driver is also responsible for deletion of all
open config-items. Until that deletion happens, ->probe() (reload /
bind) of the ${tsm_arch}-guest driver fails.

This allows for emergency shutdown / revocation of attestation
interfaces, and requires coordinated restart.

Fixes: 70e6f7e2b985 ("configfs-tsm: Introduce a shared ABI for attestation reports")
Cc: stable@vger.kernel.org
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Sami Mujawar <sami.mujawar@arm.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reported-by: Cedric Xing <cedric.xing@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20250430203331.1177062-1-dan.j.williams@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/tsm.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/virt/coco/tsm.c
+++ b/drivers/virt/coco/tsm.c
@@ -15,6 +15,7 @@
 static struct tsm_provider {
 	const struct tsm_ops *ops;
 	void *data;
+	atomic_t count;
 } provider;
 static DECLARE_RWSEM(tsm_rwsem);
 
@@ -92,6 +93,10 @@ static ssize_t tsm_report_privlevel_stor
 	if (rc)
 		return rc;
 
+	guard(rwsem_write)(&tsm_rwsem);
+	if (!provider.ops)
+		return -ENXIO;
+
 	/*
 	 * The valid privilege levels that a TSM might accept, if it accepts a
 	 * privilege level setting at all, are a max of TSM_PRIVLEVEL_MAX (see
@@ -101,7 +106,6 @@ static ssize_t tsm_report_privlevel_stor
 	if (provider.ops->privlevel_floor > val || val > TSM_PRIVLEVEL_MAX)
 		return -EINVAL;
 
-	guard(rwsem_write)(&tsm_rwsem);
 	rc = try_advance_write_generation(report);
 	if (rc)
 		return rc;
@@ -115,6 +119,10 @@ static ssize_t tsm_report_privlevel_floo
 					       char *buf)
 {
 	guard(rwsem_read)(&tsm_rwsem);
+
+	if (!provider.ops)
+		return -ENXIO;
+
 	return sysfs_emit(buf, "%u\n", provider.ops->privlevel_floor);
 }
 CONFIGFS_ATTR_RO(tsm_report_, privlevel_floor);
@@ -217,6 +225,9 @@ CONFIGFS_ATTR_RO(tsm_report_, generation
 static ssize_t tsm_report_provider_show(struct config_item *cfg, char *buf)
 {
 	guard(rwsem_read)(&tsm_rwsem);
+	if (!provider.ops)
+		return -ENXIO;
+
 	return sysfs_emit(buf, "%s\n", provider.ops->name);
 }
 CONFIGFS_ATTR_RO(tsm_report_, provider);
@@ -284,7 +295,7 @@ static ssize_t tsm_report_read(struct ts
 	guard(rwsem_write)(&tsm_rwsem);
 	ops = provider.ops;
 	if (!ops)
-		return -ENOTTY;
+		return -ENXIO;
 	if (!report->desc.inblob_len)
 		return -EINVAL;
 
@@ -421,12 +432,20 @@ static struct config_item *tsm_report_ma
 	if (!state)
 		return ERR_PTR(-ENOMEM);
 
+	atomic_inc(&provider.count);
 	config_item_init_type_name(&state->cfg, name, &tsm_report_type);
 	return &state->cfg;
 }
 
+static void tsm_report_drop_item(struct config_group *group, struct config_item *item)
+{
+	config_item_put(item);
+	atomic_dec(&provider.count);
+}
+
 static struct configfs_group_operations tsm_report_group_ops = {
 	.make_item = tsm_report_make_item,
+	.drop_item = tsm_report_drop_item,
 };
 
 static const struct config_item_type tsm_reports_type = {
@@ -459,6 +478,11 @@ int tsm_register(const struct tsm_ops *o
 		return -EBUSY;
 	}
 
+	if (atomic_read(&provider.count)) {
+		pr_err("configfs/tsm/report not empty\n");
+		return -EBUSY;
+	}
+
 	provider.ops = ops;
 	provider.data = priv;
 	return 0;
@@ -470,6 +494,9 @@ int tsm_unregister(const struct tsm_ops
 	guard(rwsem_write)(&tsm_rwsem);
 	if (ops != provider.ops)
 		return -EBUSY;
+	if (atomic_read(&provider.count))
+		pr_warn("\"%s\" unregistered with items present in configfs/tsm/report\n",
+			provider.ops->name);
 	provider.ops = NULL;
 	provider.data = NULL;
 	return 0;


