Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0F1465A1;
	Mon,  2 Jun 2025 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874398; cv=none; b=LQqmppnTBSZjFDIQL5j/A3T2kYK69lvfR/1gmyoPQlS4U67K9bs7VPnJrqUcXlhV+2SYKM6rpxl0QttU2bp2XTjl0xPDYgM8hISNOZM5P+TU9MCVijWSlJr9Xh4dlcFmPECaerPonp0aeUpAJ/ow4IVcM+ZbC44Cbk9u1WT6HJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874398; c=relaxed/simple;
	bh=ckKphE6U3MQJTow3HwTSFrTasa4wKDFocGO+wSIPHkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1W0I/t/J5GV8G/zQ9dzoZsUKnMlovBPggS+EhDzumjxJIcqsHG6qWjmHyUHayiwXZD6WzMmn4sZD1+zykfwBogCtxEDE7CNlqKkVxkSHmnbTVnYrgtvDa2T3MmUybljMamOclVJOFlVRakTJ+swDqTvVF3vPGJgG3MSh2/05nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpMAfTBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpMAfTBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599DDC4CEEB;
	Mon,  2 Jun 2025 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874397;
	bh=ckKphE6U3MQJTow3HwTSFrTasa4wKDFocGO+wSIPHkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpMAfTBp+CkuyJiS2Zp++qEZaUQk+T4KkUNx5sM6PxcJ6nwePPs4jiGCe47ijM9qF
	 xWar4pGTV7AfgRHFngvOFwH9pZh/VZaHnK4aq3WlwlqPtht/BZ1fEIvLe7R6pw4HJJ
	 IoLlUr9bEKOGWIX+ScaVR+omS78C4W0bcq07Ecrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 003/204] i2c: imx-lpi2c: Fix clock count when probe defers
Date: Mon,  2 Jun 2025 15:45:36 +0200
Message-ID: <20250602134255.599098094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

commit b1852c5de2f2a37dd4462f7837c9e3e678f9e546 upstream.

Deferred probe with pm_runtime_put() may delay clock disable, causing
incorrect clock usage count. Use pm_runtime_put_sync() to ensure the
clock is disabled immediately.

Fixes: 13d6eb20fc79 ("i2c: imx-lpi2c: add runtime pm support")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: <stable@vger.kernel.org> # v4.16+
Link: https://lore.kernel.org/r/20250421062341.2471922-1-carlos.song@nxp.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -624,9 +624,9 @@ static int lpi2c_imx_probe(struct platfo
 	return 0;
 
 rpm_disable:
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }


