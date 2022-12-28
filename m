Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919EA1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF479C433D2;
	Wed, 28 Dec 2022 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243957;
	bh=8jvAjcf/lfd4jbxmi86lR8uOaOjt4H4vhAARLh26D1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEEDpxiuR1iYZJEB1HHbehVNCeD83FnB9jpcsLBHyRnw0ATCmsxzpbKyVkci8DAUY
	 RnChE/txceC9Ob4iPXuNLNORrDoLJ81KQog7c85y0dlyF39Rt4AfomTVXPNRT6k7t/
	 jPhpo9jy0hOsCthu8cyEs+VTikrgM3lqsqJ7cfoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0622/1073] scsi: scsi_debug: Fix a warning in resp_verify()
Date: Wed, 28 Dec 2022 15:36:50 +0100
Message-Id: <20221228144344.938782344@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 1355820b9733..077782eb55e7 100644
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



