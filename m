Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD763BB9E6;
	Mon, 23 Mar 2026 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282424; cv=none; b=s0Yy24KgF/x1j6lANHZta8KrTC6A94BmIBSpJgJmDN7TnPOoDpKgoPgZUXWlth4ivyXyePvRLXNA+T5L7EZ7VezH7yZd+JlPwqwLwGgS6ghDPPGZYekXh4PL8Bv6XYK7DX3WPbxMQ7V6atyWbCr0pqXNDY2x/vW5Qg7SAwYA8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282424; c=relaxed/simple;
	bh=Nqtb/AbPopKTCzKVfn4L/rfAqMJbLVlwAvng6sz7Vv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hW0kQmGoPvy4eIELHVvfS4UXUvKeGZbiRpg2NmdLNdKpoPQzTxatItq9PpnACn761Nqg7BfRNpjCFyX4cH521Bi7IYcVdl+uHhdKehe+tB3p4shKKCzwkfmzpI/6df/WlU7tCTpfEC4zz3GKnV9uNOgA3n/dfDmls8PwiFSad+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnQGpUvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnQGpUvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C957C4CEF7;
	Mon, 23 Mar 2026 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282423;
	bh=Nqtb/AbPopKTCzKVfn4L/rfAqMJbLVlwAvng6sz7Vv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnQGpUvTLeCwA3ENYqZ6l6yqidEkFtsWejUI5rwxPLzZTmrYPFMuog5G9PiU62oJ3
	 jByWC9FHQy2tgOJsItgQnovkoOYxUEzlOcgf3xh9Gq4BAEez7uKBPg7cibmvgtD9OG
	 qPI3r+UbJ0vaVBsZW/oo9LWOUVZLTTrCymcBpPGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/481] scsi: ses: Fix devices attaching to different hosts
Date: Mon, 23 Mar 2026 14:42:14 +0100
Message-ID: <20260323134528.950010669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



