Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98C232B126;
	Sat, 12 Sep 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239032; cv=none; b=OtHOe9eEQDj/ddAwOOeopmB8mi2B76aBVuQjxXmoDZCRGcdINCLLRX2pNVX0E7tLUYrYfWQ4KMClToMPQFM4XYfrk+cpEn4CxTbh4z7IQuahAdZADD5I8MmxA7vxvujqdwYuLsHb0JgXtpdABoCmh+99eiKxrJkLH8rA9clbIF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239032; c=relaxed/simple;
	bh=f8TDgla1cUR9a9GX7a4G37pIMBXIOMw96c4evu085R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj07GP7Bg9gpeKPM42phn0Nn9WNgKiOX+nGap7MPt99diO1KVwpDtGbZxKTxD5bl+Pk0JHE4SkIz8lakqhJAnLVNhj7sMM1Nfz9ENoNeMY3lF3nvPaZ1qN4Jf9qo/eCPhvsL/JUtAjD0hMOKROKjxkNfwY4oQWqvC18UEUjN2OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8eyFT40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8eyFT40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8A71F000FF;
	Sat, 12 Sep 2026 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239031;
	bh=9V7P67gyoToqeXLXjDVFo0iFZP4W4Xj++752Vu0yBKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8eyFT40O1yP73qLKQ91EtS0QV6zR9q9wEW2yLkbU28Mra2EN0fh+st/t9wYy8Y9E
	 oW6qYsO0wX4X2TP6LTU8kEaBzh52t/4MzL2WT69kLDszTFvigZfbid9XdksGiH0YAS
	 rk3XKb2IBWXBTI6D3j8Mr9vGk0yMAboPg45VINy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 580/935] thermal: int340x_thermal: Consolidate priv->data_vault checks
Date: Sat, 12 Sep 2026 09:00:10 +0200
Message-ID: <20260912065540.141307146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit e9a7c526c29b0ae60c888b335bd6cf6e2ee80154 ]

It is sufficient to check priv->data_vault once in the error code path
of int3400_thermal_probe(), so do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d83dc9ce57a7 ("thermal: intel: int3400: clean up ODVP on probe failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 1c479c72b7d2e..f6fe145ae0a87 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -557,9 +557,8 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 
 free_sysfs:
 	cleanup_odvp(priv);
-	if (priv->data_vault) {
-		if (!ZERO_OR_NULL_PTR(priv->data_vault))
-			sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
+	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
+		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
 	}
 free_uuid:
-- 
2.53.0



