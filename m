Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214171D79BE;
	Wed, 19 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954207; cv=none; b=lJQH2WmQu8BR7wxHSm9/N7r9qOlpnBbQrm4vuB06DqzJdO2yYon3/NoVQlar3W709pIXsgq651AVQHYttCWu5Ut6XXhl5lqW1NN1pfi6G5O0nvqzV0B95GGYK2QjWa2o53HOgtf4hIFB3BToPk+GlUMcSQt7HsZW9kTT0/xU1lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954207; c=relaxed/simple;
	bh=euEzCSGv0ToNTZMliFVsxT+v86X8ughUtMEI9AUjU/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcgifkF6z8crYUsXiGv9lH2soNDi7mYe9+2cueSTPo/QQsCZDfJ/YmiG1mUavSil5xATUizgwnqOEVOCcaoGsvpTXaoH4kcygDOb3EgaLVJLlioQZOEp+f5LnM3x+EJpZFQv7fNnO8Hn/+K8dKJOpOPcC75QKGA2L3xZizJuGNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=petNO9jA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="petNO9jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E7C4CEE7;
	Wed, 19 Feb 2025 08:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954206;
	bh=euEzCSGv0ToNTZMliFVsxT+v86X8ughUtMEI9AUjU/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=petNO9jAadueLozKZxYk2Nmt46hZjmvKbsZ/1dfo/lsmc/Jj2CADnIpYbQvJtFe6G
	 ft5TNQctNfLppVrj+wPFRXfkcRGlIrgXb9vH+pOEBGgBIuUnC6KbLCHjfAL/OUwAhz
	 HPCTiUxmpT87dT9c/w27TcAglf78GT5HiXw0ynnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.13 130/274] usb: roles: set switch registered flag early on
Date: Wed, 19 Feb 2025 09:26:24 +0100
Message-ID: <20250219082614.698394438@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,8 +387,11 @@ usb_role_switch_register(struct device *
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
@@ -399,8 +402,6 @@ usb_role_switch_register(struct device *
 			dev_warn(&sw->dev, "failed to add component\n");
 	}
 
-	sw->registered = true;
-
 	/* TODO: Symlinks for the host port and the device controller. */
 
 	return sw;


