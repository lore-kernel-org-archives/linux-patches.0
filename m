Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB553264C2;
	Wed, 30 Sep 2026 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790609; cv=none; b=EaO/s+N96ZI3BsnAR/D2BVdneQNLaWqWmXTRJt7efV/jWWBoH1LVpLogUk6/n4tGIZZMhFGlXg8UhCnJIAalX+8ixs6anQdjsfidH06LLIvb4vbVRxPGwl3BDsflBits0cHidjClUjhhPiuSXuMNaD+8Vkas7g+Pua0MImtPjaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790609; c=relaxed/simple;
	bh=SLyZG8Oi9I8C6N0b9LNzgQRK8Au6+bAD1h1qVpq0xaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3pEZFG/KGua0hRWfM+OXdO3FHBs8bDNFU1655Nzq6v9adfN2OfOwtif/CKf/mTNQJjiRUmy8IHolrpjjkkRnXKX6WwS3oIG5paOmBist0hO1tBVXAbrXFtTeU+ObUdjLbOgwdqtTiNPG3LorRKETiAFsP+m4fYAETSs9mVSJPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLmmItd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLmmItd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866771F000FF;
	Wed, 30 Sep 2026 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790608;
	bh=s0oB5AFjzPltD1hiYkT5/pCyipGGPnRrDEY5NzdobS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLmmItd/1++ndWVlWY26RJV91h4anLIk3BktmhV68krk7Yxj3svWpTKAnznxwB8JF
	 kWSboymcRzDzl7BUH/wPLdCUAHa3KIng+U27Y85QQ3cmWpkPaOvhmLUppzgVRc8UOV
	 pEs8kPiyoeiZjQ4g75bg07l/UnCH8Hm/dLErdWSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/752] s390/cio: Purge based on the cdevs online status
Date: Wed, 30 Sep 2026 17:18:02 +0200
Message-ID: <20260930152358.413512113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 58d50cad63e85daae032924ecc3d457fb1ec02fb ]

Ensure that all devices currently offline are purged correctly.

Previously, purging logic relied on the internal FSM state to
determine whether a device was offline. However, devices with a
target state of offline could be skipped if CIO internal
processing was still ongoing during the purge operation.

Update the purge decision logic to rely on the online variable
in the cdev structure instead of the internal FSM state,
providing a more reliable indication of actual device
availability.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 7f1d4b41391aa..107a26b471c95 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1336,7 +1336,7 @@ static int purge_fn(struct subchannel *sch, void *data)
 
 	cdev = sch_get_cdev(sch);
 	if (cdev) {
-		if (cdev->private->state != DEV_STATE_OFFLINE)
+		if (cdev->online)
 			goto unlock;
 
 		if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
-- 
2.53.0



