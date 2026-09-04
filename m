Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00AB242910;
	Fri,  4 Sep 2026 06:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501671; cv=none; b=NvteZnmZM7BpyIS9pgpjJKq/xWQgkYil6AvYEJ2mfjCeokxqqjALqTWaqoxHxyH7u7wdbMUdNP1r5rYFWqCBUESgrwAbxvyU79xn0JhhZDj+mg7E0q81+P64MZiULm4EuoejFnyq24iOb2dHYC0IdeXbNaVidEO4jqwV9NRt5mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501671; c=relaxed/simple;
	bh=gev1Lfs+GSY5wTvK14gFZUWoSjQQIYUbJcm44dkmZTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN3ZSugFtSAdEYKdXRE0STkAvTjTt7yYs3ZNFA4KL1mBTCEx4BqoCSSFoUGD67o6LhVsERwDih/iVCCybMTESSmkCEgkKV6lKTcAC/EkgjIGI9IrWr5RZGuskrYvCeBOjAix4QL552uRgfdoyqBXGXKkxJ9FmL9WYOc5E8gPFM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgIM4ZAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgIM4ZAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CEF1F00A3D;
	Fri,  4 Sep 2026 06:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501669;
	bh=iMmBOU60APhcM4rvjp3nw/p333FcqcNtd8MugqOYyJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgIM4ZATY4IlUJHdrl4Ez2ZPF1b8P68Kj2UiV7IGdw9eEcCeLLfVZNhuopapbVDn6
	 QvvO+bjQ8BTpHMbQ+hrGboAxVdPfdD1myyj+NMYTKYzPJBK9COoPvGMkSH8TDIYkPL
	 CL2xxVJlsQpBp8QvzHwr8E6zkG8Ghx9sNRkw6WJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 448/552] ipmi: si: Fix NULL pointer dereference after failed registration
Date: Fri,  4 Sep 2026 07:00:05 +0200
Message-ID: <20260904045800.861466861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Nishikawa <snishika@redhat.com>

commit 6d920a75df9a83ab096b3cde7a643b656e4fdfeb upstream.

try_smi_init() allocates new_smi->si_sm and later calls
ipmi_register_smi_mod(), which maps to ipmi_add_smi().

During ipmi_add_smi(), the upper IPMI message handler obtains the
initial BMC device information through __bmc_get_device_id(). This can
fail if the BMC does not return a successful response to the Get Device
ID command.

When the BMC returns a nonzero completion code, the device-id helper
retries the command and eventually returns -EIO if the device ID still
cannot be fetched.

On this failure path, ipmi_add_smi() logs "Unable to get the device id"
and goes to out_err_started, where it invokes the lower driver's
shutdown callback. try_smi_init() then logs the returned registration
failure:

 ipmi_si IPI0001:00: IPMI message handler: Unable to get the device id: -5
 ipmi_si IPI0001:00: Unable to register device: error -5

For ipmi_si, the shutdown callback is shutdown_smi(), which cleans up
the SI state machine data, frees smi_info->si_sm, and sets
smi_info->si_sm and smi_info->intf to NULL.

However, intf->in_shutdown is not set on this failed-registration
rollback path. Therefore, the asynchronous redo_bmc_reg work item can
still retry BMC device-id probing after the lower driver has already
cleared its SI state machine data. In the observed case, that retry path
reached start_next_msg(), which passed the NULL smi_info->si_sm pointer
to the selected KCS state machine handler:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Workqueue: events redo_bmc_reg [ipmi_msghandler]
RIP: start_kcs_transaction+0x2c/0x190 [ipmi_si]
Call Trace:
 start_next_msg+0x50/0x80 [ipmi_si]
 check_start_timer_thread.part.9+0x3b/0x50 [ipmi_si]
 sender+0x69/0x80 [ipmi_si]
 i_ipmi_request+0x2ac/0x9d0 [ipmi_msghandler]
 __get_device_id.isra.29+0xaa/0x180 [ipmi_msghandler]
 __bmc_get_device_id+0xef/0x950 [ipmi_msghandler]
 redo_bmc_reg+0x52/0x60 [ipmi_msghandler]
 process_one_work+0x1a7/0x360

Set intf->in_shutdown on the out_err_started path before invoking the
lower driver's shutdown callback. This prevents later redo_bmc_reg
retries from using an interface whose lower driver state has been
cleaned up, and applies the same shutdown state to other IPMI interfaces
as well.

Fixes: 2512e40e48d2 ("ipmi: Rework SMI registration failure")
Cc: stable@vger.kernel.org
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Message-ID: <20260630174348.1483814-1-snishika@redhat.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3759,6 +3759,7 @@ int ipmi_add_smi(struct module         *
  out_err_bmc_reg:
 	ipmi_bmc_unregister(intf);
  out_err_started:
+	intf->in_shutdown = true;
 	if (intf->handlers->shutdown)
 		intf->handlers->shutdown(intf->send_info);
  out_err:


