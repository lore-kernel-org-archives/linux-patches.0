Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8173834252D;
	Sat, 12 Sep 2026 07:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198539; cv=none; b=sh6F7u/5qExQdRpfeTzFlMVLDWY+hmWMgYNz/GCQAe8VSaPHLbbYcrp1AUG+fbk1ZUmewhevh30dPiEUo9cMAjTqoVbmYHOOqGZQDvvHmvmaIupnE28UNZXb6yZx4o7JrPn/cj/k4H7GLxyiWeZ/qFazhKC7xRvugQ77XcOg92Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198539; c=relaxed/simple;
	bh=6u7GfWD3jZulH+krYNGaYsxZm8Fuu9FCaJUdeoirrr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug3PDfIqvoDcBmCJ34bOEI9UQUOKaZ6OucjMxFXXZPo70+0PimobP2VJBf5DMFicIj7w2S1SfQM4LR/ZzsbyG8nlbPZGMIb251uhrC/pAAB5NFAXSwxMUPfrmhPVmvSifD6ukpnwGiz/Jyy1lL1XvCrnf8pf5o1GP7FZhTNp4b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFY1qyae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFY1qyae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942131F000FF;
	Sat, 12 Sep 2026 07:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198538;
	bh=7hlvn2h+QJ/Ju5InMXWzZO6eeXYOow27Lj1K3Uy/b1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFY1qyaehP1NjIsGtdHSrBvVPHcrzrqFiFcJuPoLiE23/RpCicK+/pwbFmPBtsPuj
	 x2XyPgTYUP7RfkagFjy2SRx2z2DYrRppbuoK5XvjlMXom/mjhD8xWsS2Dp49B01T1+
	 NxSDW3zukW36MWfgD6jn0gK34bSVD0UltQUiK9UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0400/1815] firmware: arm_scmi: Use channel ID for transport teardown
Date: Sat, 12 Sep 2026 08:35:50 +0200
Message-ID: <20260912065658.286267373@linuxfoundation.org>
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
index 0735c63742690..f607557c04ad2 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2896,7 +2896,7 @@ static int scmi_chan_destroy(int id, void *p, void *data)
 		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
 		of_node_put(cinfo->dev->of_node);
-		scmi_device_destroy(info->dev, id, sdev->name);
+		scmi_device_destroy(info->dev, cinfo->id, sdev->name);
 		cinfo->dev = NULL;
 	}
 
-- 
2.53.0



