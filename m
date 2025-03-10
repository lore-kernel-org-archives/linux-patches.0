Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E0122DFA5;
	Mon, 10 Mar 2025 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627775; cv=none; b=aOtsYGQqlMPfOLNb2APElTajanRckiZrTqW7O335FpKlNm8p6JqLZGH5fl0ZmCYJokdbAr4APq1275tc5j4zVl3l95zS+XJhR95yyr7TsXt1tIEOnxpFtuL7ROjQCW10FFmVSlJjK9ZeokXTpI+yLdryahVlVtJGuKj6bangRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627775; c=relaxed/simple;
	bh=ct3L0Nm0Z+NAacsefIlLnMBTVPIc4eb0RH77khvHjUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8SkgbaRIOnf9mk+AoIq78Oj32kEheaLBByuJDNfFhLXFYvag7/miCSLcmp5Csx0Ae5Hf3JEWexasRmNJoOymSj48nXSF4IgnR2Xd1GZ/6GFMWHmHbf7BWl8m7LPax/JdHDlsLb87lxXbdsyME4KzhE5yw3OU2Ggb+ei1Zh6y74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuJCQO5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuJCQO5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0104C4CEE5;
	Mon, 10 Mar 2025 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627775;
	bh=ct3L0Nm0Z+NAacsefIlLnMBTVPIc4eb0RH77khvHjUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuJCQO5FxRhC8dz1SgU68roFjPKeAG8NpUdzGGT2ZZtaeqi2O8PP5oLnpwm2yBwHt
	 70/dS1Rzri/BIdAQpDnnZ+i9hguS5x20t1x0lHvH8eyFWdphaiFbZvOVXi6pguCBtk
	 g9oRvaXAScxnoZUBDJLc8qM5D9m0IJSEWKHBMAeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.12 244/269] drivers: core: fix device leak in __fw_devlink_relax_cycles()
Date: Mon, 10 Mar 2025 18:06:37 +0100
Message-ID: <20250310170507.521324798@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 78eb41f518f414378643ab022241df2a9dcd008b upstream.

Commit bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize
cycle detection logic") introduced a new struct device *con_dev and a
get_dev_from_fwnode() call to get it, but without adding a corresponding
put_device().

Closes: https://lore.kernel.org/all/20241204124826.2e055091@booty/
Fixes: bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize cycle detection logic")
Cc: stable@vger.kernel.org
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20250213-fix__fw_devlink_relax_cycles_missing_device_put-v2-1-8cd3b03e6a3f@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2079,6 +2079,7 @@ static bool __fw_devlink_relax_cycles(st
 out:
 	sup_handle->flags &= ~FWNODE_FLAG_VISITED;
 	put_device(sup_dev);
+	put_device(con_dev);
 	put_device(par_dev);
 	return ret;
 }


