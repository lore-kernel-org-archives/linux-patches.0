Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8391C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556A8C433D2;
	Wed, 28 Dec 2022 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244313;
	bh=nhVLOn9tQ1IgdvyQjuR0l3ISCzx0EW2vFTSi8xyFKEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSOKBwenDvUo47xKOf8eFQdQqiCe+BjNhZJvW7hAO41hlGr7RM1XNHViwWdmd+K31
	 RaXkJ45hG9GcGlbeVebhY7wKVAhVhRgN8b4AjFxppMBG9Z86e7IT7FnP4Kwnw+uFBM
	 xgHEiBI/wi/cg+735tzD2u9gZG+6KNsfeK7cfEi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0649/1146] scsi: scsi_debug: Fix a warning in resp_verify()
Date: Wed, 28 Dec 2022 15:36:28 +0100
Message-Id: <20221228144347.786242417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit ed0f17b748b20271cb568c7ca0b23b120316a47d ]

As 'vnum' is controlled by user, so if user tries to allocate memory larger
than(>=) MAX_ORDER, then kcalloc() will fail, it creates a stack trace and
messes up dmesg with a warning.

Add __GFP_NOWARN in order to avoid too large allocation warning.  This is
detected by static analysis using smatch.

Fixes: c3e2fe9222d4 ("scsi: scsi_debug: Implement VERIFY(10), add VERIFY(16)")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221112070031.2121068-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 57b091f1767f..78cfb706a4a7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4436,7 +4436,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (ret)
 		return ret;
 
-	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
+	arr = kcalloc(lb_size, vnum, GFP_ATOMIC | __GFP_NOWARN);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.35.1



