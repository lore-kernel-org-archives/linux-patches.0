Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B648F2FFDEA;
	Tue, 17 Mar 2026 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767078; cv=none; b=q7Bnlt830qgpmbXB78/BEhhD4woXqytwRS4V8NmyL/0tfsU6eBRt9q4GBRQbqynRQmEawLy+PCFgCcudegaMM+FAPfAc5wZN1QBXIBGuZN/NBElP4u7qZHpJwEAgSoZ2kaRwlYxgsnow6UPpPDHPNK8xF/hGVEbM552OorlTkHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767078; c=relaxed/simple;
	bh=3/q6aGZkuVmbBcfGUQZ3jO4AkoceIV0CHZTFDNdq454=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo82iSS5QreEqSWL19Ut3TlPV19hqu6dr43XeJQIPC8zuN1UgLW9RKwA+CG3q2si/6PMBMYAGKLX9wBh4tagSpXwnQC4t/fDtNE2wnBnpbZqysLu4nPHEL4pq8dJ/roKGH7JgT6O7KzhJdVXQTkvd2uthRQBFp4csJ7XAreYLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjWJMGEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjWJMGEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264F8C19424;
	Tue, 17 Mar 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767078;
	bh=3/q6aGZkuVmbBcfGUQZ3jO4AkoceIV0CHZTFDNdq454=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjWJMGEeb2akQ5L92AK+ThLXgwtNW2ESwQ966gzaD93gcq7/hevfrYIZGEPoADAG+
	 mTxIJ853zPUXambHZGf5G9+mSrtNBl8ZjT3W72pQZoKq697YejJZ5EO7R5uz0lhdtv
	 3pLgkefA4bxjXKsXu26+tWgRpA/dHkDjltV9L7/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/333] scsi: ses: Fix devices attaching to different hosts
Date: Tue, 17 Mar 2026 17:30:39 +0100
Message-ID: <20260317162959.740125408@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



