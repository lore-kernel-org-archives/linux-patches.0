Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09882FF145;
	Tue, 12 Aug 2025 18:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022459; cv=none; b=VNV7yFtMK3b/2V3ujyVYLCtfGfa6nhj8lQvmXHBYicDsZM7XWcW7BJxkC/2VCGoclN5l+BWamRGFc6wnyj04oyLNuamMxXO4VkKhQLuURKdCAeGff6zj+T5506nqEoHhb5ZTe2N/C05MRoSl/m0jAn+H+BInPs67CIWkPkBOSaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022459; c=relaxed/simple;
	bh=f84CuWNjHdrSWxtTaVTyNfLzVMhVdTj+cmrEplRSvDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk0RVBO+i2r24vwvmkxQr5ivzfsBXXeopUOU0t2x06FmfLJlUw+YcgN26lsnBAt6UA8S565AkqU9a1TNVQ+lb8p0cstXV7iuZBWTVZCYDZWXeszBTQEt9Huvgxybvts9TPsG0hXgLnuJeQlUN64/7qpqspKclGXu5D860pL2QL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SshD8ZFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SshD8ZFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D192C4CEF0;
	Tue, 12 Aug 2025 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022459;
	bh=f84CuWNjHdrSWxtTaVTyNfLzVMhVdTj+cmrEplRSvDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SshD8ZFU9kKvny1Zxi9vgqWNiXgDCGJL/aAcJMj024rymeAE+EQIsuRUas5DHNBex
	 TxoaSuCcyaysHheo0fhOSb/HMPxTh7yV1HtE+qHjVLsxWtoDp8QO+2uaagu2e5MNov
	 7WwxjgN16soXXzsw3t9R76y0i3MczixgILw0Xx7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/369] clk: davinci: Add NULL check in davinci_lpsc_clk_register()
Date: Tue, 12 Aug 2025 19:27:38 +0200
Message-ID: <20250812173020.826189175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 13de464f445d42738fe18c9a28bab056ba3a290a ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
davinci_lpsc_clk_register() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue and ensuring
no resources are left allocated.

Fixes: c6ed4d734bc7 ("clk: davinci: New driver for davinci PSC clocks")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250401131341.26800-1-bsdhenrymartin@gmail.com
Reviewed-by: David Lechner <david@lechnology.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/davinci/psc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/davinci/psc.c b/drivers/clk/davinci/psc.c
index 355d1be0b5d8..a37fea7542b2 100644
--- a/drivers/clk/davinci/psc.c
+++ b/drivers/clk/davinci/psc.c
@@ -277,6 +277,11 @@ davinci_lpsc_clk_register(struct device *dev, const char *name,
 
 	lpsc->pm_domain.name = devm_kasprintf(dev, GFP_KERNEL, "%s: %s",
 					      best_dev_name(dev), name);
+	if (!lpsc->pm_domain.name) {
+		clk_hw_unregister(&lpsc->hw);
+		kfree(lpsc);
+		return ERR_PTR(-ENOMEM);
+	}
 	lpsc->pm_domain.attach_dev = davinci_psc_genpd_attach_dev;
 	lpsc->pm_domain.detach_dev = davinci_psc_genpd_detach_dev;
 	lpsc->pm_domain.flags = GENPD_FLAG_PM_CLK;
-- 
2.39.5



