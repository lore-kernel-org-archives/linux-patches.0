Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD2572699;
	Wed,  9 Sep 2026 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964304; cv=none; b=q49U04A9BfqI4DGNyFcmtoGURyN3s/6T4MXkxY8MRJ2EVhu9DBJmS8d8jgx8qBsHBYmEs4i211AXpUKTVXcPT7BN1jt0O47KMDvENmm93BZ6u/xL/fVcIKzsotBeHmfUeAjtDQW5BgYiJeE+qFWS0vu40uSEdNYE+2ku3Dz5brY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964304; c=relaxed/simple;
	bh=xokoUhmNNi2gvHC4VezVgkGhRW90gaq/u0ghPWQRasU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCZOXUhZoqJjXy2NpTmpoyUp+t8PynYs3vcGjDXWA35JKIBEsmcJwfrChj9fBoj9qKPd3rsEug4p7f6HrOsQBJGHs4QtkAZ2X4ZEbQSKhe2WmkDQCb67pIDVeML1U71sx8djEMxRcOIqrHtMXjsAW5LYe7JND7d2B2xjq4MxITM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApQ7XpJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApQ7XpJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC341F00A3A;
	Wed,  9 Sep 2026 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964301;
	bh=WgToP4QCfjZCb4ElTY810UVv7CQ+sTQY2BSRMni0a6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApQ7XpJqPkRynlpNYRUJViu8WiGejnK6be/e8z8vG+KfQiakJp8E6gtsk74WKsJYx
	 PC3duCk3Ss3kM/9C3j1bgpVK0GLrEBWvHSIY3FFkkjHi23+UtOmy57eEBtifK6ZfLc
	 4MX+P4qcOrlCNYg2f4Jchenz8RjVFETgRIMjOfFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+db96c5ff032f4292a8dc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.18 376/583] drm/i915: Guard against NULL driver_data in i915_pci_probe()
Date: Wed,  9 Sep 2026 15:41:01 +0200
Message-ID: <20260909134251.053222901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -958,6 +958,9 @@ static int i915_pci_probe(struct pci_dev
 		(struct intel_device_info *) ent->driver_data;
 	int err;
 
+	if (!intel_info)
+		return -ENODEV;
+
 	if (intel_info->require_force_probe && !id_forced(pdev->device)) {
 		dev_info(&pdev->dev,
 			 "Your graphics device %04x is not properly supported by i915 in this\n"


