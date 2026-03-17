Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB6F3EBF3F;
	Tue, 17 Mar 2026 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765467; cv=none; b=d/b8AlmFOj1mMTMHurzAehcvBWIl5k0cKPOAXlyTmDJ04RMokiOOxlv9veloEhVzSlSWp85s3jH10JAMhzMuVDw3AFjQBJ5x2AybywzcKJIJe4R2wPa16EpUUHPHkC/yugUzFDo6Ie64/MpTsKvpn+3RL00OuVQ6eEsZEFIQ+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765467; c=relaxed/simple;
	bh=+Sp3z96lxiM7fx5QFN2GmaTmMWIlTjpF+3OeGUX68Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHJM8UozvL1GdbXSsB4Jt+npvk+w6snYACs/9egzojOwlJpKlh2P4pnS11fz10M91H33gl41C0tJu0WFfhcjSKvyQ/l2J7GZmrqYEmzxBwqpK7SrNz50vEXwoQdJi243paVa+KwAH7F0fUnDD7yUJH9QeGHpmU6lrzGn6CKZDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhSB90n+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhSB90n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC3C4CEF7;
	Tue, 17 Mar 2026 16:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765467;
	bh=+Sp3z96lxiM7fx5QFN2GmaTmMWIlTjpF+3OeGUX68Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhSB90n+AsJ7hn1v5TIs29FbVu2MYO0gTgfrBocWMJWqQWp1lf77y1Jues0hhzusf
	 ZJGMDRXf+cVUJF+b5HVi2riWKRARGxKAfi3JdVn+h1iF6eiIGuvp/tSC8YJwwRXr8o
	 NTVlrFg+l5SNipBQgYWV9SO6TJtVp2jcySrDq8uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 018/378] scsi: ses: Fix devices attaching to different hosts
Date: Tue, 17 Mar 2026 17:29:35 +0100
Message-ID: <20260317163007.645444452@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2c61624cb4b03..50e744e891295 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -529,9 +529,8 @@ struct efd {
 };
 
 static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
-				      void *data)
+				      struct efd *efd)
 {
-	struct efd *efd = data;
 	int i;
 	struct ses_component *scomp;
 
@@ -684,7 +683,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
-		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+		ses_enclosure_find_by_addr(edev, &efd);
 	}
 }
 
-- 
2.51.0



