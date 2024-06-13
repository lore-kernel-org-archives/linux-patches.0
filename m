Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216701465BB;
	Thu, 13 Jun 2024 12:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280198; cv=none; b=nFEMoyy4sXHkvnnS1EeG87HuQYE6Eu3CIU9v9AlqYBBwrDP+mauMarBcwxNlMrOugAW+qqpaNw5lv7X3xGSi9QfYhByPaz5U42p/w+RzHlBIbsVf39Em66DX732yzI5BjnCSjmTMWhD+2N9FDRdcyM55xbCg3kt7xQI1i74fIyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280198; c=relaxed/simple;
	bh=dOyUHkCIqHdgyD4d1l5+ZmyH0yeqvj+hZN9woY9vShw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYfDMUpc3xU/wi7tlLTLomFONxghg/R/Z9NDCavwHw8JhCiwpviTiBK2lSZaePPpcW/BSkIk96la9btwFq4b7GJB2E7ufZMKIo4X/hjXttusq7p701z4gkxUFlAnYzKHAD9e+QM84ZpbGGpNt4020Kb7A575Z2OQhmLTQ0RPwkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNvzfS6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNvzfS6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C590C32786;
	Thu, 13 Jun 2024 12:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280198;
	bh=dOyUHkCIqHdgyD4d1l5+ZmyH0yeqvj+hZN9woY9vShw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNvzfS6FgQsCBuuPHL9A8vNZRT+Dl/5dDJ2Jrm5KZoPwICMGDwcUVrxlz2qWX2O5P
	 82V0ZVEVyTy2NSorqbOlR1fDThgAoIiUmseJkENSg51KnLFRoe9YGczbKxJl0bXjWE
	 nNLDnGZkxrMGcyT3MMw8ufALTlq9jzINf7kgmkoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.4 175/202] ata: pata_legacy: make legacy_exit() work again
Date: Thu, 13 Jun 2024 13:34:33 +0200
Message-ID: <20240613113234.494485138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -114,8 +114,6 @@ static int legacy_port[NR_HOST] = { 0x1f
 static struct legacy_probe probe_list[NR_HOST];
 static struct legacy_data legacy_data[NR_HOST];
 static struct ata_host *legacy_host[NR_HOST];
-static int nr_legacy_host;
-
 
 static int probe_all;		/* Set to check all ISA port ranges */
 static int ht6560a;		/* HT 6560A on primary 1, second 2, both 3 */
@@ -1239,9 +1237,11 @@ static __exit void legacy_exit(void)
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


