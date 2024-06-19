Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E3013F435;
	Wed, 19 Jun 2024 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802907; cv=none; b=AyuYxEkSPusiNArMlh/HN9jIkWoaDq2P39RPYF3ReL+zLSd53zwVwAomdodq5bo6pRA5QHAtYPmO/1yhF2Nei7dnFxg13TYAMmXYEZtaFkH2cYXsB56Nc+bMlXhI0ppewUYl0yySUpGkHZWTWwLQCoXn0dLS5PvTO88xsD8/a+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802907; c=relaxed/simple;
	bh=X6wn1IRXE7ZaqFu2FkvA72i5T9XKKitg1gOyAXy0PDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srzh4trPloKalSRyoVdNZM79BnhOibLBXVHiWdbQEoZPDqyNPR0QbTExsmI+EIbDGL6j+ei1ceS4d8dyufCEzE0jketQs+Wy5theKQ4CiR3ixmg2SX+1n3zxnsxI0A1HTpjAfEGJJgC0TVMaeIsjnwo2+kkfpgQPNrq1WsnjLf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OC/9Q6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OC/9Q6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CA9C2BBFC;
	Wed, 19 Jun 2024 13:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802907;
	bh=X6wn1IRXE7ZaqFu2FkvA72i5T9XKKitg1gOyAXy0PDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OC/9Q6rq3SM7p/aZbrwjPLtBVxIIlRAQWICAhvg0imNeZehc67oOqTUERTiHEYEl
	 46UqRGGAo1u3t65WrOfWPVLymaRURI3TZHDqFhXfzZNwKPH3M/3bCMzxNshRXQhEVr
	 qJMJP+yBhjMIOi9qw5L38U/LF6qlLNXBgc/p0NOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Wentong Wu <wentong.wu@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.9 088/281] mei: vsc: Dont stop/restart mei device during system suspend/resume
Date: Wed, 19 Jun 2024 14:54:07 +0200
Message-ID: <20240619125613.236508983@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentong Wu <wentong.wu@intel.com>

commit 9b5e045029d8bded4c6979874ed3abc347c1415c upstream.

The dynamically created mei client device (mei csi) is used as one V4L2
sub device of the whole video pipeline, and the V4L2 connection graph is
built by software node. The mei_stop() and mei_restart() will delete the
old mei csi client device and create a new mei client device, which will
cause the software node information saved in old mei csi device lost and
the whole video pipeline will be broken.

Removing mei_stop()/mei_restart() during system suspend/resume can fix
the issue above and won't impact hardware actual power saving logic.

Fixes: f6085a96c973 ("mei: vsc: Unregister interrupt handler for system suspend")
Cc: stable@vger.kernel.org # for 6.8+
Reported-by: Hao Yao <hao.yao@intel.com>
Signed-off-by: Wentong Wu <wentong.wu@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Jason Chen <jason.z.chen@intel.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240527123835.522384-1-wentong.wu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/platform-vsc.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -399,41 +399,32 @@ static void mei_vsc_remove(struct platfo
 
 static int mei_vsc_suspend(struct device *dev)
 {
-	struct mei_device *mei_dev = dev_get_drvdata(dev);
-	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
+	struct mei_device *mei_dev;
+	int ret = 0;
 
-	mei_stop(mei_dev);
+	mei_dev = dev_get_drvdata(dev);
+	if (!mei_dev)
+		return -ENODEV;
 
-	mei_disable_interrupts(mei_dev);
+	mutex_lock(&mei_dev->device_lock);
 
-	vsc_tp_free_irq(hw->tp);
+	if (!mei_write_is_idle(mei_dev))
+		ret = -EAGAIN;
 
-	return 0;
+	mutex_unlock(&mei_dev->device_lock);
+
+	return ret;
 }
 
 static int mei_vsc_resume(struct device *dev)
 {
-	struct mei_device *mei_dev = dev_get_drvdata(dev);
-	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
-	int ret;
-
-	ret = vsc_tp_request_irq(hw->tp);
-	if (ret)
-		return ret;
-
-	ret = mei_restart(mei_dev);
-	if (ret)
-		goto err_free;
+	struct mei_device *mei_dev;
 
-	/* start timer if stopped in suspend */
-	schedule_delayed_work(&mei_dev->timer_work, HZ);
+	mei_dev = dev_get_drvdata(dev);
+	if (!mei_dev)
+		return -ENODEV;
 
 	return 0;
-
-err_free:
-	vsc_tp_free_irq(hw->tp);
-
-	return ret;
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(mei_vsc_pm_ops, mei_vsc_suspend, mei_vsc_resume);


