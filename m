Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B8523792;
	Wed, 30 Sep 2026 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790561; cv=none; b=A69ZYV9c+ydZW8tMEcI1Ga1LUi/wg2MBqvJxgKxr+K8xxTehQfFbjIkMzp7M/jdCD8zV/npTIlDwaN0uC8vV7zdxuAa6brVK6IYZ1MP3f8rk7D8qg9RQRPBcPpt8dG0JCT/LhVcMjZ0fUSW5waOFAsbqqd4uBcFDosQbUE3Qwrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790561; c=relaxed/simple;
	bh=OFAS7rM8cbJqjW6nR1xWuk5UK+G2D2SNjJLYshYZJmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aww0nPGwDfWVJ3XSRJjydLbi/tOQ7AsPOBy6DpJSo/4O5zhsMdsplzWWqipsEN8lMuUTSpDMys/9OMZBRyYeTaRIlwhPI5tCvGUXs1l8r8AFnUkhs/+ctuy7D7l318X26KKpjnWqjRccFgNeADZPY20UxbgjptNBAFET7z0frcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMdyt9GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMdyt9GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0BC1F000FF;
	Wed, 30 Sep 2026 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790559;
	bh=ngTJvxXHrcl/jJJEznmEyCl0xGCMngNhfWntGI5MjLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMdyt9GZoB23p/HYGe5bYrJgPC5kqA4IXzvQWr8hHQJ5foPpBEVb6ki5Dqsq34Yw5
	 QGtKcZAHPqYx+4p0zu7zJBrv0GJiuqaMj2bUDyKzTHDNNJWnxcYd1K5zF7VmJC9CMd
	 CYDybpVWkIFCJxr3xu/ytYoREITeWv8iD09ktoxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Alan Adamson <alan.adamson@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 6.12 870/877] nvme: revert the cross-controller atomic write size validation
Date: Wed, 30 Sep 2026 17:29:41 +0200
Message-ID: <20260930152433.508066701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 1fc09f2961f5c6d8bb53bc989f17b12fdc6bc93d upstream.

This was originally added by commit 8695f060a029 ("nvme: all namespaces
in a subsystem must adhere to a common atomic write size") to check
the all controllers in a subsystem report the same atomic write size,
but the check wasn't quite correct and caused problems for devices
with multiple namespaces that report different LBA sizes.  Commit
f46d273449ba ("nvme: fix atomic write size validation") tried to fix
this, but then caused problems for namespace rediscovery after a
format with an LBA size change that changes the AWUPF value.

This drops the validation and essentially reverts those two commits while
keeping the cleanup that went in between the two.  We'll need to figure
out how to properly check for the mouse trap that nvme left us, but for
now revert the check to keep devices working for users who couldn't care
less about the atomic write feature.

Fixes: 8695f060a029 ("nvme: all namespaces in a subsystem must adhere to a common atomic write size")
Fixes: f46d273449ba ("nvme: fix atomic write size validation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Alan Adamson <alan.adamson@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3373,15 +3373,6 @@ static int nvme_init_identify(struct nvm
 		if (ret)
 			goto out_free;
 	}
-
-	if (le16_to_cpu(id->awupf) != ctrl->subsys->awupf) {
-		dev_err_ratelimited(ctrl->device,
-			"inconsistent AWUPF, controller not added (%u/%u).\n",
-			le16_to_cpu(id->awupf), ctrl->subsys->awupf);
-		ret = -EINVAL;
-		goto out_free;
-	}
-
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
 


