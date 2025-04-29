Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9EE254AFB;
	Tue, 29 Apr 2025 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950255; cv=none; b=XNmKoj5+Q+u6GUSAzaEcPA0TP5O3X/cUkJZaOBF7JQD8cGTJwVS8z33M4v0+bhlwdpdFaDcdMTpwR05AX0yJlI7lEwX4XP3nAEvNYfeZHswzU0DdpdBTvrjX4IJGdsLG3AFhaF8+WU3owJWF7XwvadRplgAtjkse/oCbFYHmRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950255; c=relaxed/simple;
	bh=CyF5M40BxhfziimjL8KiWgpLtaYIaO4p8N/F03xijn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdEk8/mcos99SmGT8+DUW5Hggfh/6ZRf6CeUChpTcz4P5B+Ed6VvvdHpeU8sudBp367Yz7pbkR7EOrd5q74Rru79cSrJh7PCcx6zL8/r7OPLEeyrTJQ/Qfz79gbcJvnWVc0QItwGJdYdBTBYPEpX2UmfUzS1+2H3dEKs+Z8djKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8+olgE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8+olgE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC91C4CEE3;
	Tue, 29 Apr 2025 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950255;
	bh=CyF5M40BxhfziimjL8KiWgpLtaYIaO4p8N/F03xijn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8+olgE1xhR7x+qKIek5KS2NzvuJrLi00BpkehGazM13p69J5ycfOa0u78vmRchWK
	 KhG4p424gTgBD4wFrZsuoUa1FiKHhZllUY1Nz4nRiv7zbo7ekbHQxaz9sCHDa6t59g
	 oluhSXTyXpRpTncp2mNTcZZo+4sbk71zgFwGeeJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/204] media: subdev: Fix use of sd->enabled_streams in call_s_stream()
Date: Tue, 29 Apr 2025 18:41:36 +0200
Message-ID: <20250429161059.744952586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 1d7804281df3f09f0a109d00406e859a00bae7ae ]

call_s_stream() uses sd->enabled_streams to track whether streaming has
already been enabled. However,
v4l2_subdev_enable/disable_streams_fallback(), which was the original
user of this field, already uses it, and
v4l2_subdev_enable/disable_streams_fallback() will call call_s_stream().

This leads to a conflict as both functions set the field. Afaics, both
functions set the field to the same value, so it won't cause a runtime
bug, but it's still wrong and if we, e.g., change how
v4l2_subdev_enable/disable_streams_fallback() operates we might easily
cause bugs.

Fix this by adding a new field, 's_stream_enabled', for
call_s_stream().

Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 36cef585e2a3 ("media: vimc: skip .s_stream() for stopped entities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 8 ++------
 include/media/v4l2-subdev.h           | 3 +++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index a32ef739eb449..8bfbe9d5fe3c4 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -363,12 +363,8 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 	 * The .s_stream() operation must never be called to start or stop an
 	 * already started or stopped subdev. Catch offenders but don't return
 	 * an error yet to avoid regressions.
-	 *
-	 * As .s_stream() is mutually exclusive with the .enable_streams() and
-	 * .disable_streams() operation, we can use the enabled_streams field
-	 * to store the subdev streaming state.
 	 */
-	if (WARN_ON(!!sd->enabled_streams == !!enable))
+	if (WARN_ON(sd->s_stream_enabled == !!enable))
 		return 0;
 
 	ret = sd->ops->video->s_stream(sd, enable);
@@ -379,7 +375,7 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 	}
 
 	if (!ret) {
-		sd->enabled_streams = enable ? BIT(0) : 0;
+		sd->s_stream_enabled = enable;
 
 #if IS_REACHABLE(CONFIG_LEDS_CLASS)
 		if (!IS_ERR_OR_NULL(sd->privacy_led)) {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index ab2a7ef61d420..ee570dfbd791d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1042,6 +1042,8 @@ struct v4l2_subdev_platform_data {
  *		     v4l2_subdev_enable_streams() and
  *		     v4l2_subdev_disable_streams() helper functions for fallback
  *		     cases.
+ * @s_stream_enabled: Tracks whether streaming has been enabled with s_stream.
+ *                    This is only for call_s_stream() internal use.
  *
  * Each instance of a subdev driver should create this struct, either
  * stand-alone or embedded in a larger struct.
@@ -1090,6 +1092,7 @@ struct v4l2_subdev {
 	 */
 	struct v4l2_subdev_state *active_state;
 	u64 enabled_streams;
+	bool s_stream_enabled;
 };
 
 
-- 
2.39.5



