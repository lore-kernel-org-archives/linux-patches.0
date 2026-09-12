Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1441B343893;
	Sat, 12 Sep 2026 12:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215481; cv=none; b=neRAHeAguC3BTrVdzsXu/nYQ7GjEs+n6nIhRQnRoGMrKYjcGUwWD3xxfE/ASA4ujE81XI1xWhxqUSv8zRODUanGAGA43vuntKctnChUwAmPxGhX8KHM4fmZ8tMWP6NMqMN8Fzf/WRe7I16gJ78f7d6lxqRKLeKuabg4RD6DoV5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215481; c=relaxed/simple;
	bh=uUuaazllxJWdyEnzu/r5e8GURUNYvbZF/FbjMe/SkHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC+m5KrxEpW+nADpyDYbPai/RBWGGHn1DGLNikHKAxGENrJMl5zgCVfywbjfZhvPf9mFurmW2SefWq9hIImACgpq8xT03lsxrh+e/u2So1AgEauoGeW92T+lRZS0qwlfoGqGv4naYYs8O+o8kTOLlNmAelivSQugKPJXHf7F6yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2cguLj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2cguLj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810C71F000FF;
	Sat, 12 Sep 2026 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215478;
	bh=7TYQ8SVnMupcFvb7N/wvvW6LmvZphIPgL96K4rzz4Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2cguLj7KdmRfolIEHQMWz/m0Rk62NW620YcMfpGqOaft5dDvMRVDmUg8kmZfUmc5
	 CQ2NIlQk8PXbjWG4nSkD9WurhU9auVvDNr7rgnbZ59GxoA6tz970YjYqbDjftAH1f2
	 8IuVbPVx8Q6c2NhYTyQsPyiIyEDlh7JCgGgQXvyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0540/1376] firmware: arm_scmi: Use channel ID for transport teardown
Date: Sat, 12 Sep 2026 08:49:26 +0200
Message-ID: <20260912065619.577310613@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit a71a3d4d8a6e9e399fd988c0e6da47a6ee21c99e ]

SCMI protocols can share the BASE transport channel when firmware does
not describe a dedicated channel for the protocol. In that case multiple
IDR entries can point at the same scmi_chan_info, whose owning transport
device was created with cinfo->id.

scmi_chan_destroy() used the IDR iterator key when destroying the
transport device. If an alias entry is visited before the owning channel
entry, the lookup can miss the device because the iterator key does not
match the protocol ID used when the transport device was created. The
code then clears cinfo->dev, so the later owning entry skips teardown and
leaks the transport device.

Destroy the transport device using cinfo->id, which is the protocol ID
that owns the channel and was used when creating the transport device.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-8-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f9d6b5eb89191..17f0a461cb96f 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2771,7 +2771,7 @@ static int scmi_chan_destroy(int id, void *p, void *data)
 		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
 		of_node_put(cinfo->dev->of_node);
-		scmi_device_destroy(info->dev, id, sdev->name);
+		scmi_device_destroy(info->dev, cinfo->id, sdev->name);
 		cinfo->dev = NULL;
 	}
 
-- 
2.53.0



