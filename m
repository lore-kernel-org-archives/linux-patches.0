Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A0F2A1B8;
	Sun,  1 Sep 2024 16:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209805; cv=none; b=nWnNOsiWeI3gBxsMpRNZ20tQ1LDTDBuEsNsDO2u7fc4tdr2+UDmEv0aKz3QZou+GD9k92rQ2AYPtrfxI6SmxLQCVb3eREpDKl69baoKNmEYCOuG+ro0Uv+gkRh/MJSMCntrCzTi2NAga2PzuZG6H0GiUSUxusJ7ai0lFnychFAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209805; c=relaxed/simple;
	bh=4x3vdYn3tsQJle9kxURjx0qaliWRS7PAElZyW4Ze0zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAmSz+5qoGG6Hqo+D/froc8JenB61itXBrNTuIujcrFvyxAf1RHaMkejjnUn0xnZxZEmWYb6gLFd9kOGbkxI7LyNLY4gjtbF5udACFKnKDtQghGuynD2QU4+dtNsV2WWaJsJIq79RxBim/NYdCRL1d0rMc/nmogH650i0cmjIGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgpK+OAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgpK+OAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED8AC4CEC3;
	Sun,  1 Sep 2024 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209804;
	bh=4x3vdYn3tsQJle9kxURjx0qaliWRS7PAElZyW4Ze0zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgpK+OAtiGG07prAGQVeeOCkFjlPktR7VZLjWkSzU1r5I4EXBz9GeTQPUKycLlmrn
	 xcLeJIhsw8BzAW13FZXMCV6Bb6Xfslg4d5m0GaNBSKKmh3aNqsD63gzh+62yUMJAh4
	 pOprBZrEuRKxv+eSq97HscHWIW0RARbUDYKqpaoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Gordon <m.gordon.zelenoborsky@gmail.com>,
	Ben Hutchings <benh@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/151] scsi: aacraid: Fix double-free on probe failure
Date: Sun,  1 Sep 2024 18:18:30 +0200
Message-ID: <20240901160819.755888474@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



