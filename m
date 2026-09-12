Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA2727AC31;
	Sat, 12 Sep 2026 07:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198868; cv=none; b=qFXQByT8+BcfWq6HtbPyWNYz7kAeKSfRANl6wWUDLXnBsci30VEZo5sZ+iiiHDuwjGdB0lqWkHseao9r7m9Bz3EXVtQEykTScMHaNEK93FusWRKzf40QYpW5cUmykpXEtyypKHCCYQAkHCHBQ42y34zmu5ej4WZ50L2LHq5qAIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198868; c=relaxed/simple;
	bh=2x+Vt+XnC67xir2DucZgU20F8OqgKP0GMJlc9W3JjzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezpTxgst9Bs4e4Dip0e254SrK6RbC9cyYpyQCLyBs2vsVxYGTYqcNvDMELgG8JahySn726ED2ZoFlurLne9ysuxgvxaIgROmh1jBW9w4IErOqTP4g3mZabYano/Fe50t+OwOov99jbz+SuPDWz+OhOG+woliMBdlbnT3wau+QkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUePgRYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUePgRYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDB21F000FF;
	Sat, 12 Sep 2026 07:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198864;
	bh=Dz6c1R6Ig44WNaxWlrUZKMdHMveEPPeVKaJtbNThfxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUePgRYu25V1EA4Jh3tOagADZXqruMhWeibwUD5ZemuZzU5fsvi9ZydWUqIg14VrQ
	 eki9yNqU5DHQqxOlUXvcMATqdiXR6KaZfPZBKawJeI/6iBMwTPGq+7RUil4BPjQ/bK
	 83NAOuuBJkZwLRi41LAF7F1p2KwlDCYIfTq7QGSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0469/1815] gpu: host1x: Avoid double device_add when clients already present
Date: Sat, 12 Sep 2026 08:36:59 +0200
Message-ID: <20260912065659.897117706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 254290869fd234b85119c48dbb98efa5fcd41a31 ]

host1x_device_add looks through the idle clients list to populate
subdevs, and any matches entries are moved from the subdevs list
to the active list. If all subdevs are populated, device_add will
be called on the device. The secondary "subdevs list empty" check
will then incorrectly again call device_add.

However, this would require a convoluted scenario since clients don't
typically end up on the idle clients list.

Fix by checking whether the device was already added before adding
again.

Fixes: fab823d82ee5 ("gpu: host1x: Allow loading tegra-drm without enabled engines")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-2-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index ea3b584990c9a..733f53e69eacc 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -508,7 +508,7 @@ static int host1x_device_add(struct host1x *host1x,
 	 * Add device even if there are no subdevs to ensure syncpoint functionality
 	 * is available regardless of whether any engine subdevices are present
 	 */
-	if (list_empty(&device->subdevs)) {
+	if (list_empty(&device->subdevs) && !device->registered) {
 		err = device_add(&device->dev);
 		if (err < 0)
 			dev_err(&device->dev, "failed to add device: %d\n", err);
-- 
2.53.0



