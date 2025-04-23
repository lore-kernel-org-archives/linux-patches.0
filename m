Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2C720D4F8;
	Wed, 23 Apr 2025 15:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420874; cv=none; b=EbUJGWoKi9WNadyJZRuTZdBLIL82tQ+DyDVVhLLrSNld8tnQUyq+7gf6/RclptfQzzMVasDUlKjwDJ0aoUniy96avd6NI3PngqpwmxPQQtwcJuDH4M27kaAuXI2Db29e9QWyVsbzaioV/Mua9vzm1niZQ/KJiHebY7oBcuvP2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420874; c=relaxed/simple;
	bh=BBGkVhOLkonVbAGbo03HNY21uo3N2/Si5D4f1uSzkbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpC5BTP+fiCPRjqAy8xJVBoy8tldCGBMvePfkMwqxawjN+0zLiceB91GLi3fuIulQHcrwN/mli2DKLS+fwnYSJvLiK9hvTeHh8knvo0iu0VQ6q+E81NguzlVh+KQnrz6plP+l6jJ/lf6mwBKGPFVkOqLP7UWIRB7lk4OR7iyXDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy6gJJQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy6gJJQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E3EC4CEE2;
	Wed, 23 Apr 2025 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420874;
	bh=BBGkVhOLkonVbAGbo03HNY21uo3N2/Si5D4f1uSzkbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy6gJJQ/l8z6uwQTk60eZliaozMcgo23HEFGAI+0v5nfazhA1WMuP4uPTp/UXA9Yw
	 9uTswbU7+jrgvOEbI4Y6DFxGnYz6o2J1XjNzEd/+gZ6oLq78V3wrmYFarJl1tHapwx
	 FQ3/Ch022VjFQEKWX3gcWcP1wHHpCpQcuZ8IJdh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/393] drivers: base: devres: Allow to release group on device release
Date: Wed, 23 Apr 2025 16:39:56 +0200
Message-ID: <20250423142647.417003048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 8e1ddfada4530939a8cb64ee9251aef780474274 ]

When releasing a device, if the release action causes a group to be
released, a warning is emitted because it can't find the group. This
happens because devres_release_all() moves the entire list to a todo
list and also move the group markers. Considering r* normal resource
nodes and g1 a group resource node:

		    g1 -----------.
		    v		  v
	r1 -> r2 -> g1[0] -> r3-> g[1] -> r4

After devres_release_all(), dev->devres_head becomes empty and the todo
list it iterates on becomes:

			       g1
			       v
	r1 -> r2 -> r3-> r4 -> g1[0]

When a call to component_del() is made and takes down the aggregate
device, a warning like this happen:

	RIP: 0010:devres_release_group+0x362/0x530
	...
	Call Trace:
	 <TASK>
	 component_unbind+0x156/0x380
	 component_unbind_all+0x1d0/0x270
	 mei_component_master_unbind+0x28/0x80 [mei_hdcp]
	 take_down_aggregate_device+0xc1/0x160
	 component_del+0x1c6/0x3e0
	 intel_hdcp_component_fini+0xf1/0x170 [xe]
	 xe_display_fini+0x1e/0x40 [xe]

Because the devres group corresponding to the hdcp component cannot be
found. Just ignore this corner case: if the dev->devres_head is empty
and the caller is trying to remove a group, it's likely in the process
of device cleanup so just ignore it instead of warning.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250222001051.3012936-2-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e9b0d94aeabd9..8a0f000221271 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -687,6 +687,13 @@ int devres_release_group(struct device *dev, void *id)
 		spin_unlock_irqrestore(&dev->devres_lock, flags);
 
 		release_nodes(dev, &todo);
+	} else if (list_empty(&dev->devres_head)) {
+		/*
+		 * dev is probably dying via devres_release_all(): groups
+		 * have already been removed and are on the process of
+		 * being released - don't touch and don't warn.
+		 */
+		spin_unlock_irqrestore(&dev->devres_lock, flags);
 	} else {
 		WARN_ON(1);
 		spin_unlock_irqrestore(&dev->devres_lock, flags);
-- 
2.39.5



