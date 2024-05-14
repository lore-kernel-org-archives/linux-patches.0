Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071CC12AAC6;
	Tue, 14 May 2024 11:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686622; cv=none; b=QW2MaB4vy04+TwOwzF0swzMRQxoFh8v1sZat2RxqUpirEb9f6qteGKjj879mncKi5O367F1HqfctTpKEyMtVeryrBpiaDiRfw2MOb2AUaSKsfxrP/FbC6WeQkAs6lbT/thlOe3cJsWFyBM2qK2uu4YIqXX+nLiHvxUuw0l5SUJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686622; c=relaxed/simple;
	bh=DXsKGd6gOe3SgDYdjhcaliY4Ai7uuqKL3a+uZM68mKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0dYLaYdNGqJs+4h3ukCSUk9d9UIOEHgG9LfvcSdZAibIF9GJnN+Ezo4H653D8m6W7R0X2OsSiBOs97gZCLoKc2rW/x2OptXZEGDT4wu83gng0gQXo0f1l505/OL0JoTq/8fbGMztRS2AcsjJfIHLGkpF87k83HFAm8a2VpAefg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qb3s9A1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qb3s9A1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FEFC2BD10;
	Tue, 14 May 2024 11:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686621;
	bh=DXsKGd6gOe3SgDYdjhcaliY4Ai7uuqKL3a+uZM68mKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qb3s9A1jtySZOno5ylqwe10JtAKuaoG7DHOoT0TNujX0Sc8wgVtSbRNupc4qAyr53
	 1eDVfhMgCPZFEumeXIvapp+4WNo6SOduZniRyRjjdKNEUtfY9ACa2AuAGd8x76WUYm
	 e9EfCBj0CRq0aGzjm8CcKNudEB5momMXcaHnoCGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 201/236] usb: typec: tcpm: unregister existing source caps before re-registration
Date: Tue, 14 May 2024 12:19:23 +0200
Message-ID: <20240514101027.995680714@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit 230ecdf71a644c9c73e0e6735b33173074ae3f94 upstream.

Check and unregister existing source caps in tcpm_register_source_caps
function before registering new ones. This change fixes following
warning when port partner resends source caps after negotiating PD contract
for the purpose of re-negotiation.

[  343.135030][  T151] sysfs: cannot create duplicate filename '/devices/virtual/usb_power_delivery/pd1/source-capabilities'
[  343.135071][  T151] Call trace:
[  343.135076][  T151]  dump_backtrace+0xe8/0x108
[  343.135099][  T151]  show_stack+0x18/0x24
[  343.135106][  T151]  dump_stack_lvl+0x50/0x6c
[  343.135119][  T151]  dump_stack+0x18/0x24
[  343.135126][  T151]  sysfs_create_dir_ns+0xe0/0x140
[  343.135137][  T151]  kobject_add_internal+0x228/0x424
[  343.135146][  T151]  kobject_add+0x94/0x10c
[  343.135152][  T151]  device_add+0x1b0/0x4c0
[  343.135187][  T151]  device_register+0x20/0x34
[  343.135195][  T151]  usb_power_delivery_register_capabilities+0x90/0x20c
[  343.135209][  T151]  tcpm_pd_rx_handler+0x9f0/0x15b8
[  343.135216][  T151]  kthread_worker_fn+0x11c/0x260
[  343.135227][  T151]  kthread+0x114/0x1bc
[  343.135235][  T151]  ret_from_fork+0x10/0x20
[  343.135265][  T151] kobject: kobject_add_internal failed for source-capabilities with -EEXIST, don't try to register things with the same name in the same directory.

Fixes: 8203d26905ee ("usb: typec: tcpm: Register USB Power Delivery Capabilities")
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240424223227.1807844-1-amitsd@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2416,7 +2416,7 @@ static int tcpm_register_sink_caps(struc
 {
 	struct usb_power_delivery_desc desc = { port->negotiated_rev };
 	struct usb_power_delivery_capabilities_desc caps = { };
-	struct usb_power_delivery_capabilities *cap;
+	struct usb_power_delivery_capabilities *cap = port->partner_source_caps;
 
 	if (!port->partner_pd)
 		port->partner_pd = usb_power_delivery_register(NULL, &desc);
@@ -2426,6 +2426,9 @@ static int tcpm_register_sink_caps(struc
 	memcpy(caps.pdo, port->sink_caps, sizeof(u32) * port->nr_sink_caps);
 	caps.role = TYPEC_SINK;
 
+	if (cap)
+		usb_power_delivery_unregister_capabilities(cap);
+
 	cap = usb_power_delivery_register_capabilities(port->partner_pd, &caps);
 	if (IS_ERR(cap))
 		return PTR_ERR(cap);


