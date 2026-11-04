Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827046;
	b=pgjDzOciZ2NpspBoHWeSIgo/bXDoSsiV2t+B7OQetiipFpKPWVGtECoiRSVrGigNQhsG
	 J6PhTSeMzIgMwFlc+D6gWoJwEA7hZyXqovoHaQa5s8Q4MqndxWrcfsaJJN41GT+hsQzT5
	 94ZjlwqLRWNhNp1KWr/9SEwwIRnI6Hc+106r1CrrAmw7SgK+GmZZwtpsmx/t8YphGK5NI
	 KE5kiPE94+SRfEJ8MhY3jaQdMFuCon+l1FkcN43Z6ZYNFG1bLiVikwFeRoa9G3EotWFIb
	 h3tW2VRRHdjy27bkM67ylwUZBX8k2REK1UIb0/G8QQb80L22YeqpgPBgu/uQusPO1wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vCIkvIsRT+W6/e2hLwoVzEFY+wYwNZ+mMSER1a5eWEw=;
	b=v6KC0zBAdTkMR0I9BLYMyZLYvjgAiiKvSm2kDQINfuXgh09jmNxlA/hplyl6qR6EZp/q
	 exVe9qoSiRLj6GokiUSvX3f+3I4P3K1p9usA4OFuDeek5BVfnfweybZQlQNTggFBX3MPe
	 CpINPPM2ukLLPd+sek+SHeLIaz5G9JeXHDVQrNarLK/H3CgC182P6xHW98NJPr9PUClOU
	 AXlGLYZBpTHIzvsw/HRknsjZvIUjgXgtIVhTGJ1W7FPpc9wd83mJ+Z5Dtwod68UvPLpZF
	 rUZjTVIPjdgWC4N530Ayi4ruYKkP4si/QpdAiW4VYibmu3gq//5Ht9p7FTwVAZPzOeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2j+Cfs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938F606AE06;
	Wed,  4 Nov 2026 21:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2j+Cfs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D4C1F000C1;
	Wed,  4 Nov 2026 21:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827046;
	bh=vCIkvIsRT+W6/e2hLwoVzEFY+wYwNZ+mMSER1a5eWEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2j+Cfs9xm05PXBzqdgY5O/Wpvw0k48mo/y4aF8bb7NpYgA9kXWm2zphkeo9ipv6Y
	 osux4MJRmwyinp8CGFNqv551mtvQT4tHDjObOG1qwPXRp7R+hqHyDfNLMYFHDGluWt
	 Q8YA3e1tnWDaZXV1NAbSAzdfduVsb0ExLOFg0zLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.3 162/547] media: ipu-bridge: Fix use-after-free in IVSC error path
Date: Wed,  4 Nov 2026 16:05:46 -0500
Message-ID: <20261104211042.757421263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yibo Tan <lhfff@tju.edu.cn>

commit 3d42d1c82717f0853379b516a7fab54b636e09cc upstream.

ipu_bridge_get_ivsc_acpi_dev() returns an ACPI device with a reference
held. If no matching CSI device is found, ipu_bridge_check_ivsc_dev()
drops that reference before passing the device to dev_err(). Concurrent
CSI device and ACPI namespace removal can drop the other references,
making this the final put. dev_err() then reads the freed struct
acpi_device and its kobject name.

This was reproduced without kprobes by racing normal CSI platform-device
unregistration and ACPI configfs table removal against the production
ipu_bridge_init() entry. KASAN reported the final free through
device_release(), followed by invalid reads through _dev_err().

Emit the error message while the lookup reference is still held, then
drop the reference as before.

Source reproducers and vulnerable/fixed serial logs, with only the build
hostname redacted, are available at:
https://github.com/kimaiden1984-boop/linux-ipu-bridge-acpi-uaf-reproducer

The fixed target builds with W=1 on x86-64. This was not tested on
physical IPU hardware. The tests establish runtime reachability but do
not measure occurrence frequency on shipping systems or establish
exploitability.

Fixes: c66821f381ae ("media: pci: intel: Add IVSC support for IPU bridge driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu-bridge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -326,8 +326,8 @@ static int ipu_bridge_check_ivsc_dev(str
 	if (adev) {
 		csi_dev = ipu_bridge_get_ivsc_csi_dev(adev);
 		if (!csi_dev) {
-			acpi_dev_put(adev);
 			dev_err(ADEV_DEV(adev), "Failed to find MEI or CVS CSI dev\n");
+			acpi_dev_put(adev);
 			return -ENODEV;
 		}
 


