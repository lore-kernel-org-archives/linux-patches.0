Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8511E2D23A6;
	Sat, 12 Sep 2026 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222220; cv=none; b=X0mlLJneSQ0r6qhyWLV45HYiZJEuYyWvqc6Lyb9jU/PgopwM/w3C/QgOIJe0fdmveyHRJDfuHgYzRwNi/ZHngjb2aCt9UUhlW6uHWrMlP12z6BuOG6/uwZztPOLIF5z5m/3Va6I/U8u6vmVRzPcVtqfKuD19EvZ9vW9d93dUtyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222220; c=relaxed/simple;
	bh=q88IX/MK8Z+b/cQTpWioSkBzm+NOtvJBCj8dpaJl/Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoJmHD00GLIPGK3+w+xxL9jmkslw8q6U8upBBB1coNGUZjB6EiLrGMHgKTu+aJ8L7bFscvcN8iKsaM9vit7aBolztcvGp/vIHBHHP2evHCW/qwKNZCgQs26qDP83xeEjM67Bgwo3g5o0ZG2zWRh3JqKK0U/bdUWPJhGnFpgNdv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZFt2rV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZFt2rV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9B81F000FF;
	Sat, 12 Sep 2026 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222219;
	bh=SaPR7QnrlHfLHZsKsM8s/EqV47qGRiZSqttq3sfVPZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZFt2rV8DuugC/PolUQsyeGOpNK7fiY6OVwmB3kJeOfctlVP+ot+tMjejJuVGz2if
	 HRfoXfmcWcpGjN4hVN7PoAfHFz6Hus1xKv0VSkCV7ZnFkHkMkgMwxhYXHDuhefASC1
	 DRxatT6KqXYrsi7PLkrR0zgwi5DAjcBbx5TEdyTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+db96c5ff032f4292a8dc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 0511/1424] drm/i915: Guard against NULL driver_data in i915_pci_probe()
Date: Sat, 12 Sep 2026 08:49:03 +0200
Message-ID: <20260912065618.734431094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1014,6 +1014,9 @@ static int i915_pci_probe(struct pci_dev
 		(struct intel_device_info *) ent->driver_data;
 	int err;
 
+	if (!intel_info)
+		return -ENODEV;
+
 	if (intel_info->require_force_probe && !id_forced(pdev->device)) {
 		dev_info(&pdev->dev,
 			 "Your graphics device %04x is not properly supported by i915 in this\n"


