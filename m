Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC1B2F2375;
	Tue, 17 Jun 2025 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175786; cv=none; b=c8uBbabvyKBkYvGFPfU7j1LplENkYcx/uKpYRWkb4ARgk9vBdnzi2L3l9kqbzvDjW46NbM6z8qFx98YpX3XHhRkEYDC3ZsRcT4rXLhsp1D5l3TxzHHm5yypyMzqzgYhQ+i0+t3O3c7a6IgHwmHLf1in/miKJ8eRMjglEQCwosVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175786; c=relaxed/simple;
	bh=0NB/lMfDDUk62CgWWz2lS3qTttfZbb3w9bwojLTnxGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ir4oCdSTFZNLinVBGAXqhn5f/2/eKnFVS5NixeHKQSA1ln3MZrPH/6Afv7+ZeiPa6HHZPBtiZCkOCSnP53ubP7H5KUSpmpFqd1NRxc9D9lBqbDLxAd79PhTEslfJz1HdsS8c+0YzQcHvyJhO86beMGzErazyfaAcgwIpBYZZO8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjGj6dnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjGj6dnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D58AC4CEE3;
	Tue, 17 Jun 2025 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175786;
	bh=0NB/lMfDDUk62CgWWz2lS3qTttfZbb3w9bwojLTnxGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjGj6dnR52AzvCeYiUK6D5aCgcabqQi/Y+q9G64iDVcC75xTkK0l3/LTc4hRRH0QK
	 c/8/oR5r1rO538UsGIEg8PyUNLx1byx6z0gwYWb8dX1BL6q60Co0eZT5863NWS/cDy
	 XDi/UFkjUPSBter7UBPaF7+QreNgdaNqk4LkiC6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/512] of: unittest: Unlock on error in unittest_data_add()
Date: Tue, 17 Jun 2025 17:22:09 +0200
Message-ID: <20250617152426.216668335@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 493e6cb63a21e9f009dc4c209fd311f2bb777656 ]

The of_overlay_mutex_unlock() was accidentally deleted if "of_root" is
NULL.  Change this to a goto unlock.

Fixes: d1eabd218ede ("of: unittest: treat missing of_root as error instead of fixing up")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/aBHZ1DvXiBcZkWmk@stanley.mountain
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 576e9beefc7c8..9a72f75e5c2d8 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1916,15 +1916,16 @@ static int __init unittest_data_add(void)
 	rc = of_resolve_phandles(unittest_data_node);
 	if (rc) {
 		pr_err("%s: Failed to resolve phandles (rc=%i)\n", __func__, rc);
-		of_overlay_mutex_unlock();
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 
 	/* attach the sub-tree to live tree */
 	if (!of_root) {
 		pr_warn("%s: no live tree to attach sub-tree\n", __func__);
 		kfree(unittest_data);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto unlock;
 	}
 
 	EXPECT_BEGIN(KERN_INFO,
@@ -1943,9 +1944,10 @@ static int __init unittest_data_add(void)
 	EXPECT_END(KERN_INFO,
 		   "Duplicate name in testcase-data, renamed to \"duplicate-name#1\"");
 
+unlock:
 	of_overlay_mutex_unlock();
 
-	return 0;
+	return rc;
 }
 
 #ifdef CONFIG_OF_OVERLAY
-- 
2.39.5



