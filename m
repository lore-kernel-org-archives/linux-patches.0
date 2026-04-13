Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4057828314C;
	Mon, 13 Apr 2026 16:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098707; cv=none; b=f4fJ7EgRbwxbMC+RZ4nsCf6QKXloXLMTTgjJ6t756K94M9Uyo7fgBV81qfFfsu8HGgAZWI1MEMOeXWlUccVtaQWdBhCQsKxsg/XiF711w1x6xJIoTs7/+NVg5MLBaCTSNn8p3iMiUGC4/fPahbNQuZhESHKBit+M20bPT9UU8MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098707; c=relaxed/simple;
	bh=9pqAF40Z+KwTAsw0eYmtAb5vEDh1a0lB+lyMi2XyBKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqCvwhHqc+hg8pdDZuNkiSmkmH0WMkzTSCRWwpSfOoyArQHWEl7TXaBxdJGGHT9ZSFs3QAOsw4Ns7ptY/pCzEsMwzd+3aiHS5D329Z6PNUM1tWPR9GaiiURU0BFHXMQbogeZ9SeesvnSQGA+3gbj1KCTgw9qpds3MchuyQr+Itk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hoUREOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hoUREOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C761BC2BCAF;
	Mon, 13 Apr 2026 16:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098707;
	bh=9pqAF40Z+KwTAsw0eYmtAb5vEDh1a0lB+lyMi2XyBKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hoUREOZXpyev2X7yIk2HBuht4qwcTzFXjyyhgGeUaT+wb2GX+w9zAnzw5G/8Hu/7
	 LCtZf5sA36aa0lWonsnHnTlMiz3QZO+BwWUKqihRzrV46Rtw0AnffumAoQELcR7edU
	 ZpPsymQQ9wSNMqM4s0vQqQjxtQRkGHyB9EKfgHKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/491] scsi: ses: Fix devices attaching to different hosts
Date: Mon, 13 Apr 2026 17:55:02 +0200
Message-ID: <20260413155821.184336247@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 70ca8caa96ce473647054f5c7b9dab5423902402 ]

On a multipath SAS system some devices don't end up with correct symlinks
from the SCSI device to its enclosure. Some devices even have enclosure
links pointing to enclosures attached to different SCSI hosts.

ses_match_to_enclosure() calls enclosure_for_each_device() which iterates
over all enclosures on the system, not just enclosures attached to the
current SCSI host.

Replace the iteration with a direct call to ses_enclosure_find_by_addr().

Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://patch.msgid.link/20260210191850.36784-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ses.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 6a1428d453f3e..92b3fd10058dd 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -497,9 +497,8 @@ struct efd {
 };
 
 static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
-				      void *data)
+				      struct efd *efd)
 {
-	struct efd *efd = data;
 	int i;
 	struct ses_component *scomp;
 
@@ -652,7 +651,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
-		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+		ses_enclosure_find_by_addr(edev, &efd);
 	}
 }
 
-- 
2.51.0



