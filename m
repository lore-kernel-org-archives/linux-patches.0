Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BB73418E;
	Fri, 24 Nov 2023 19:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDee19rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3A1C433C7;
	Fri, 24 Nov 2023 19:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853436;
	bh=/sUac3rDmZxDEGfOGTI16J1VCZtzuJi3L3R0uEC02UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDee19rgtRyEAJoyg6lUwBrDE+2tZbBR6DP6urdvgoaXAPpUkr0+W/iZ+51kv1zxM
	 9Nstse5AtSwFoWZa09bI7DhNpCe27wzKAWR8T0lwOtmV8TS+flNO0FndZeqQ9uWIxk
	 7FE6Fy2/ij6RhKS4YfohtfkvGAJXhyCw1/ed4upQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 161/297] scsi: mpt3sas: Fix loop logic
Date: Fri, 24 Nov 2023 17:53:23 +0000
Message-ID: <20231124172005.879385351@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit 3c978492c333f0c08248a8d51cecbe5eb5f617c9 upstream.

The retry loop continues to iterate until the count reaches 30, even after
receiving the correct value. Exit loop when a non-zero value is read.

Fixes: 4ca10f3e3174 ("scsi: mpt3sas: Perform additional retries if doorbell read returns 0")
Cc: stable@vger.kernel.org
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20231020105849.6350-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -224,8 +224,8 @@ _base_readl_ext_retry(const volatile voi
 
 	for (i = 0 ; i < 30 ; i++) {
 		ret_val = readl(addr);
-		if (ret_val == 0)
-			continue;
+		if (ret_val != 0)
+			break;
 	}
 
 	return ret_val;


