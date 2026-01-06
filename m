Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFC2DF706;
	Tue,  6 Jan 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720839; cv=none; b=YgCWHiPwF/9APmCqCVAlokhFXELSkgckf3qhNpZv5Z2SrWPRuvNKiNXv960xkzcaK6T94vT+rw/IWRqT6I+XOt1fsJlnh062f5mS5D+NAJbXIwbGTO1yQe0W1RxW84LqUyyoVzjBhtHLv8P6DQuQaLsVLzB+roTPxfcxsLfqx/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720839; c=relaxed/simple;
	bh=znqa0kIFnFuHCa4LEs3dohwppL4PCHSLCexdxlqkqFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMnhQAIs3k/KwN/JVyg5/kC8jQIuPAeF0Pt5q60t/I8Bn12xFCQCe1ivX9qq/k1yXfMGhOjx1uDIbHzPeG7buuxtfkj3H0Voq4dkEE7sZy5+Mwp1/ishdaZYeGwBI+n9b5U1rSf8LKtMdVVQFDNx/AsNc40wu+lByzP7NMici/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0hiRJcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0hiRJcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2465DC16AAE;
	Tue,  6 Jan 2026 17:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720839;
	bh=znqa0kIFnFuHCa4LEs3dohwppL4PCHSLCexdxlqkqFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0hiRJcjZg9XXTPBn2js4KS23dWCknUJs/SW+gvfWYlT4t7+dx8lfd6poYFXcXkQx
	 ftjwjXyLS9+x+0y3wWyHQ6e3Tpcqjwx0mOcg0JwPvXYuMEHCXTfOwr3koALWrR1iKx
	 aG8pIo+gPQZ53/ubb5p3sr/J+Crt0rBcvPaoSFRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Damm <damm+renesas@opensource.se>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 358/567] iommu/ipmmu-vmsa: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:02:20 +0100
Message-ID: <20260106170504.578657603@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 80aa518452c4aceb9459f9a8e3184db657d1b441 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 7b2d59611fef ("iommu/ipmmu-vmsa: Replace local utlb code with fwspec ids")
Cc: stable@vger.kernel.org	# 4.14
Cc: Magnus Damm <damm+renesas@opensource.se>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/ipmmu-vmsa.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -719,6 +719,8 @@ static int ipmmu_init_platform_device(st
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(ipmmu_pdev));
 
+	put_device(&ipmmu_pdev->dev);
+
 	return 0;
 }
 


