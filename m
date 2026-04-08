Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4673D9045;
	Wed,  8 Apr 2026 18:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674053; cv=none; b=UyfNP11hDqTM6ROy2CriQewIyFnFIG397rELzCbaCwXYN/0m1C41yMH0c2VgKV5kGrQOkUF6vFWKyEVOeJ0N9XRf/K6P2o6yScm9sYo3B/4eI3UYkLM4Jhzpz7zGaqn620oNJ3d860F3StU5Caf/aT2HsSzgUqjRcZpLGC17Ahw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674053; c=relaxed/simple;
	bh=93dpg5cp61tdsQr6kmyR7HTvIe0H/OGTUixFpt0Nfik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXakIBvXCSqZvDYorSeXwLNuZPjMWfOHykUX1hXPwsk9TraJt2+dbPxm7S8A8a0vKVEnnIQp9ft/zXlHMHz7+s2CiFygUjoQ2dHOWKUp9E0fZhWj0EEBVssxiMHWyFFWf5lngU82Zr4R8GIHgct76NGjIml4tNBeNzNQHkGaz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjVhHNVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjVhHNVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD35C2BC9E;
	Wed,  8 Apr 2026 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674053;
	bh=93dpg5cp61tdsQr6kmyR7HTvIe0H/OGTUixFpt0Nfik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjVhHNVNX/LF7BkZGTlbkr/1rtSiy9BfT/25J0lyMfNGAP0wbnnWCXXwgT9eOFcB6
	 /V2XLEbRFFlSicmfue8et4OBXfI1zlBKqiL69Uc3p1bAr0kLRb2lkYav8wRC8q3tH1
	 b4Ie1ppf4k1mc+Yo0CUFGM5z0xX+ocNUelu6nyEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.12 191/242] thermal: core: Fix thermal zone device registration error path
Date: Wed,  8 Apr 2026 20:03:51 +0200
Message-ID: <20260408175934.233619372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
@@ -1543,6 +1543,7 @@ unregister:
 	device_del(&tz->device);
 release_device:
 	put_device(&tz->device);
+	wait_for_completion(&tz->removal);
 remove_id:
 	ida_free(&thermal_tz_ida, id);
 free_tzp:


