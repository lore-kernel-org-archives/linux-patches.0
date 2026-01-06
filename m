Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDBD28C037;
	Tue,  6 Jan 2026 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721340; cv=none; b=T476iCHqoDmEbKCANd6e/iyn/v5puy+0ADVObQoSCd/QNK5sJSsaTa/gUQcJ+kFkNQEua5XwTi0gbZESSawyD8VS71656YGOLX0w64d0uj5o0ip5NwviuNkEI7C8hshXf0W2Oz4r8s8h3fdsKY7AgpXprbbsSRLqqrFsUXsQXCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721340; c=relaxed/simple;
	bh=V+WdBlq/4yQ1MZrEmrEuQmzzLjWfy4YRY0UiHwZhyV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dac4NqZSbuMybs+peYJJCpjTpqDlE1IFRA0o5OPeBAw9LNCenO5MZKpLQwO26H5LL2CRhbsh3E5PV43R5s+HljwHfV0TISDHSWcjhrY1bXtTQ/J7suvdgjWr7D8n+XBQ/Fgr+eaGFdtqbhupt6NFeV3VO9FZyRyT+igprLKtzxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twHjGEeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twHjGEeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DDBC116C6;
	Tue,  6 Jan 2026 17:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721340;
	bh=V+WdBlq/4yQ1MZrEmrEuQmzzLjWfy4YRY0UiHwZhyV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twHjGEeVRdCFJVX/lh8q9/2Pa2JA4yVFtlnn/eYQJJcAkrwWDKvVYV0pNeYCn4XXJ
	 A96p9Nyez/oDi1sxlzwODULgNWhW0d0Ny+61JpDuQPF9OVv12HcwzNQlrki8QImQi2
	 xedmgtqbnxv56Znz8xsOFs2R8oLhNb0tqP/ji4c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tiago=20Martins=20Ara=C3=BAjo?= <tiago.martins.araujo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 508/567] drm/displayid: add quirk to ignore DisplayID checksum errors
Date: Tue,  6 Jan 2026 18:04:50 +0100
Message-ID: <20260106170510.166684060@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 83cbb4d33dc22b0ca1a4e85c6e892c9b729e28d4 ]

Add a mechanism for DisplayID specific quirks, and add the first quirk
to ignore DisplayID section checksum errors.

It would be quite inconvenient to pass existing EDID quirks from
drm_edid.c for DisplayID parsing. Not all places doing DisplayID
iteration have the quirks readily available, and would have to pass it
in all places. Simply add a separate array of DisplayID specific EDID
quirks. We do end up checking it every time we iterate DisplayID blocks,
but hopefully the number of quirks remains small.

There are a few laptop models with DisplayID checksum failures, leading
to higher refresh rates only present in the DisplayID blocks being
ignored. Add a quirk for the panel in the machines.

Reported-by: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Closes: https://lore.kernel.org/r/CACRbrPGvLP5LANXuFi6z0S7XMbAG4X5y2YOLBDxfOVtfGGqiKQ@mail.gmail.com
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14703
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/c04d81ae648c5f21b3f5b7953f924718051f2798.1761681968.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_displayid.c          |   41 +++++++++++++++++++++++++++----
 drivers/gpu/drm/drm_displayid_internal.h |    2 +
 2 files changed, 39 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_displayid.c
+++ b/drivers/gpu/drm/drm_displayid.c
@@ -9,6 +9,34 @@
 #include "drm_crtc_internal.h"
 #include "drm_displayid_internal.h"
 
+enum {
+	QUIRK_IGNORE_CHECKSUM,
+};
+
+struct displayid_quirk {
+	const struct drm_edid_ident ident;
+	u8 quirks;
+};
+
+static const struct displayid_quirk quirks[] = {
+	{
+		.ident = DRM_EDID_IDENT_INIT('C', 'S', 'O', 5142, "MNE007ZA1-5"),
+		.quirks = BIT(QUIRK_IGNORE_CHECKSUM),
+	},
+};
+
+static u8 get_quirks(const struct drm_edid *drm_edid)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(quirks); i++) {
+		if (drm_edid_match(drm_edid, &quirks[i].ident))
+			return quirks[i].quirks;
+	}
+
+	return 0;
+}
+
 static const struct displayid_header *
 displayid_get_header(const u8 *displayid, int length, int index)
 {
@@ -23,7 +51,7 @@ displayid_get_header(const u8 *displayid
 }
 
 static const struct displayid_header *
-validate_displayid(const u8 *displayid, int length, int idx)
+validate_displayid(const u8 *displayid, int length, int idx, bool ignore_checksum)
 {
 	int i, dispid_length;
 	u8 csum = 0;
@@ -41,8 +69,11 @@ validate_displayid(const u8 *displayid,
 	for (i = 0; i < dispid_length; i++)
 		csum += displayid[idx + i];
 	if (csum) {
-		DRM_NOTE("DisplayID checksum invalid, remainder is %d\n", csum);
-		return ERR_PTR(-EINVAL);
+		DRM_NOTE("DisplayID checksum invalid, remainder is %d%s\n", csum,
+			 ignore_checksum ? " (ignoring)" : "");
+
+		if (!ignore_checksum)
+			return ERR_PTR(-EINVAL);
 	}
 
 	return base;
@@ -52,6 +83,7 @@ static const u8 *find_next_displayid_ext
 {
 	const struct displayid_header *base;
 	const u8 *displayid;
+	bool ignore_checksum = iter->quirks & BIT(QUIRK_IGNORE_CHECKSUM);
 
 	displayid = drm_edid_find_extension(iter->drm_edid, DISPLAYID_EXT, &iter->ext_index);
 	if (!displayid)
@@ -61,7 +93,7 @@ static const u8 *find_next_displayid_ext
 	iter->length = EDID_LENGTH - 1;
 	iter->idx = 1;
 
-	base = validate_displayid(displayid, iter->length, iter->idx);
+	base = validate_displayid(displayid, iter->length, iter->idx, ignore_checksum);
 	if (IS_ERR(base))
 		return NULL;
 
@@ -76,6 +108,7 @@ void displayid_iter_edid_begin(const str
 	memset(iter, 0, sizeof(*iter));
 
 	iter->drm_edid = drm_edid;
+	iter->quirks = get_quirks(drm_edid);
 }
 
 static const struct displayid_block *
--- a/drivers/gpu/drm/drm_displayid_internal.h
+++ b/drivers/gpu/drm/drm_displayid_internal.h
@@ -154,6 +154,8 @@ struct displayid_iter {
 
 	u8 version;
 	u8 primary_use;
+
+	u8 quirks;
 };
 
 void displayid_iter_edid_begin(const struct drm_edid *drm_edid,


