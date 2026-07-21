Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FDD145B27;
	Tue, 21 Jul 2026 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654608; cv=none; b=c55VnMp0ACz0WphMmq3NnRAGenlhDgdGwPb67C096fFYEbXlmZsuJwQC8fpqAXaM6nNt7pqT/U/BxK9EbDt2+naTBimU/Ma+JQqL7Y+rFHsCW2zasTo7ctgAYyopqmNmRjTHLHGkQ2U9n9/5bJMfjHsXAdgP5YWQsI62fFFAtrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654608; c=relaxed/simple;
	bh=HEiV8GhDzxizLSl1DDkqhGnTxjrx8aMygrGFhlN5wUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxLQXXbMDjRClGUzDZVk6PfctKJaGTUolrsTUdZH551eRqRVvskCxgOHdtud4iS6giPgQYBsNfWtnOfmhb6d8XUAofdjJ3NARekXsxQLnZ9bnlsqIhXfzR8ZK4bch26UU02JGgXMdxfnoo1OnypOLpx1yPBBPcW7Ww72F88r4gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svQja41D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svQja41D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D27E1F00A3A;
	Tue, 21 Jul 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654607;
	bh=WjsZxlvovPbisbpzvPvBgVSD/ymny3bBUDBHBDrGof0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svQja41DH2JxFuR/QFA4QPuJcDqopH8ZZO+kDymxACkNk37w5UT2UPha8DyLWTg3D
	 Ytc3FFC4lbFdv9ROtzgZNLS+kgqd9nwQXI58AvawWTranynD3NwJTK2/io9G+MCJzM
	 FG+ZbZval95IM5ccvMGPe9vTdRf+YyWcoaTh39f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lili Li <lili.li@intel.com>,
	Baoli Zhang <baoli.zhang@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.1 1770/2077] tpm: restore timeout for key creation commands
Date: Tue, 21 Jul 2026 17:24:03 +0200
Message-ID: <20260721152634.495016673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoli Zhang <baoli.zhang@linux.intel.com>

commit de59d78e64039baa5fed455ddb905ba8263e7ede upstream.

Commit 207696b17f38 ("tpm: use a map for tpm2_calc_ordinal_duration()")
inadvertently reduced the timeout for TPM2 key creation commands
(`CREATE_PRIMARY`, `CREATE`, `CREATE_LOADED`) from 300 seconds to 30
seconds.

This causes intermittent timeout failures, with several failures observed
across hundreds of test runs on some Intel platforms using Infineon
SLB9670 and SLB9672 TPM modules. Restore the timeout to 300 seconds to
avoid spurious failures.

Cc: stable@vger.kernel.org # v6.18+
Fixes: 207696b17f38 ("tpm: use a map for tpm2_calc_ordinal_duration()")
Co-developed-by: Lili Li <lili.li@intel.com>
Signed-off-by: Lili Li <lili.li@intel.com>
Signed-off-by: Baoli Zhang <baoli.zhang@linux.intel.com>
Link: https://lore.kernel.org/r/20260421005021.13765-1-baoli.zhang@linux.intel.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -71,9 +71,9 @@ static const struct {
 	{TPM2_CC_HIERARCHY_CHANGE_AUTH, 2000},
 	{TPM2_CC_GET_CAPABILITY, 750},
 	{TPM2_CC_NV_READ, 2000},
-	{TPM2_CC_CREATE_PRIMARY, 30000},
-	{TPM2_CC_CREATE, 30000},
-	{TPM2_CC_CREATE_LOADED, 30000},
+	{TPM2_CC_CREATE_PRIMARY, 300000},
+	{TPM2_CC_CREATE, 300000},
+	{TPM2_CC_CREATE_LOADED, 300000},
 };
 
 /**


