Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9A04BD348;
	Wed, 30 Sep 2026 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783983; cv=none; b=YWijfuwVET3HU3kz3sWUL3pMqwHWN4Y76zygM5RBoJP7L+yONtZ2ZfSnr+TwQWPx/A9LCtaG3cCVr8E7atqHVg+qdPrmyiVIkwPdzX/bVNqucsnEcZnaB/1QrxJwWYYn3HV844KeTXLeNtrbEQgh+XtCor19zX5On/DWACbXmxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783983; c=relaxed/simple;
	bh=iAw12MLNdCBcW0phPyLTLjmUrF0PXZFSAJGLOKSH9Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlUsYAaurmxvC5WU96E8XGZAuZCiQGWr+xOoh+0HyI6HvnQx/Xk5GNM13ssXq55Q50rtd4zQJg8nP/DrWxFcWlu+lG2sjrAjEVFHh4ispDuBzfBdYKZYj8cNzx9U//qj+aWVk39J+3aS7BYz5+vz6+S1gIDqInRo6DRmu5kgAm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zooI+uKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zooI+uKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D79C1F00898;
	Wed, 30 Sep 2026 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783977;
	bh=WNOpiqzyxaz9DKbQG2yL1A/k4gjPmLRt8uPWXiWjDAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zooI+uKmDvhBeGNcmBi2LYPo2+JipA2+SgCFAYoXrUJSbvwqSHG7VZmsVHXYISwvo
	 snbUteE8bKIybTYowViWIWZT1pPIb5y1Lw9y3qHblL06pBpGFfWeEQ0FgO8XWmaZNQ
	 vE4aP02tYXUh5PRkRENz+DuRMpMJmI9VzCSOUzwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 587/595] s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()
Date: Wed, 30 Sep 2026 17:28:00 +0200
Message-ID: <20260930152400.359920807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit 5b76268dac968612f7283d59b539036de955b7d9 upstream.

The channel path registry entry associated with a CHPID may be removed
while the subchannel's PMCW still references that CHPID. In this case,
chpid_to_chp() can return NULL, leading to a NULL pointer dereference.

Add the missing NULL check before dereferencing the returned pointer.

Fixes: 199652309a4d ("s390/cio: add helper to query utility strings per given ccw device")
Cc: stable@vger.kernel.org
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device_ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -501,6 +501,8 @@ u8 *ccw_device_get_util_str(struct ccw_d
 	chp_id_init(&chpid);
 	chpid.id = sch->schib.pmcw.chpid[chp_idx];
 	chp = chpid_to_chp(chpid);
+	if (!chp)
+		return NULL;
 
 	util_str = kmalloc(sizeof(chp->desc_fmt3.util_str), GFP_KERNEL);
 	if (!util_str)


