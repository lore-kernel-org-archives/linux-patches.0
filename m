Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C7651AFF6;
	Wed, 30 Sep 2026 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789188; cv=none; b=G1G/QndzOdHsabiVkYXxrtTnD/mr5jcqsnB7oet5UImAj7vAFu+I9xTx1JN24M0cJpsPe81a1ICfeDg9v9Bp6fIAD4YKJ6hwvbpXC36j8wNMGDkx/L5Kfr2An56RHpqSHJs9Hc/iC2X34Ocfz5KhkpJ6+i0lSlfmVPg8TMMD/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789188; c=relaxed/simple;
	bh=Mc5JLrgD96pHsVvDiJoCnj8oefHjilZA+LiSdp8T2Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgm8gam6SICMX4Ngumd/uc+O8Pxr/57S9gSYRRPijvvEHF1+oBy0L4iCdQC6VeJU5fhUDs61ChgdjOqRl8LEZYLmHsdbKL4Vba19ghG4J0VaQFeU5xfGrQpoDhv8IYbzrPcozcMIRk7EasKHJsuAujkdFbBQO2EJDFTv7Kn95A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK2L3u8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK2L3u8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50031F000FF;
	Wed, 30 Sep 2026 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789187;
	bh=/7Kxt99SLHJC1PBxTb8uU0kZmXV3NzAdqRuJYIqkPys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK2L3u8OF6xF7nPadrT6sTxEKR2habb6qEHwkb9X6O1gnGXSZDNELUG7D+++TQsy7
	 UxnBOzlTR3ZzIOYvtREAwHBu92mKUW4B+w8lvzgrbGk0YbKau2YpAug7sAk3Hnh+zL
	 zpeEO4tucUggFvu5eFyLLFKvB4FRBSic31mxyM/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coia Prant <coiaprant@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/877] net: pcs: xpcs: fix clock reference leak on xpcs_init_clks failure
Date: Wed, 30 Sep 2026 17:21:39 +0200
Message-ID: <20260930152423.055718973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Coia Prant <coiaprant@gmail.com>

[ Upstream commit 9892d71cf0ce3ff3d4fed2d9a3968fd4feb1c918 ]

xpcs_init_clks() takes references with clk_bulk_get_optional() and then
enables them with clk_bulk_prepare_enable(). If the enable step fails,
the function returns without dropping the references.

xpcs_create() handles the failure through out_free_data, which calls
xpcs_free_data() but never xpcs_clear_clks(), so the clk references are
leaked.

Add the missing clk_bulk_put() on the enable failure path. The
prepare/enable side is already rolled back by
clk_bulk_prepare_enable() itself.

Fixes: f6bb3e9d98c2 ("net: pcs: xpcs: Add Synopsys DW xPCS platform device driver")
Signed-off-by: Coia Prant <coiaprant@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260919172021.2336748-1-coiaprant@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 0152f820c1bbe..1a6576a116672 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1393,8 +1393,10 @@ static int xpcs_init_clks(struct dw_xpcs *xpcs)
 		return dev_err_probe(dev, ret, "Failed to get clocks\n");
 
 	ret = clk_bulk_prepare_enable(DW_XPCS_NUM_CLKS, xpcs->clks);
-	if (ret)
+	if (ret) {
+		clk_bulk_put(DW_XPCS_NUM_CLKS, xpcs->clks);
 		return dev_err_probe(dev, ret, "Failed to enable clocks\n");
+	}
 
 	return 0;
 }
-- 
2.53.0



