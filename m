Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0C21D07B9;
	Wed,  2 Oct 2024 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877396; cv=none; b=LGfmcF1e9IKzgcWheQqbxLT3ZUHOVMed3/iDu4zReSjeOaUBEQc1HRyRLx8SYGlLb3TG+vPlxBUxxCimeSFk/35uSjlD12H/TAwqyGI4Dc84zoMr/GU1G8A7Hap9maDcZZmV9xPZZzWMugPiLpkstKbXKe4Bea0Juxr2MPVwyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877396; c=relaxed/simple;
	bh=xWWZWUoi5SDbmwB1lCljIk/EzBOJr/krGd/yirNV1JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG5axM9b0/1qLmtdw3D5WD2N7AAfR98HRWyeqR7LuGnrocBzO7eUrbe59SmJL2/1sTgZrxJGPBBvISL0zn7tl0zre5CcFYbC2eukMrhN5kft9V3giOfkvbcfq0xZO61f41pLg6yM+w+KAWnvxPDqSkVVzUuzMH8DgVdn/NY+l1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiRDNn4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiRDNn4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48684C4CED9;
	Wed,  2 Oct 2024 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877396;
	bh=xWWZWUoi5SDbmwB1lCljIk/EzBOJr/krGd/yirNV1JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiRDNn4gvFSQf+TJ5rVUDUw9sBHYZzdq1nK6txhQL4g/0HKMTaDTXrt2N50HdAUq8
	 9N342b3vs+8MkwhfSlLTw0PsNwOc3lVAxTIgToV+DiWe9QvkIEtnIA1yibbsX3XCzi
	 CP2hieXkm/NrUWJIpeyPlQRBukAOOR++HnvSKazI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esther Shimanovich <eshimanovich@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 036/634] ACPI: video: force native for Apple MacbookPro9,2
Date: Wed,  2 Oct 2024 14:52:16 +0200
Message-ID: <20241002125812.523474947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



