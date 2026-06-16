Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C4A4508E9;
	Tue, 16 Jun 2026 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624581; cv=none; b=T0Mc0o3acj5PqDMCee891JrAWEr6ePH+StoUrSGpUlaXTZkZTjCzGMMJbjthAKgKRLcM2HfSFqWDWu1DSjkHMXFom+GUwqYmzDPS7KfFF24McONCQyZ9WhO/DcoSNiRX8+X41HyyzRymsGxMcQL2uSUIzRTmhxd4RDZGc24IFdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624581; c=relaxed/simple;
	bh=Zda4/a1XI6RIWubodTfJPzCgmybhRtPW0Oriu98dnIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM0GdOdy3tWjz+3j370zJgC2fV1iSq0dKbPp0Jz4fVqSTxAFRMToP74u+m0NhCkjdcoTt+HIUjoSPBTKVieytlWy8qm6u6wZxrUFSYK7+eOxy0ueXOxn2run7EfmBOmPRpWLN3cUfASDc20f5OmeN3XRtUIvbB2/Pq2QEf8XaTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZJzq40i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZJzq40i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142971F000E9;
	Tue, 16 Jun 2026 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624579;
	bh=ijRcGm6Xde9vXhlwCX9W0s6ZTOMI++aUECPrfZ6sWTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZJzq40iJMTUmIXI0mVa9DfUFaB5BhdNmJ3+sVYPWwHxkGkdwJweD/P9pshF/5hGu
	 XGwGvD42hMHL5+e+Yb0DFhG2I+YdTbmCRcQJCaXHSfqzdYHx9UB5Tk5oJvE3JV8oGf
	 J3vXwFhcVFxD/b/lLqENQTmM5Z4sORCJmL21621I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.0 361/378] driver core: reject devices with unregistered buses
Date: Tue, 16 Jun 2026 20:29:52 +0530
Message-ID: <20260616145129.146341628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


