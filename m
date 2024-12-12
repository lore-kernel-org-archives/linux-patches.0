Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852B2211493;
	Thu, 12 Dec 2024 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025701; cv=none; b=Ld5gQzMAT3QIWObjfAb+d1cyEVmOcSuInVYfdtjBiSHZVG+BSGveoBy6ECpDrjBocX8vzh3bqqZLvqtEIxxS/J4E7zWTYpdmSW/y5FVFQvJa6KF8U2+r9tvDkm6ND1cB33yHeSXXQSs12mlFXsXxTWApooWNeQ6LRFL3/qskimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025701; c=relaxed/simple;
	bh=i/byawCNdmauWhmDsX1mHkry4+ayDyOfTFQcaFhPte0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2kGWiLkps1thjSxS3QKutCwnlivzyOcYYoUosJsGn1RtBPckdu0mu59D+FG1c0FjZQweYlSnNWCPwCh1HpyEEZZwIlSBk7RIV1r7kPL4oRK5/dQW+hKzN1S90Rm1RPhQcABl2jaStEW1Lve7gdFQAN+eOqkGzxnqqf0aq7sK94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT4+keuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT4+keuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1454C4CEDD;
	Thu, 12 Dec 2024 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025701;
	bh=i/byawCNdmauWhmDsX1mHkry4+ayDyOfTFQcaFhPte0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT4+keuJb/W6LoMZ0iMmziFiduGFEq3rpyDTXSmDds/IGtcS3AgVQG/0IiIGldwuA
	 8OO00QbSen6//dfKkpIR9fgYJb5KKLEhYqpmAzh2J2MI9Vn5QAqUjnTr89hNofSaqo
	 FFEzLAHUHquoQVgGo4dfavD7rdgHUx4CMyfBVim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 241/321] xen: Fix the issue of resource not being properly released in xenbus_dev_probe()
Date: Thu, 12 Dec 2024 16:02:39 +0100
Message-ID: <20241212144239.495970292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

[ Upstream commit afc545da381ba0c651b2658966ac737032676f01 ]

This patch fixes an issue in the function xenbus_dev_probe(). In the
xenbus_dev_probe() function, within the if (err) branch at line 313, the
program incorrectly returns err directly without releasing the resources
allocated by err = drv->probe(dev, id). As the return value is non-zero,
the upper layers assume the processing logic has failed. However, the probe
operation was performed earlier without a corresponding remove operation.
Since the probe actually allocates resources, failing to perform the remove
operation could lead to problems.

To fix this issue, we followed the resource release logic of the
xenbus_dev_remove() function by adding a new block fail_remove before the
fail_put block. After entering the branch if (err) at line 313, the
function will use a goto statement to jump to the fail_remove block,
ensuring that the previously acquired resources are correctly released,
thus preventing the reference count leak.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and detecting potential issues where resources are not properly managed.
In this case, the tool flagged the missing release operation as a
potential problem, which led to the development of this patch.

Fixes: 4bac07c993d0 ("xen: add the Xenbus sysfs and virtual device hotplug driver")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241105130919.4621-1-chenqiuji666@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index b88512d92ef52..fd686b962727a 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -250,10 +250,16 @@ int xenbus_dev_probe(struct device *_dev)
 	if (err) {
 		dev_warn(&dev->dev, "watch_otherend on %s failed.\n",
 		       dev->nodename);
-		return err;
+		goto fail_remove;
 	}
 
 	return 0;
+fail_remove:
+	if (drv->remove) {
+		down(&dev->reclaim_sem);
+		drv->remove(dev);
+		up(&dev->reclaim_sem);
+	}
 fail_put:
 	module_put(drv->driver.owner);
 fail:
-- 
2.43.0



