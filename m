Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0691CF5EE;
	Wed,  2 Oct 2024 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875266; cv=none; b=bCXSsyAUZCKwKCKVrsGp6bV+Nvxg7PCcVhfoq8aJaPbn8mPl7QHPCGA/AJpitlW1TiyeqtmPN7bBCOqVNMsJIcgQSUjxa2uQ1DsO+tbFrmsHNVZMXcHHP3lsj+5ieSzRikYuc3YXo6wf0lUynYx/Lqioy1anTKWBxa7pBfOCRJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875266; c=relaxed/simple;
	bh=BzaDUY0vsX7mlUN4bqSQ0TM8IAENS77sWbCZwJsyzx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umH3OnwxEzIP1DDEwEMfZqv871njY8yBocOlWPXZx49yzO5tS+z815qTUKNgEQo1Q2MgT1HR1q9k/snwQy0+23VNCju5hR+YTCXMvVqn20RTXR6mDl6v/cBtfT1bbts89qqUPBZ39kqhY3YEoSAyfIkLLCtb5Bw3MtCq/IrZnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G708zGvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G708zGvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DE7C4CECD;
	Wed,  2 Oct 2024 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875266;
	bh=BzaDUY0vsX7mlUN4bqSQ0TM8IAENS77sWbCZwJsyzx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G708zGvFStwvecs8YqyhcNNwHxZqsF1PY/zl/U4Vth6LT6Vh6EzKq/e8yNvoTRrdG
	 v1nGb1ugMZbeLzx6buc1yHC3T7sAs09kEECAS32m3jPEI7XBdBBuy20s4jAkpAmISs
	 obSuaK8lSiIp9kNXVo/nr3CxV9ag8FNg9JzJp8B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esther Shimanovich <eshimanovich@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 044/695] ACPI: video: force native for Apple MacbookPro9,2
Date: Wed,  2 Oct 2024 14:50:42 +0200
Message-ID: <20241002125824.248466148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esther Shimanovich <eshimanovich@chromium.org>

[ Upstream commit 7dc918daaf2994963690171584ba423f28724df5 ]

It used to be that the MacbookPro9,2 used its native intel backlight
device until the following commit was introduced:

commit b1d36e73cc1c ("drm/i915: Don't register backlight when another
backlight should be used (v2)")

This commit forced this model to use its firmware acpi_video backlight
device instead.

That worked fine until an additional commit was added:

commit 92714006eb4d ("drm/i915/backlight: Do not bump min brightness
to max on enable")

That commit uncovered a bug in the MacbookPro 9,2's acpi_video
backlight firmware; the backlight does not come back up after resume.

Add DMI quirk to select the working native intel interface instead
so that the backlight successfully comes back up after resume.

Fixes: 92714006eb4d ("drm/i915/backlight: Do not bump min brightness to max on enable")
Signed-off-by: Esther Shimanovich <eshimanovich@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240806-acpi-video-quirk-v1-1-369d8f7abc59@chromium.org
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 674b9db7a1ef8..75a5f559402f8 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -549,6 +549,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir9,1"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Apple MacBook Pro 9,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro9,2"),
+		},
+	},
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1217249 */
 	 .callback = video_detect_force_native,
-- 
2.43.0



