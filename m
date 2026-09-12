Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5E9372EF0;
	Sat, 12 Sep 2026 11:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214121; cv=none; b=jID4CHMZv80W8h2UNXVo7w1CEP/fAM+p7Ti+QI0h7jXXJIPVJyErHf0LNGmPy/rbO2V96gTNB8LpHyC7y7LxgX0rB2BsQIP+LGnlzmLkGWJC1igzcfM1h2GwdYJEQoerH58SO1H5sdmuXrX9p4HRvwsKa+16LWqC5MbZZBZQczM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214121; c=relaxed/simple;
	bh=SF5XOsOMMUlPGBfYojewkNcxXtIjy3sFQxdmsGqT/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZWmHnBpbBKh8hQxumvcMFjTktoNXlXGr4tEFn05UobXVP+OpWfB7FZYupqotKAb2oQI6gZX5zlEbNwVOvBqP+E5HeiafXq1u2FjeEnbD0k08uehKj1O5o6UpvXX+mjzqKi/G80/AQZK2+Nti72G7mkZlQYV04vhnXshMOCQD38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZX4aDt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZX4aDt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C285D1F000FF;
	Sat, 12 Sep 2026 11:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214120;
	bh=5rwsSv4/sQ+Q6mUCFwvfC+lVmupswklX4iwnP4Qwnw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZX4aDt+u7OmDO1jfYxJtQDOQK57bkkUaGCGj8FkY0jhaPDayNANULTezuHFDqS33
	 ytR9XhkVGmmk1SkFRynhb/ignHmyq5FuTJE4BoEBFQxKwpmD/Rk5zSlp4rs2pl0Ek9
	 J/tlj7ktxPG3vwAWr0sEAc/7xc552NPHZL3LBXDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+db96c5ff032f4292a8dc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 0262/1376] drm/i915: Guard against NULL driver_data in i915_pci_probe()
Date: Sat, 12 Sep 2026 08:44:48 +0200
Message-ID: <20260912065613.379943194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -961,6 +961,9 @@ static int i915_pci_probe(struct pci_dev
 		(struct intel_device_info *) ent->driver_data;
 	int err;
 
+	if (!intel_info)
+		return -ENODEV;
+
 	if (intel_info->require_force_probe && !id_forced(pdev->device)) {
 		dev_info(&pdev->dev,
 			 "Your graphics device %04x is not properly supported by i915 in this\n"


