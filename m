Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7182C32692B;
	Wed,  8 Apr 2026 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775675005; cv=none; b=cF8DbDOQAzZ6J0q6oqtGnCSWle0iwBwLNjdAfyBHszrmP7ujeAzZWbzGWkXErPJ+DWN4pw8GV4YezfcIzZUFl/BIp6BMZFHxMqVTHziQY2KeKW/gd1tM5G+3VINz4t4s1x2FZCIpcOgYs4sf/0VbtKbViI15/yK5tZVone6vNCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775675005; c=relaxed/simple;
	bh=7dXrzjnvFCSl62/TPtljVr98AienSRBE8BrDA0LEgYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BphXNUJQx30TlvZ7myrDOG31+4q0qCtl9UOZmjtr6NwUbEtluet1xGMepWWp/Y47WZPoXDNqhF/PxfOzTkO7n6lKXv2u3LT00tCMfee6riC/AJMQd/EtA3l/XrJfkkS8xpvYRK8UMFgOqrn3dK77hqyPBHCF1UHoBZdqoIYOXBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZATnmIkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZATnmIkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0756FC19421;
	Wed,  8 Apr 2026 19:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775675005;
	bh=7dXrzjnvFCSl62/TPtljVr98AienSRBE8BrDA0LEgYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZATnmIknLZ1TdlM9ICAWJtVO229kPfAeeyAY/fnJH00EMLfMCpqBhMPHXfQBpfO80
	 Y96FelZ141xXTLipl+IgkTQ86razpmo8wdow9WOF7hoYS6vURZcYj6/8ZKBD3kMDdT
	 UXJROpsyWZQMccBt//VrDRQZaMrbIblscFkFBZ3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.19 286/311] thermal: core: Fix thermal zone device registration error path
Date: Wed,  8 Apr 2026 20:04:46 +0200
Message-ID: <20260408175950.060376296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 9e07e3b81807edd356e1f794cffa00a428eff443 upstream.

If thermal_zone_device_register_with_trips() fails after registering
a thermal zone device, it needs to wait for the tz->removal completion
like thermal_zone_device_unregister(), in case user space has managed
to take a reference to the thermal zone device's kobject, in which case
thermal_release() may not be called by the error path itself and tz may
be freed prematurely.

Add the missing wait_for_completion() call to the thermal zone device
registration error path.

Fixes: 04e6ccfc93c5 ("thermal: core: Fix NULL pointer dereference in zone registration error path")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/2849815.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1638,6 +1638,7 @@ unregister:
 	device_del(&tz->device);
 release_device:
 	put_device(&tz->device);
+	wait_for_completion(&tz->removal);
 remove_id:
 	ida_free(&thermal_tz_ida, id);
 free_tzp:


