Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BFA14A4C7;
	Wed,  7 May 2025 18:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643339; cv=none; b=MXOBUVFFuFP6pzTzQc+o+ZSZaJ9KwZT0M8MX1F7c2sQG7lXsI95sIdIB2wvUFwd3S4JtTJaO6w16PLoQNtx1coroyCtTxVWkdSDLa5KqawbDglmWTxEWf+DlbrbV0PHfWF0MYCzDgt7Ek4NEHu8px2WA0py+i7HrATC3k8z8nHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643339; c=relaxed/simple;
	bh=1bwapIdRCUsSDhhRzqBk1BkM1cqDGjIH2ZEdy+HygX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II+FoRpULfmrQlAUqDzBriJiwXajHUzthOWvhpTTFyfGwH3xCkYfsRvaaLBJYZhcfJH23qJ6lQMkg1H9QrQY2mj9OmQAVAhknzsVPa+Bwa+eGOrDkgaskm6fMMNsEdrHfHAhe8BOtkVSDRnLAmFWa8lr0aEBoFHKVUhfwhgsDAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXMLCa7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXMLCa7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CA9C4CEE2;
	Wed,  7 May 2025 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643338;
	bh=1bwapIdRCUsSDhhRzqBk1BkM1cqDGjIH2ZEdy+HygX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXMLCa7nCldrKzwH80lxtdXNGTXWinXSwXEABz93/qvuakQaVgO3DWXNaSlHlm+3H
	 3oRv4soYYRfSWBsC5fp4Cu0rHQe9VjXsh09mG2rd9FQ+Dh6+QApCOXKzK8L0ufR56k
	 fvZUQ0fvAfS4tsz+3KCqd9jALdzF5tnxXdqi/A3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 05/55] i2c: imx-lpi2c: Fix clock count when probe defers
Date: Wed,  7 May 2025 20:39:06 +0200
Message-ID: <20250507183759.269723402@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -616,9 +616,9 @@ static int lpi2c_imx_probe(struct platfo
 	return 0;
 
 rpm_disable:
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }


