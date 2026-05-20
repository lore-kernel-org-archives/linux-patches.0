Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CB629D26E;
	Wed, 20 May 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298534; cv=none; b=HEv0Md7IJVyg1pW8o6yr3sYNOJeUZRnEi1yrLB1dCZ3CQNEMM8fFvlCCmq4slIGskL/OqxMTwbAWFCrMTOn+CS0sqVhlMjeTf/QAMCmomnDGgaUHFia1zmKml+8WSpzLEh8E4UezeIUGwZktyeX1CsDm/38QqOET9AqB8bCZbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298534; c=relaxed/simple;
	bh=QkxAvE987d1ni3Nu/AJZy7R8dgag1BhPEdlD5XZoxL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6mDXHhimLxray0fDjRfPmwrn4r2u/2nEejYgMQmbUrYEvvTqYCzHo/ZqLsMZbG3Ki/s/WfYWfpi1UmOpM2iT+8GIdeqfx+Dj5z1tCfp17GIw7LML6hd8rSmKfkOC3HXVu5+rIUiuTWtorQg0xw7jffijTxT/ZUaCQ17g5GNXq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqcYQPal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqcYQPal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF331F000E9;
	Wed, 20 May 2026 17:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298533;
	bh=bHAfVkKGBlNZ631T4CnJz5QP2AL+UAIlD9BmVPYIgBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqcYQPalzcnetFG6zowqEHUVnb2yNaqhtLWBBahLDRYZXY05Doln8u5sFJwaZm7kU
	 1oW8drDXjr9L7bc2cIcP+xJxvVpMUWpX18Zp2slScINGerCIDiQyvCIHWnDTE4O5xv
	 gQj20Gp4NL0VskcCIJTzUI1YV9YFXXDx+AGQGhlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 448/957] soundwire: Intel: test bus.bpt_stream before assigning it
Date: Wed, 20 May 2026 18:15:31 +0200
Message-ID: <20260520162144.234997983@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit b2c9f1d5a7eb50bcdda607afef1378e552bbb490 ]

We only allow up to 1 bpt stream running on a SoundWire bus.
bus.bpt_stream will be assigned when it is opened and will be set to
NULL when it is closed. We do check bus->bpt_stream_refcount if the
stream type is SDW_STREAM_BPT in sdw_master_rt_alloc(), but at that
moment the bpt stream is allocated and set to bus.bpt_stream. It will
lead to the original bus.bpt_stream be changed to the new and not used
bpt stream. And it will be released and set to NULL when
sdw_slave_bpt_stream_add() return error as it supposed to. Then the
original stream will try to use the NULL bus.bpt_stream.

Fixes: 4c1ce9f37d8a ("soundwire: intel_ace2x: add BPT send_async/wait callbacks")
Reported-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20260126054045.2504103-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_ace2x.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index 5d08364ad6d14..5b73bbb73be6e 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -68,6 +68,11 @@ static int intel_ace2x_bpt_open_stream(struct sdw_intel *sdw, struct sdw_slave *
 	int dir;
 	int i;
 
+	if (cdns->bus.bpt_stream) {
+		dev_err(cdns->dev, "%s: BPT stream already exists\n", __func__);
+		return -EAGAIN;
+	}
+
 	stream = sdw_alloc_stream("BPT", SDW_STREAM_BPT);
 	if (!stream)
 		return -ENOMEM;
-- 
2.53.0



