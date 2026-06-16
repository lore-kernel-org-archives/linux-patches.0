Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9CB3AA1BA;
	Tue, 16 Jun 2026 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622028; cv=none; b=qGcsnY76SRrtn0nHFvFFvObJwPO+x7Jp5YKo2T9pyhul2nbycY0mFrX45Pvggh2OGlqYL42wXbHaoDPfAlJyL/xyU4hRNIkq8fZAtsBFtk3WdUOAfoZrVa/oi+KA4j1Olhs81hW4AAa2Bq7zFhLJA23I81Q/jjvY0IY5JoslMU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622028; c=relaxed/simple;
	bh=PJtvLXB8h4VZGYbO18T/siL7b1Q5/kaMU9afAX8T16g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3PUObs0CSyQa3R3RYClPS1hvAFSIYXVDXUh4reR+eJTsMJtvA+snPoC2eVjLkYKgsHDHyeODV8dv+grcus25fag6Y1XKSpnwufar6zz3bXHkj2BmTSh085vx/rumpp5+Zy5k9FmSorzPtEksXgsARIEna/Ef0y/nQ+44KdJSE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7BHDQEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7BHDQEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B821F000E9;
	Tue, 16 Jun 2026 15:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622027;
	bh=61YOxhKS66IAEnL9mPAQzSgRbA/43qZnkDMaklQatPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7BHDQEFW1hu9plmEi4ugj7POw69nRp0k8TnksFn3ajvBr2v9dESbh78nu36I0Mwb
	 TN493k6xwNO6A9+X5qplH3MPRNGc9EfL3WEfOCELf/4vqmR7/5g2Q2UuCakg0yBeTG
	 DNfQf+GEOEONk906JLZ3e64NbSJexQfFTReEshVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.1 3/8] driver core: reject devices with unregistered buses
Date: Tue, 16 Jun 2026 20:28:48 +0530
Message-ID: <20260616145523.437476927@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
References: <20260616145523.335696673@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 36f35b8df6972167102a1c3d4361e0afb6a84534 upstream.

Trying to register a device on a bus which has not yet been registered
used to trigger a NULL-pointer dereference, but since the const bus
structure rework registration instead succeeds without the device being
added to the bus.

This specifically means that the device will never bind to a driver and
that the bus sysfs attributes are not created (i.e. as if the device had
no bus).

Reject devices with unregistered buses to catch any callers that get
the ordering wrong and to handle bus registration failures more
gracefully.

Fixes: 5221b82d46f2 ("driver core: bus: bus_add/probe/remove_device() cleanups")
Cc: stable@vger.kernel.org	# 6.3
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260430091718.230228-1-johan@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -544,10 +544,10 @@ static const struct attribute_group driv
  */
 int bus_add_device(struct device *dev)
 {
-	struct subsys_private *sp = bus_to_subsys(dev->bus);
+	struct subsys_private *sp;
 	int error;
 
-	if (!sp) {
+	if (!dev->bus) {
 		/*
 		 * This is a normal operation for many devices that do not
 		 * have a bus assigned to them, just say that all went
@@ -556,6 +556,13 @@ int bus_add_device(struct device *dev)
 		return 0;
 	}
 
+	sp = bus_to_subsys(dev->bus);
+	if (!sp) {
+		pr_err("%s: cannot add device '%s' to unregistered bus '%s'\n",
+		       __func__, dev_name(dev), dev->bus->name);
+		return -EINVAL;
+	}
+
 	/*
 	 * Reference in sp is now incremented and will be dropped when
 	 * the device is removed from the bus


