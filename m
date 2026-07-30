Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE3217723;
	Thu, 30 Jul 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424710; cv=none; b=YE8zZNtkKmsIyUmY/OB3i0C9TsNcmHwrDgIWZqTyFQO+/YdXaSS2XastD9vDqvtderYBSaSOYqIZ7ElASNUhltOYU8jxpDRkzyjf9cktTNrAaZ/ECxLo9YmixzC9vVjArZetmcxgp7Et0kjM6rJ8UDHq84fJ850RX3dit19U1Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424710; c=relaxed/simple;
	bh=b/59iO5bzx9CkSaqCGjBZ06CQcejPzktFvmBtXggRJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/gK6vFpFQ8DOb9Oub+pPtMrVxp++S86r1VndcwIsqWWnY5HTWG/2+GHsp1MnhVGEE11MIGRsarm/2dmbeuq+pt1zwOeaK0QZQasiYxHZn5k3buK/uPEzxP4vO03HCH7tGyG7urjVJxdDfOiVm3cy8xXfjn7If9v43ed4KzvSsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9UjxQ99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9UjxQ99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D8D1F000E9;
	Thu, 30 Jul 2026 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424709;
	bh=QU7KTuaufq2AID9Yv4ke6vmvO7GHXuQoFUp1YVYXcFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9UjxQ99F53lobNJSxMCLM1lTLyMIevj241EHzsDIua12r9LV5iPc21W9kknpK9mM
	 iAxVTRDokxy4alTWniDgc35ApIthbjAIDK0wXQtsaMw2FhyMNF+bK9FYFROSkwmsQw
	 VerKa5tCEn/3yzvNpYGC5nZkYzAZOvpLq9Yweius=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.18 488/675] misc: nsm: only unlock nsm_dev on post-lock error paths
Date: Thu, 30 Jul 2026 16:13:38 +0200
Message-ID: <20260730141455.492476868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
 


