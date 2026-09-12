Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BDE29DB64;
	Sat, 12 Sep 2026 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228630; cv=none; b=r6QQm7jjgPhCYEOyivOGBjp/dFhc2YUjit0OJvPkttbOi+pZq5KMPkOP/SY6SfUHL0W2AR7ev258t4DfVUUl4+e2uVfIW2zOCrGMSewdFE/e5eZ+H+72EWxcWIzoCQC3flqOSPDh78LhoICRKyS1B4JiPkv8GiAL7skFKB5NgrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228630; c=relaxed/simple;
	bh=IB0BETo/3A/Hid2KY1QqBzQfnxRAFj8jR8vjdYHTK08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDuVzNXlHSq312D1X1sJcYaYI8Vn9Vbvhii6mAPBA9EvkaBmw6Rp4BV3OCNfTni7N71/QDD9qN61NZ1PPXFmh1onFGC4BVrGXf5vd8UjTfqX3F1HH3tIDKy74/v/Qz8xh+uDFVP+zhd+xOfa8Dab5Noyn7toykl+HpPohlNx4bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yi6dfkw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yi6dfkw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639071F000FF;
	Sat, 12 Sep 2026 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228628;
	bh=ZM/5Mln7mpXqD8MSaWHbcNsnYLmV1IQVNnB4jM1R1AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yi6dfkw+M2r8UWtAVhKm3sma8apMLq3guDN/69a2XfTKxWrOz+ZVYv/FIJVsPgkCU
	 DDpzxtc0ph0BIy0JBtaXprUgMS3IvtspMJVz3Unv6MDOYBd/eRXGtcA00sM7zKhazT
	 +Sf2cl5BP6Zfwsm5lpz5coilrNtipYnIg6Tc+O18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+db96c5ff032f4292a8dc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 0417/1191] drm/i915: Guard against NULL driver_data in i915_pci_probe()
Date: Sat, 12 Sep 2026 08:52:25 +0200
Message-ID: <20260912065557.606294485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 3785d40831ba5601296283e0197e10e089392757 upstream.

pci_match_device() can return the dummy pci_device_id_any entry
when a device is force-bound via sysfs driver_override, in which
case ->driver_data is unset (NULL). i915_pci_probe() casts it to
struct intel_device_info * unconditionally and dereferences
intel_info->require_force_probe, causing a NULL-ptr-deref.

Reported-by: syzbot+db96c5ff032f4292a8dc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=db96c5ff032f4292a8dc
Tested-by: syzbot+db96c5ff032f4292a8dc@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260813064902.367504-1-kartikey406@gmail.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 2727922084672cc274ecea726ea00363c2893731)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -1327,6 +1327,9 @@ static int i915_pci_probe(struct pci_dev
 		(struct intel_device_info *) ent->driver_data;
 	int err;
 
+	if (!intel_info)
+		return -ENODEV;
+
 	if (intel_info->require_force_probe && !id_forced(pdev->device)) {
 		dev_info(&pdev->dev,
 			 "Your graphics device %04x is not properly supported by i915 in this\n"


