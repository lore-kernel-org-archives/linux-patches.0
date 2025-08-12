Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C302F5E;
	Tue, 12 Aug 2025 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023504; cv=none; b=foPYwxfZDMJDNZFCb4GKSyBrvkQUho3ArMkZYJHEr3UMnI71bEy+5WnLxQz3HejURCf/5JSg4DKwPBhCCVDPftAajYWDcSvH9E90tL3ZCFW/pGolxOz8+wQ3qwKuAAiMNAC2mOJu11b/sAw++XTJtFy7ZzfHnfqjUSjZv9greTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023504; c=relaxed/simple;
	bh=TNIUyvli6pmTeJolUsg7TChqfCgpfj+XdwPScWamXOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jORlqM6Sox2TscptadryZ3/OnssPaVKqs3nGX+OhCuaGEhSDsIwIP4l73ePJOAKVD3De9o8/Z/UtFArTTFHIs0jf21et2oBW1Y33ASsjsEYe3CLcdUUAg2gPGzZ//vyk641wF96z+9WxVxoqrURfb7y5b0Ra/PQJXg12V9nEz08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0v+6MVtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0v+6MVtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E892CC4CEF0;
	Tue, 12 Aug 2025 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023504;
	bh=TNIUyvli6pmTeJolUsg7TChqfCgpfj+XdwPScWamXOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0v+6MVtOj4+0VDMfCUW4KlOYVSx6w+Lw9Uvcwn7arUJYT/5+wDabmPdy+JgbzUdKc
	 oaacCvgvjKqzH/hgYeO0ApO5A4B/lu99XcZKjWrXHzB4MdLXt+7bjBtEtyzYyziEJt
	 E5oQ+A7crRiG/7qeRBImObEvqfibckg8/A/hgsbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 066/627] mei: vsc: Dont re-init VSC from mei_vsc_hw_reset() on stop
Date: Tue, 12 Aug 2025 19:26:01 +0200
Message-ID: <20250812173421.831814787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 880af854d6343b796f05b9a8b52b68a88535625b ]

mei_vsc_hw_reset() gets called from mei_start() and mei_stop() in
the latter case we do not need to re-init the VSC by calling vsc_tp_init().

mei_stop() only happens on shutdown and driver unbind. On shutdown we
don't need to load + boot the firmware and if the driver later is
bound to the device again then mei_start() will do another reset.

The intr_enable flag is true when called from mei_start() and false on
mei_stop(). Skip vsc_tp_init() when intr_enable is false.

This avoids unnecessarily uploading the firmware, which takes 11 seconds.
This change reduces the poweroff/reboot time by 11 seconds.

Fixes: 386a766c4169 ("mei: Add MEI hardware support for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250623085052.12347-3-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/platform-vsc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/mei/platform-vsc.c b/drivers/misc/mei/platform-vsc.c
index 435760b1e86f..1ac85f0251c5 100644
--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -256,6 +256,9 @@ static int mei_vsc_hw_reset(struct mei_device *mei_dev, bool intr_enable)
 
 	vsc_tp_reset(hw->tp);
 
+	if (!intr_enable)
+		return 0;
+
 	return vsc_tp_init(hw->tp, mei_dev->dev);
 }
 
-- 
2.39.5



