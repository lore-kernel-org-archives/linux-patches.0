Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898003806BD;
	Thu, 30 Jul 2026 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426330; cv=none; b=mtyiupdlH03W1lIdUjcPIXuc+nHbP/T9EOhSNjUDiVN5bRImdlm9seYcC8hLNjzHFEpldBhXPgVfQ+k21adD6MuRLDKGTyTpeS35L8cfPHz20oB8N6Bg8wqmWc5ZD/eYIp2Z8l8xzYjx/YM8P8fyzgRCzNbE8j7LTpjDAPKM8Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426330; c=relaxed/simple;
	bh=BvA35myBNlgoY0SD7tR/8hizmlhNQ5G2jQZZpqK4BGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWcWnCOq9dNdER9k8+2nOlBEBFESHmVVjCvWFTomg3ZFHtPIasWIE+1tjKw7StuxHc716LzAAfwJeUGysOmsO61JZw7syDfE2n5r4Gk1EZNAC1Rk6mmGZt1ubBWY8SOr9a8WHbpt/ZPVSji4E15htwb6sL5/DMuyzgHpuRsNtXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0ZfdTmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0ZfdTmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59C01F000E9;
	Thu, 30 Jul 2026 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426329;
	bh=/MEm+xN4ezTvto6reT0QS9guLgdLjjzIb0XWeXnrhhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0ZfdTmEqETvWYZmiLwbSnwb1ssgfywhY8nYviAH63ULfY1RmfQ4Kn/EE9IbBXCsO
	 NVLzlLIt67EtVdzn4AgTAXMwIelttR3u0Cy+ixiCyZS5iJfbSWeWKETYRJvODmwO6V
	 4x3KP8ci4tNrruboztFXXDWx9pWKO5PiGrpAmYO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.12 374/602] misc: nsm: only unlock nsm_dev on post-lock error paths
Date: Thu, 30 Jul 2026 16:12:46 +0200
Message-ID: <20260730141443.820875253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit ce1fed11d18e163baf7f875152a33bf80f625c1a upstream.

nsm_dev_ioctl() jumps to the common out label even when the initial
copy_from_user() fails before nsm->lock has been taken.  The error path
then blindly unlocks a mutex that was never acquired.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the miscdevice ioctl entry and the pre-lock
copy_from_user(&raw, argp, _IOC_SIZE(cmd)) failure path by issuing
NSM_IOCTL_RAW with an invalid user pointer.  That failure reaches the
shared out label before mutex_lock(&nsm->lock).  Lockdep reported:

  WARNING: bad unlock balance detected!
  exploit/193 is trying to release lock (&global_nsm.lock) at:
  nsm_dev_ioctl+0x5f/0xcf [vuln_msv]
  but there are no more locks to release!
  no locks held by exploit/193.

Return immediately on the pre-lock copy_from_user() failure and keep the
common unlock label for the post-lock paths only.

Fixes: b9873755a6c8 ("misc: Add Nitro Secure Module driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260617145350.513875-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/nsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -367,7 +367,7 @@ static long nsm_dev_ioctl(struct file *f
 	/* Copy user argument struct to kernel argument struct */
 	r = -EFAULT;
 	if (copy_from_user(&raw, argp, _IOC_SIZE(cmd)))
-		goto out;
+		return r;
 
 	mutex_lock(&nsm->lock);
 


