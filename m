Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9EE26E718;
	Mon, 23 Mar 2026 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278110; cv=none; b=egTZ1ku0ORZDoURm8KBGXlq1uAGiVooXABl7+Kc3WqlHZD7I5d0w1DLzumVUA+QnPEiBzO3TT51gCiyBnf7lPcg+Nl6xAxaHowqCTV4sq+3pmCn9QKObewSjIRjRZiABAwXyplfFO1n1QmYCvQHs9PMWK1XEQe/iwPmBAm/ZYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278110; c=relaxed/simple;
	bh=8cUGIUtz0pmMAuuI5c9QjVd33qz1fs+1IJ3MkwLKQk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuI+iZQ3VJFNOKNtPAujQl9mdClLso7YIvQ00mPCSoQh/Jh5WA/nhAiOwpT11PoQ0OL6S7gVHIKQORYVYOTErELSwwlKitdP7a3xJOaA0GXi0m+jtAKjLpoWKVfOEjZjX6Zv0KFAQ2isobiodX33z/8bENGJnMsvBGS8hsahqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0rfy2Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0rfy2Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D82C2BCB1;
	Mon, 23 Mar 2026 15:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278109;
	bh=8cUGIUtz0pmMAuuI5c9QjVd33qz1fs+1IJ3MkwLKQk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0rfy2Dk4Uh4k9iyx3VapPFAmbZ1n00lvhUWxQZ5JZSGLWzo2uSRtQx8Ov9WyWyc7
	 E7+KOSnvpOeV6xagMiM6lBecmC/2CXbLKuuO1c10Pfj6Z5U4xrKyHiM03zDwXkS+8M
	 vTULp9WPUHrqo8rEdhQ1uHKrJHeyMaOu+O56t9Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/567] scsi: ses: Fix devices attaching to different hosts
Date: Mon, 23 Mar 2026 14:42:04 +0100
Message-ID: <20260323134538.891414969@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d7d0c35c58b80..05e462f328e75 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -503,9 +503,8 @@ struct efd {
 };
 
 static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
-				      void *data)
+				      struct efd *efd)
 {
-	struct efd *efd = data;
 	int i;
 	struct ses_component *scomp;
 
@@ -658,7 +657,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
-		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+		ses_enclosure_find_by_addr(edev, &efd);
 	}
 }
 
-- 
2.51.0



