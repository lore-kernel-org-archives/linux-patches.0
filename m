Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185BE47044B;
	Tue, 21 Jul 2026 18:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658829; cv=none; b=oEtGD2UBXEKxdINltSO8eJB+tKOeU6/rrFxmyMNJbg3lZKKdtxWnRoKr4HQoAK3s/96ZiDM+s7tx43n0Lpu6UhcpmYaL6QBYTYYb3FyhsgmvDxIXQjzF7J7wPrxwyRa/e6vxFsgcAapD27sMLdnaDwhgtGpbRPw/6xwwO7C4mXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658829; c=relaxed/simple;
	bh=nf1C1fusTqdt8KIZxAjl9kGxpRRx/IZOYwhO4OnFkrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwHDTvLK7Ur0Mt/0GeoJiWqhpOnCzVpm1W1ypY+nXifbK7qDMvM6i1GgVMGsWVu22AghvYgSojc9LhPS469vUZK0i5HyaePhix8roKb5V9U6MExQGlpkeRJ7IrKdUjQf5XuRJbcNv86Cr/0yxOvkig614r5XeFfnmdLpeEGJRhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlOlobKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlOlobKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F43D1F000E9;
	Tue, 21 Jul 2026 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658828;
	bh=tfrW9Al1cwZ/XQf6eFJGgv5kDBuyN3Z07XsZrEku/Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlOlobKVSIfWMkGF/GpznKb79uhzVVUx4VjJzme1qMP08LLqxoz1ILK3l2scKdG6D
	 3sCnvrZj9PsgbSv6ikju60FGqngrJqwV/i2xv2pBDf9Gy0qXm9xAMQC1oPSma9gAX4
	 epJWAMWDEq6xESl5yOtdA/Yjs3sfWG2r1Gvtq0Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lili Li <lili.li@intel.com>,
	Baoli Zhang <baoli.zhang@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 1290/1611] tpm: restore timeout for key creation commands
Date: Tue, 21 Jul 2026 17:23:26 +0200
Message-ID: <20260721152544.457539013@linuxfoundation.org>
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
@@ -59,9 +59,9 @@ static const struct {
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


