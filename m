Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4111373BE0;
	Wed, 20 May 2026 16:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295848; cv=none; b=jpCy7g8PHSbfFfWnhKBQogjBKfcBdKkwqU7QDAp9SoJ75VeK6qPcVCPWo2nsqCVdipapyxlRvH30mZ0A6M9DAZDw1UBJicyk2qVgJ0tOlY2pg/JvrQyhgtHEQaNolGpFiG6A34DDUcLLlRRgcAnamGZsNM95EQ+aVj3TlYRytnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295848; c=relaxed/simple;
	bh=5X6nasb6QvNqkuV3CojinDwuycKtoy9JwuZfyeZuFc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP8Didp4byo3moWVqcwqdBZlkHg5l29ucaySf5tRCgEQFwX1aKVuHgqVHq3fO/bbqLNsznFTMwJcyL9QPtEz0/9lEw/ln4qf0+KIGWAPsOKCzFXPZ/q4A58ehDkcLQDJB6Ycxk1oH279iki0i21APNcaGrXkqkwutZMf3hS7cQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/uXS91e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/uXS91e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15C91F000E9;
	Wed, 20 May 2026 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295847;
	bh=bzwHj2gGpT73hOdyIDlQ+B4aSZNPuQYY2Mrs785JPS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/uXS91ecqaSUoT2BbiGVSUhDOHzYqAWKtIfart19jM+Nrh/HK4tytKt4xOjd1+SV
	 4fX+z0CbbFBCMkiPoDajAzC8kSwWcAKj1u2fO4l+ART8IU9sqOyY7/u8RwvUI3f58j
	 ztBft8XGtM8GujjqVal0T9YlImrsjYUy4LSY5JHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0576/1146] soundwire: Intel: test bus.bpt_stream before assigning it
Date: Wed, 20 May 2026 18:13:46 +0200
Message-ID: <20260520162201.218634337@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7f01e43ae978a..20422534baf19 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -82,6 +82,11 @@ static int intel_ace2x_bpt_open_stream(struct sdw_intel *sdw, struct sdw_slave *
 	int len;
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



