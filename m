Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD37222D57;
	Thu, 12 Dec 2024 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022408; cv=none; b=cecd1ULIClABzo0+b1f8+jOlgrfJqJbPbTfYVlq1qQi9EKiZrdKP1HvubWnNfdIviUiSBxwkDe9xjVCFIxzSC1eHeyN+sw94392UehGeCmywOG5XcphQQKE40zbEn2sISSt6BLnS5rsV1YopoVwtXJGaUwlcbmMDdPXM32Y2Pqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022408; c=relaxed/simple;
	bh=Cdg2TGsZ9BUz8+qSjeH6RtkxFk9BfGOed6TQh193UXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9SlcIE+FitTXiGGxzQCjPCF35Hco0JGsYSzR6V+I6rufL95D8K6s1xvRwyXqB4xvFGaWaUZ41BzHVjDsd6Gvps3Ib1YysftWNkRPIBSqgg6PU6ouua1BrHtaTQxOogdzYDqc8VA/On7ShwMZxaqW3by4g4ssTaWWGPW1SpzLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qULdPRR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qULdPRR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2ED4C4CECE;
	Thu, 12 Dec 2024 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022408;
	bh=Cdg2TGsZ9BUz8+qSjeH6RtkxFk9BfGOed6TQh193UXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qULdPRR5TyiN6WxIJFgpFOF0mlaQyssirfS8zIuDN9yo4/5BzFHuAIOiNt1YBkJcs
	 8pkRWdRjwN1p38P3P9DC94K7VFeuu407mxdcltxH9B9fmbKVtHJLentGVKlpzMH5pY
	 n4l/AOoiCgqKIAVwp6aLb5gzpi9snQARNRNJL2BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/565] powerpc/kexec: Fix return of uninitialized variable
Date: Thu, 12 Dec 2024 15:57:09 +0100
Message-ID: <20241212144320.735006711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 83b5a407fbb73e6965adfb4bd0a803724bf87f96 ]

of_property_read_u64() can fail and leave the variable uninitialized,
which will then be used. Return error if reading the property failed.

Fixes: 2e6bd221d96f ("powerpc/kexec_file: Enable early kernel OPAL calls")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20240930075628.125138-1-zhangzekun11@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 5056e175ca2c4..bce1bef0be899 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -909,13 +909,18 @@ int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
 	if (dn) {
 		u64 val;
 
-		of_property_read_u64(dn, "opal-base-address", &val);
+		ret = of_property_read_u64(dn, "opal-base-address", &val);
+		if (ret)
+			goto out;
+
 		ret = kexec_purgatory_get_set_symbol(image, "opal_base", &val,
 						     sizeof(val), false);
 		if (ret)
 			goto out;
 
-		of_property_read_u64(dn, "opal-entry-address", &val);
+		ret = of_property_read_u64(dn, "opal-entry-address", &val);
+		if (ret)
+			goto out;
 		ret = kexec_purgatory_get_set_symbol(image, "opal_entry", &val,
 						     sizeof(val), false);
 	}
-- 
2.43.0



