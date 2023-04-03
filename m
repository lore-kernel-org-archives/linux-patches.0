Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6947A5698
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34F8C433D2;
	Mon,  3 Apr 2023 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531116;
	bh=RxUOKQnkZ51m0C4w7P7Mc8ot7XLDQpDTuCM0VAoHUxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znri+Y0CV6Asl1IQe/ArLRT9pL5kQITtX7IAcyPkKm9yBf6cmuTbIuL3OF+NA2ZNj
	 +V4eJ8+p7qYQ+1B6dydK6NSLvK/9b58Cl70T5C96tj3YYZVutcAU30jDvSfR4DPjS+
	 32TPrX+Ly68rEY4ePTmcliGERNAwXkAZ6VI8LSRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/66] scsi: target: iscsi: Fix an error message in iscsi_check_key()
Date: Mon,  3 Apr 2023 16:08:34 +0200
Message-Id: <20230403140352.848944501@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 6cc55c969b7ce8d85e09a636693d4126c3676c11 ]

The first half of the error message is printed by pr_err(), the second half
is printed by pr_debug(). The user will therefore see only the first part
of the message and will miss some useful information.

Link: https://lore.kernel.org/r/20230214141556.762047-1-mlombard@redhat.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index caab1045742df..d2c8c4929f93a 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1270,18 +1270,20 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		pr_err("Key \"%s\" may not be negotiated during ",
-				param->name);
+		char *phase_name;
+
 		switch (phase) {
 		case PHASE_SECURITY:
-			pr_debug("Security phase.\n");
+			phase_name = "Security";
 			break;
 		case PHASE_OPERATIONAL:
-			pr_debug("Operational phase.\n");
+			phase_name = "Operational";
 			break;
 		default:
-			pr_debug("Unknown phase.\n");
+			phase_name = "Unknown";
 		}
+		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
+				param->name, phase_name);
 		return NULL;
 	}
 
-- 
2.39.2



