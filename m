Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F93090F5;
	Mon, 13 Apr 2026 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097329; cv=none; b=WetE8S8YK07y8Nesvpon+Nyu7YEDZ55b/X9HJACrFt+ApMH1nTPpZ/AvoxjfVt0TdLMS4JlAN/8mG2rLCeIPG4uBWMZQCFdK4vfLYCwBpEFQ4WxCmg/mTG4UApfqtQE75SsgyDTb/c7Iq6M8GpGyTPWWCEKEJ4xSxj29wQHFeaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097329; c=relaxed/simple;
	bh=XmLzW0aUw1xbXCDg3Ckana1tny4BRONuELgd67BAIpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdw44sTh0tWBAda7HSzDLGvUUBq0yr24YCgNB7z9RCLWgAvbmASK4HqLSAVYJRVAVS0XwH3sJJP+hAKWIDdFVnqisLHiNbEONmyolTIBmSIAgwkDXRiAKYJ3DK0uey3FJGak9MTnu2R76cBVLNOQH+3sjjTjGI6p1hXbCDvhscs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNfs21LG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNfs21LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB36C2BCAF;
	Mon, 13 Apr 2026 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097329;
	bh=XmLzW0aUw1xbXCDg3Ckana1tny4BRONuELgd67BAIpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNfs21LGEHrbaJbvGi/QoDRNoyEVP34JsWY8DL/J74vKtjbaSUd6X5jY93brp4Vh4
	 BMiR1h3lEZDrPx2E7gpR6pJgJn5ZSBLIrT3T91RN44uf7F71NGOaLrDUO8rHnUyDJd
	 jY74enyuYGFKivmIYLyYDJ+3o/vjett97O0TCN54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/570] scsi: ses: Fix devices attaching to different hosts
Date: Mon, 13 Apr 2026 17:53:46 +0200
Message-ID: <20260413155834.003089548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



