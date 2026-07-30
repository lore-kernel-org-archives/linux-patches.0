Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A894C4119E0;
	Thu, 30 Jul 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422882; cv=none; b=tzTHeQZQvw7FKEASCL24PxI1Hr9rwd197pgliH5kUIvVpqMNBtEzVCVCIshADCxECFS05NFTu+9OVAWq6dXu8h6ruWdw6ybLalizx6hovkX8I2F2f9TUUPJp9a+2KyCbVROJrkjIbYztu6qs4bDUNU4qjnhRFeOfSBP5MgOyTlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422882; c=relaxed/simple;
	bh=/eiO7hVkTszSLIR+6Fnehd+pkOWMgUiKdNZFcE55uPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFnIz0DWWXJ/3WRYIB0IEipFY6BuxyG2t1rgz47sc+BPlQqXR5hdL2RWfsfiWk8+dp0T62WRFfJMBrSC+o5J0MgGm1FHclJyre/bNlovtYnyvlbuZXvhzhtxA++lgm33M4aA+CpL2UxdST//PqTOJIM2Fi9IqY7eEynrDS6Bifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReTeVvxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReTeVvxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105B11F000E9;
	Thu, 30 Jul 2026 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422881;
	bh=w5bUO/2XvtuntelfOaM5kgsNJMNVd6fWi/YCLGOVCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReTeVvxW7GEjVrTjvi98wpBTzv1B+18Y7Nm4fPyc0DKAMnkHcQAoGZ8pyedsei6dA
	 H+sLOMmgwch2DXYc+w+0ljV41t2QX9ll6T3Z05/NtPKjlfq8WBUELZSDLCnWi5VIjh
	 7Ll68qQ9M3x9tQEffniDB4qx3/NWFUVJJiX6fN1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 7.1 588/744] misc: nsm: only unlock nsm_dev on post-lock error paths
Date: Thu, 30 Jul 2026 16:14:21 +0200
Message-ID: <20260730141456.781281732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


