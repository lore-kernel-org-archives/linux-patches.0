Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E89A280A4F;
	Wed, 23 Apr 2025 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420572; cv=none; b=cKcjhbngwTXo9gBqFBnO3ZEjR9a3jdeyMdNlhRX/wKHVX/v2xQmnEvihYaLvKDCJYMwC00AqKAPgjk378rwZSikmQ6+EjGD/lgYG7wW1sXL4W3fnjDcQxklzRsVRpAoUNVeF+CSyN84FZHsmzk6l13H1TbADhoPRfOqKq15S2so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420572; c=relaxed/simple;
	bh=E7HqegBKTet/wL7Y3vHhYuu7en06Ovh31WoKond4uWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1r3yY4N4xAdP3FiBIlL8FE5j9LyePrMlm2vqOAH5VrrdqlqGOlFaGVSkebVlOnFpwGkSgAkGhrd+YQBFcW+HUtvy9TN/zfxYTh/ZlwdvfSczY4+m2TtT+wusZcZvhVY3rcN7UpA14MA2eh1j4b11JUs4DSbFy2JuMue8Pm4hF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mnmngoaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mnmngoaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9495BC4CEE2;
	Wed, 23 Apr 2025 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420571;
	bh=E7HqegBKTet/wL7Y3vHhYuu7en06Ovh31WoKond4uWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnmngoajoM8athWCrP4YaH+Wi7g/f8Wmg2liT3P1Q4WSqDEMN8Ai6PW5qa9eW2MnB
	 moLu4nMQKUWD7DFAqF8Pk4/63LNlK43Ii1k6n/3r/4fGgqj39yLUZ/r9IR18KH4rTG
	 Ajf/vdxwNCn9UzmvuGQkd5IlACLTg10R0GhtkXH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/291] drivers: base: devres: Allow to release group on device release
Date: Wed, 23 Apr 2025 16:40:50 +0200
Message-ID: <20250423142626.867427723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 35d1e2864696f..9d0ea5c14bc50 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -684,6 +684,13 @@ int devres_release_group(struct device *dev, void *id)
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



