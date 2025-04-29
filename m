Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72852242934;
	Tue, 29 Apr 2025 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945678; cv=none; b=aQirppmzPbuILSdlbOHXlEhJQy+ydqVUCF4prcDaWXveyymuTAbAvs69AHj0BadURq6oPhGZsoydglllNosJRbbxQW6daHSNAAUU8/OCK1oX/bQFvrbytnUgBNm/t55HNtlgccMq/l9U/qfnquxSlODrUiL3LV8FxMs0OsTOdpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945678; c=relaxed/simple;
	bh=2WRXpCp/uZHG78lTtr3NtyeqhXSehYFht10mmE9TrCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkHyiQYJmnxJBHR+LQs1/BTEYNueVHWL9RURf+cA715AxvZd5vISl2TdCSITf1LSDmHreDf0SSiTxj6A6d7A43SDMKHU7XCENKRWvZmT0O/vHLyjbSPhqd7EA6DrBYHQIgv/xe//yPyXtjhcRlbyJP34lciTvPNH6akAwyvPyQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDPInoqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDPInoqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0328C4CEE3;
	Tue, 29 Apr 2025 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945678;
	bh=2WRXpCp/uZHG78lTtr3NtyeqhXSehYFht10mmE9TrCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDPInoqkY0RZbNS/U9Pbbn9qsE0BKpQ/ZWVW2BniRq3TQG3LXxm90r41gC7sUZZNA
	 BO8eD8jvNtfM8u27UeFXYNfuUTe17amVLKIRdhlWGBVTCVpiG4hg8XhOurRIrnn0QF
	 2vxBupKqt5yz7bd+70GrZpwlMxhvLrGX5zvouzso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 013/311] media: ov08x40: Add missing ov08x40_identify_module() call on stream-start
Date: Tue, 29 Apr 2025 18:37:30 +0200
Message-ID: <20250429161121.574633872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ebf185efadb71bd5344877be683895b6b18d7edf ]

The driver might skip the ov08x40_identify_module() on probe() based on
the acpi_dev_state_d0() check done in probe().

If the ov08x40_identify_module() call is skipped on probe() it should
be done on the first stream start. Add the missing call.

Note ov08x40_identify_module() will only do something on its first call,
subsequent calls are no-ops.

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Fixes: b1a42fde6e07 ("media: ov08x40: Avoid sensor probing in D0 state")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov08x40.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov08x40.c b/drivers/media/i2c/ov08x40.c
index 580d902977b68..625fbcd39068e 100644
--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -1976,6 +1976,10 @@ static int ov08x40_set_stream(struct v4l2_subdev *sd, int enable)
 		if (ret < 0)
 			goto err_unlock;
 
+		ret = ov08x40_identify_module(ov08x);
+		if (ret)
+			goto err_rpm_put;
+
 		/*
 		 * Apply default & customized values
 		 * and then start streaming.
-- 
2.39.5



