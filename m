Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E174E1DFD1;
	Sun,  1 Sep 2024 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210518; cv=none; b=l2XNU14rWOKjvv0MOAbCxlDSn9GvOqn5I8ShJr+WiX007MEKi9eSvPwBH1wKtVVs4L2tws8PrSuuMTo2ie2be/a04rPwsLy1SLlHeSwd+Zx1iWp/pYGtFwudxQ4ZVSJ3jEBMc6HZBR3KNW/PFi5eYJtBBp6LfHH8gE7u1TeEoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210518; c=relaxed/simple;
	bh=G3ULU4GP+WZITfZnCgLclxid13G18eLb/WdLbOzQFpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaVD5S4eb+6/BR9Xd6SZnLsUkTdMQV2HLk4fc6VDRywDZfsglZ35WCZrGieygghuWWRUVRprLosW2fvD610hd4TyQAxlL8CMHId0sA3tXjV9BHvs985SjL3hlxXDPIkQk2eXCgmAm8qXI88Xq2Q5J0Q1IezoFHve5Yt4PmInnkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTSPLYmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTSPLYmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C16AC4CEC3;
	Sun,  1 Sep 2024 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210517;
	bh=G3ULU4GP+WZITfZnCgLclxid13G18eLb/WdLbOzQFpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTSPLYmMXDmWu73XvwqQDbbGoQGVqXdE1ml1JStYPiEIGtzsxVbIEu0rHrEbEC95G
	 Cbhw6mqfO9wJaRJyjmjsVcAfBjgYdDTQm0agRPoig7rNl09b4VcYFq4dYgixGBxMmD
	 KmykDRr3LPiZ+LxqusQziqXcEHatRZipgqf4Oaqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Gordon <m.gordon.zelenoborsky@gmail.com>,
	Ben Hutchings <benh@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/215] scsi: aacraid: Fix double-free on probe failure
Date: Sun,  1 Sep 2024 18:18:46 +0200
Message-ID: <20240901160831.440834353@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Ben Hutchings <benh@debian.org>

[ Upstream commit 919ddf8336f0b84c0453bac583808c9f165a85c2 ]

aac_probe_one() calls hardware-specific init functions through the
aac_driver_ident::init pointer, all of which eventually call down to
aac_init_adapter().

If aac_init_adapter() fails after allocating memory for aac_dev::queues,
it frees the memory but does not clear that member.

After the hardware-specific init function returns an error,
aac_probe_one() goes down an error path that frees the memory pointed to
by aac_dev::queues, resulting.in a double-free.

Reported-by: Michael Gordon <m.gordon.zelenoborsky@gmail.com>
Link: https://bugs.debian.org/1075855
Fixes: 8e0c5ebde82b ("[SCSI] aacraid: Newer adapter communication iterface support")
Signed-off-by: Ben Hutchings <benh@debian.org>
Link: https://lore.kernel.org/r/ZsZvfqlQMveoL5KQ@decadent.org.uk
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/comminit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 355b16f0b1456..34e45c87cae03 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -642,6 +642,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if (aac_comm_init(dev)<0){
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 	/*
@@ -649,6 +650,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	 */
 	if (aac_fib_setup(dev) < 0) {
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 		
-- 
2.43.0



