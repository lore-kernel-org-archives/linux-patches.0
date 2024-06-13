Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D01A146D45;
	Thu, 13 Jun 2024 12:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280344; cv=none; b=NvW67QE4+eoU7YmO1Exs3RUNPo3n1cay/7kjNMe0w2VXwoow39tznKTKo/sdtRuBB1qKFOL8t/N9p01ALoiQuOALvDzpY4NlmYzroLtC0cuTS9lkU2fCmAozX3tk6812esSH21UeaF2vi5XfXr8Vmiyw8bpeLvBUqu/bz9rc8EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280344; c=relaxed/simple;
	bh=dO/lprbgT35h7vCu/f9okB4r+Nz3UIToJMZ980dtxOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fU2HW6ooumjmC4S/hveD97Mm2UBWeWjiowPygSnm76Rksht2agGJRlEd/yRLtIGqAafeItCgkLBy0fDwI+XPEhk/gEO8U71GkBdXq1L0b4K069sR5ZQssC4EmbkDBfpczZWp+syE1BTc4CME7jLE46AdqsD5GSs7KP1JkxaFfxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epDIyN/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epDIyN/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E4CC2BBFC;
	Thu, 13 Jun 2024 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280344;
	bh=dO/lprbgT35h7vCu/f9okB4r+Nz3UIToJMZ980dtxOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epDIyN/AfZTX7s8T6HLmyxO5u6GKEuyLWLIfA+PV9vSufnKLV0c4MHq5a6QfIHlf4
	 FeumyAqxEoRE9Ao1AsOMdEe1qrn9Ja99a+2iwsW8thGvGGzDpnhJ6kZabbcPgH+LZS
	 OPt1UYmlOFsdS+OAUkMD0f5YMlRZBbT6/7SCsbvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.6 022/137] ata: pata_legacy: make legacy_exit() work again
Date: Thu, 13 Jun 2024 13:33:22 +0200
Message-ID: <20240613113224.148774741@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


