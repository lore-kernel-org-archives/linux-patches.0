Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D49384;
	Thu, 13 Jun 2024 12:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281980; cv=none; b=TUxv0blom4rpiECgawlnN01B7WwTbH4kFXLaVQvUOYAZCMtKimkX5SbpZ3nX7N9ymIiJX/3dQYOzwlDZTE5ztxXmgxb4zx8QFBBx3ypnmnmIM2gwDKE8xYvwIB/K1YGKYzwcmbb5zez+dxl41R5+UNRMlH8GY4auREsNy+wjGwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281980; c=relaxed/simple;
	bh=khD6AEXs6WjYw2MOj6iqVM0Vrhf4TVe9CPTl0qTPwkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ng6UIfkHsaT+6YYrNg6u/UisOg3ehkvnKpmhKIoTcYeOYWbi9/yZ0rxhbpSUppLNv3kht+Sg+ANX7UCWv3i7BvPpiK6IBK9crCYEURycMKUGtAQy1+BD4TyWWOqk6mCvZs7OuFxmxexNY5VdASM5GFyxZ8DVqgsWXMeFyYqLhRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMh3Jf4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMh3Jf4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB28C4AF1A;
	Thu, 13 Jun 2024 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281979;
	bh=khD6AEXs6WjYw2MOj6iqVM0Vrhf4TVe9CPTl0qTPwkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMh3Jf4uzDYO/Kw+Pzuc/ezJtCpipWZ/765DySoiz464Bx5DXg7q2oRw3lecnQmjr
	 jFS5kKeAmiG1/ixIFNRJ+Nm3A3If7f9ZLaguoQCfwB3MPWfpFqjoYJnL3pxRRtgkdP
	 fc82s0umDmVrOjwCH81nXgr3UqdfkqXBcOYwI1XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/402] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Thu, 13 Jun 2024 13:30:38 +0200
Message-ID: <20240613113305.294941213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Karpov <YKarpov@ispras.ru>

[ Upstream commit 504e2bed5d50610c1836046c0c195b0a6dba9c72 ]

struct Scsi_Host private data contains pointer to struct ctlr_info.

Restore allocation of only 8 bytes to store pointer in struct Scsi_Host
private data area.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bbbd25499100 ("scsi: hpsa: Fix allocation size for scsi_host_alloc()")
Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
Link: https://lore.kernel.org/r/20240312170447.743709-1-YKarpov@ispras.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8aa5c22ae3ff9..b54c8aa8e8035 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5848,7 +5848,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



