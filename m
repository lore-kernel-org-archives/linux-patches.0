Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27728136988;
	Mon, 23 Jun 2025 13:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684423; cv=none; b=etaiK8zbtWndZpYLGqibvkPp9Fme3mfV+xxh2ZCm9BqXJO2okXTkOM6m/kHz5Rzmdr5fAIOQWWKNrShOw8h7uw08kPTJlINHO83yW5Dnv/s3MnFV9ejnK820aaMsoXpQZwzFLkbUVKmHz0KwKupoSfKKXEMPZALhxUuivGwz4ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684423; c=relaxed/simple;
	bh=HXcNGVMAmAPHv+ieq3u0iecPkffQXDsFYRZDjoF/mvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+qq/iHkWDKoU3HbiqW/ZCkqf8ekos97rKPwxgs/Kom2hViC+khkWi3NXvWyjYKIcqqqwOhRand1Aym1cFt/yrrWgCoMSjB0t7iG4ilKIoQCCtvwBE6noG22mmx6+BIz6cQJa87BMFwtt2o9yi0MmD8ow7HNnQ1SDMzXg31cRtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsuAqvsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsuAqvsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53725C4CEEA;
	Mon, 23 Jun 2025 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684422;
	bh=HXcNGVMAmAPHv+ieq3u0iecPkffQXDsFYRZDjoF/mvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsuAqvsY5E/gNOAgKieNqbeCixJjmjvmXGFx55toR3LfmJi1Az8MMrNxu39XcGsg6
	 SIutMu/zSDoA+MVFJCFvjiRdugY3bKMJbFwxUZ3hh1Lw727Njzdot4HkfEnGRPyjAl
	 5HYY5IL3xv5VCYi1vH0ISFfxic8jjUyhu4GhpDZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 062/592] media: ov2740: Move pm-runtime cleanup on probe-errors to proper place
Date: Mon, 23 Jun 2025 15:00:20 +0200
Message-ID: <20250623130701.733697661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 81cf4f46a03a07b0b86f9d677c34ba782df7d65e upstream.

When v4l2_subdev_init_finalize() fails no changes have been made to
the runtime-pm device state yet, so the probe_error_media_entity_cleanup
rollback path should not touch the runtime-pm device state.

Instead this should be done from the probe_error_v4l2_subdev_cleanup
rollback path. Note the pm_runtime_xxx() calls are put above
the v4l2_subdev_cleanup() call to have the reverse call order of probe().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Fixes: 289c25923ecd ("media: ov2740: Use sub-device active state")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov2740.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -1456,12 +1456,12 @@ static int ov2740_probe(struct i2c_clien
 	return 0;
 
 probe_error_v4l2_subdev_cleanup:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	v4l2_subdev_cleanup(&ov2740->sd);
 
 probe_error_media_entity_cleanup:
 	media_entity_cleanup(&ov2740->sd.entity);
-	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
 
 probe_error_v4l2_ctrl_handler_free:
 	v4l2_ctrl_handler_free(ov2740->sd.ctrl_handler);


