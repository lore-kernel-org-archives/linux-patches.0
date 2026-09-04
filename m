Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359F33ECBCF;
	Fri,  4 Sep 2026 05:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500150; cv=none; b=m9n+ANaXieiW3t2Z3aQglk518du8BSISIAjalwME1NSUpH6/+5axdF2KFCqn3Do4OW76nVgLQIfJzEgYkaGmTeRCqNSYGSnJfXbEuPg+7wlj98xmmBErgmK1ORLk2jTGsc95Jbu/USO+AV42Ef/rwKXnx2mzsCWZUdJJ/nBEp3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500150; c=relaxed/simple;
	bh=mPH+gaa+H3HerRXvJBDGvKd+MHuLfr10ul5/W+aRW5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhh5Atr1jv4oXhipZLdm8R/PZyOJI+SHcP9n10ftHnh5zHIvHLAVzGPIm5tg3O+H4+FGTW4w7ZX1rcRzg0yqrgydMxzNEJA1UJhyTpuC73AKWnTqglmVz+fk+NrDFvQTTXBbrzKw4x19q009NcuHImdfQdi4ZMxvqrmyUmPdR6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtnYCe/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtnYCe/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAC61F00A3D;
	Fri,  4 Sep 2026 05:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500149;
	bh=o32uA/dKPRLsUi6YM3M0fmvTNnD0IAcKkk9ttF8q1yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtnYCe/QqF6kEWiAQoFEYU1lexYrklZsJvJJ2Jj6utPZcnd2doCfL9k1atvNkAwHI
	 7pf9HbEhFzUbvHVbKKOvUlVQCnth9l2Gdp1rqPjHT+5ILnvRrmpLtk++yzni5W6bLi
	 BnyKO6X+wYU8T6ROXdshHpNamMk8vgJAZCcj2efA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 667/713] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Fri,  4 Sep 2026 07:00:35 +0200
Message-ID: <20260904045818.786263585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit e5e8dd2e959f470524c16ca444d001c90d6bb3ad upstream.

i3c_device_uevent() dereferences i3cdev->desc without holding the bus
normal-use lock.  Since the descriptor pointer can be replaced
concurrently, including when a uevent is generated from sysfs, this can
result in dereferencing a stale descriptor and lead to a use-after-free.

Use i3c_device_get_info() instead, which protects access to the
descriptor with the normal-use lock.

Commit 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling
i3c_device_get_info() to avoid deadlock") replaced the accessor with a
direct descriptor dereference because i3c_device_get_info() would
recursively acquire bus->lock during device registration.

This change depends on "i3c: master: Fix recursive locking during device
registration", which moves device registration out from under bus->lock
and removes the possibility of that deadlock.  Without that change,
restoring the i3c_device_get_info() call would reintroduce the deadlock.

Fixes: 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock")
Cc: stable@vger.kernel.org # requires "i3c: master: Fix recursive locking during device registration"
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -311,8 +311,7 @@ static int i3c_device_uevent(const struc
 	struct i3c_device_info devinfo;
 	u16 manuf, part, ext;
 
-	if (i3cdev->desc)
-		devinfo = i3cdev->desc->info;
+	i3c_device_get_info(i3cdev, &devinfo);
 	manuf = I3C_PID_MANUF_ID(devinfo.pid);
 	part = I3C_PID_PART_ID(devinfo.pid);
 	ext = I3C_PID_EXTRA_INFO(devinfo.pid);


