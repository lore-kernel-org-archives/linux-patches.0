Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602EB1C2432;
	Wed, 19 Feb 2025 09:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955610; cv=none; b=d6GT4R48nf7nAftkoYH/5u7A9CDbTM/RsGgfMFquGNccuKn/2mNVdyCVPWTvPKLQS56/km1Olkegb/6r00Zm4dw1JTHr+UTZPetDNSdPgNehdObyUtCEOU0G93g0PMb2IFkU5IDrSRG68yp8wndYA23gj/uwEvorFN0iomEwR88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955610; c=relaxed/simple;
	bh=3AB7F6tm0HRiXaQZUTlAEPjtW+PUbp8nHiaK9KOkceA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmH5CeWlZ/LcEJnEPVcIHm3PcpBJRbiIAKBR6+Vy3wXXeYu8xNjLfzQ6ZhYbvbOS0uvF8LVwpDcYZpXuPqEZ0gKVGWZ8NbzxWe6L8MfXTfZiSMU/uQI2bwJ6Cea0HRUsPet2NngUBT2TcgtgzAxen37t/DBkldjlHrKofW0UOl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqwKUuCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqwKUuCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A54C4CEE6;
	Wed, 19 Feb 2025 09:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955610;
	bh=3AB7F6tm0HRiXaQZUTlAEPjtW+PUbp8nHiaK9KOkceA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqwKUuCE/Z1NWn0raOSeZsrxyy1rI7XaMHG6ut2Mp1Op5OLQWfKDtLUbvOD/GroCn
	 gMOQIgp+78P1ggdHnJF/4hmh6eE1TyL8RmtlwsfA6BIHPs1ykLjfiZS8Z5mrsXFRzn
	 8qhJox7jsThmJdjJdCa3DjHIwJfXroNPsgBD9xuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 058/152] usb: roles: set switch registered flag early on
Date: Wed, 19 Feb 2025 09:27:51 +0100
Message-ID: <20250219082552.341942080@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elson Roy Serrao <quic_eserrao@quicinc.com>

commit 634775a752a86784511018a108f3b530cc3399a7 upstream.

The role switch registration and set_role() can happen in parallel as they
are invoked independent of each other. There is a possibility that a driver
might spend significant amount of time in usb_role_switch_register() API
due to the presence of time intensive operations like component_add()
which operate under common mutex. This leads to a time window after
allocating the switch and before setting the registered flag where the set
role notifications are dropped. Below timeline summarizes this behavior

Thread1				|	Thread2
usb_role_switch_register()	|
	|			|
	---> allocate switch	|
	|			|
	---> component_add()	|	usb_role_switch_set_role()
	|			|	|
	|			|	--> Drop role notifications
	|			|	    since sw->registered
	|			|	    flag is not set.
	|			|
	--->Set registered flag.|

To avoid this, set the registered flag early on in the switch register
API.

Fixes: b787a3e78175 ("usb: roles: don't get/set_role() when usb_role_switch is unregistered")
Cc: stable <stable@kernel.org>
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250206193950.22421-1-quic_eserrao@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -355,14 +355,15 @@ usb_role_switch_register(struct device *
 	dev_set_name(&sw->dev, "%s-role-switch",
 		     desc->name ? desc->name : dev_name(parent));
 
+	sw->registered = true;
+
 	ret = device_register(&sw->dev);
 	if (ret) {
+		sw->registered = false;
 		put_device(&sw->dev);
 		return ERR_PTR(ret);
 	}
 
-	sw->registered = true;
-
 	/* TODO: Symlinks for the host port and the device controller. */
 
 	return sw;


