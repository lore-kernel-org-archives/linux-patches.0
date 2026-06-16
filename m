Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4074779AA;
	Tue, 16 Jun 2026 16:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627803; cv=none; b=V1nOE5uHja45EyFQqUCiQva36MT3RC9N235tlAr/wpBa3bpIy5qAV9SFLodjgplJdG/7wtYAP2OzCCoptWYuzfvUdCJ2diuEB0nhIIvadqAyC4j+jSV093X4V2H3zDcy2Lkn3+mMSzSUNqkmWkiTrmSY/uzEVyFxIOQjvC+jj7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627803; c=relaxed/simple;
	bh=IaFXzbZRNB0/TJwX/4JENdk7kIJ43V88Q8RO4jXGSI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTQDmrR9YrLaEGVgguTpaGC7QdSTe6PnfGqR8NOUu4hJXSk/+KP1nG+yxL65H1viHmHZIwjpvTmm+7MjjtfRKUGEsD0tccbECce4bCnx2Utc3FM02yBplRnT04D6Zj1aF7KljbhKxsz4bFxE1ZYS59JVUicNBE5nx5ofdyO9t2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFFVx1qy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFFVx1qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF321F00A3A;
	Tue, 16 Jun 2026 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627802;
	bh=lA9O+n/ZqgFCvbOek+8J6tQ6ZE0AchJOfz7zbFY4uOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFFVx1qyFtDgv5Pn9ce+/buGyYFjo8RtkiZVWsJ/P7Wr2vzAcD5dsPni94pufJwVb
	 ++5lkHZ6keiF8Bsav9Fpr37qir6jivS5XnJYRbpBtCs1sydmYmZhto0Jf9i4nkCQEW
	 H6Or77D1bIz5Q9RCEgMJSWnQgmAdKIkNu0yTaStA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 230/261] driver core: reject devices with unregistered buses
Date: Tue, 16 Jun 2026 20:31:08 +0530
Message-ID: <20260616145055.695465124@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -503,10 +503,10 @@ static const struct attribute_group driv
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
@@ -515,6 +515,13 @@ int bus_add_device(struct device *dev)
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


