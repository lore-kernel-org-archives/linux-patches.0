Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7060D1428E9;
	Thu, 13 Jun 2024 11:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279257; cv=none; b=YqcHcYA5Anf+WiljQovuz2GIlzIDxccBc/kvGxFKw2KmeGrTtTC3/jhqN7K9kUeh7fWqh97/Xvexp34QVdPVLAKVWo46Yv36DZsD7to62iElUbVpq1yTfWxGVVFOLTP0PwsJuUvwWXXPufyzZ8S1nHjxEffjqRLhlOi7n7Ahja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279257; c=relaxed/simple;
	bh=OW/eMcN77JmeOF3DtFGGxqZNH8QCdfLtJ9MWoL+mIfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQPm9JJgwpWQoCGKPzZv0KxXEnpXzcF6KlFl/WLGm9uNGbEa5pTgVkVwghmAa5hAyEZcnEcClutFRiI/oitrAPYZxr6f3HCN2xzqj8ci/fXgTeP68W2T/0VeNIoBGfRHMWM1qlTbqTg64am919Qdtltrk7v/IAUePr6cyCYEURc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un+jljQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un+jljQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC373C2BBFC;
	Thu, 13 Jun 2024 11:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279257;
	bh=OW/eMcN77JmeOF3DtFGGxqZNH8QCdfLtJ9MWoL+mIfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un+jljQL8qcO2oGDO2oF6E9EeLvBKfh6hYel7tHG3XB5RW8LDhp+dHtyzKoVzVw3J
	 6dz8C2OHPT1T59u3VVxouu/pfAZES7DaOLYGavUv98ivCsTTugGyXeN6+238N/zwLa
	 MNC7BGesq5bViFrGXY0CIVYUjsXzxxU2ja6U00bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.9 015/157] ata: pata_legacy: make legacy_exit() work again
Date: Thu, 13 Jun 2024 13:32:20 +0200
Message-ID: <20240613113227.997413968@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit d4a89339f17c87c4990070e9116462d16e75894f upstream.

Commit defc9cd826e4 ("pata_legacy: resychronize with upstream changes and
resubmit") missed to update legacy_exit(), so that it now fails to do any
cleanup -- the loop body there can never be entered.  Fix that and finally
remove now useless nr_legacy_host variable...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: defc9cd826e4 ("pata_legacy: resychronize with upstream changes and resubmit")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_legacy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -173,8 +173,6 @@ static int legacy_port[NR_HOST] = { 0x1f
 static struct legacy_probe probe_list[NR_HOST];
 static struct legacy_data legacy_data[NR_HOST];
 static struct ata_host *legacy_host[NR_HOST];
-static int nr_legacy_host;
-
 
 /**
  *	legacy_probe_add	-	Add interface to probe list
@@ -1276,9 +1274,11 @@ static __exit void legacy_exit(void)
 {
 	int i;
 
-	for (i = 0; i < nr_legacy_host; i++) {
+	for (i = 0; i < NR_HOST; i++) {
 		struct legacy_data *ld = &legacy_data[i];
-		ata_host_detach(legacy_host[i]);
+
+		if (legacy_host[i])
+			ata_host_detach(legacy_host[i]);
 		platform_device_unregister(ld->platform_dev);
 	}
 }


