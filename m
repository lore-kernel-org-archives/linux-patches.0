Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEFB31740;
	Fri, 24 Nov 2023 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8vN9rjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B5BC433C8;
	Fri, 24 Nov 2023 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849664;
	bh=ycDklFN8j2mQeJx8zpagb1kuDffXBuGoLPGU+++dEcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8vN9rjABd46cG/vJhYR1LkLxHRkedjmW7LpQLWqKNH3vXewUURj7VihsyHJjIRCl
	 G1JR6qvhPq/p8JuEfReemr7Iyfd9Q/H8VkcDPeybv9UBrbLRbyr9ADqXvdyfHgOh22
	 GKEh53ALFQ4xp30t+tD0l4+3uffFqRZWN1RqHSuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 247/530] scsi: mpt3sas: Fix loop logic
Date: Fri, 24 Nov 2023 17:46:53 +0000
Message-ID: <20231124172035.571626494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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
@@ -223,8 +223,8 @@ _base_readl_ext_retry(const void __iomem
 
 	for (i = 0 ; i < 30 ; i++) {
 		ret_val = readl(addr);
-		if (ret_val == 0)
-			continue;
+		if (ret_val != 0)
+			break;
 	}
 
 	return ret_val;


