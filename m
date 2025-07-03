Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91FB4414;
	Thu,  3 Jul 2025 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554992; cv=none; b=g3K1vQ3iow5pt+ZLYErVGEk+C5EzDkVdhVXYlIhT1A+y1hxApwQaTPNgxA6rzkQ3xQfo2Zc7AreobY2nCryiNoY7vX7BULjDhsMKJ1ufRwwwp72qtdPoH2v9wTgBUYLn3Pf2y8teGdH/uGnj9PaCwYQC3akOHsO5uPo1of0KqNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554992; c=relaxed/simple;
	bh=xDvHmN0qQEjD3sE3ED6bcqyfgPVp8inPGkASmCDCXEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiX5m/xpUhZnZqe1aejKVo46N44PBWUElG3/lvdkoKzHc5+TnZ/5v0oanpv4ITGFNZGx94f5teFOgCrWsmvXZpe3ufbohYXt4+gNvwir1kvpMKSvDp+tGJMsgitysKdvA1JfHqNByDhu+DXyntjsmtuZIejDrNaR6b3QrgTz7KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LfsubLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LfsubLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E32C4CEE3;
	Thu,  3 Jul 2025 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554992;
	bh=xDvHmN0qQEjD3sE3ED6bcqyfgPVp8inPGkASmCDCXEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LfsubLeW1CLvpaZJkRsEHFe/PahEuoX8sMtlTP2CVALofDKK7DMzf9D6toEOxLE0
	 cvzCjkKN7cSyH94Suk4QWuCEGJqi8D1IcxCw8lRRjkE1IAXChVGE4iaeM7s6lL7S8h
	 xf/nIuCbHo+/0ACUy0VKShT3NBT0OWW4i1wfPb4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 125/263] drm/amd/display: Add sanity checks for drm_edid_raw()
Date: Thu,  3 Jul 2025 16:40:45 +0200
Message-ID: <20250703144009.367200581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 6847b3b6e84ef37451c074e6a8db3fbd250c8dbf upstream.

When EDID is retrieved via drm_edid_raw(), it doesn't guarantee to
return proper EDID bytes the caller wants: it may be either NULL (that
leads to an Oops) or with too long bytes over the fixed size raw_edid
array (that may lead to memory corruption).  The latter was reported
actually when connected with a bad adapter.

Add sanity checks for drm_edid_raw() to address the above corner
cases, and return EDID_BAD_INPUT accordingly.

Fixes: 48edb2a4256e ("drm/amd/display: switch amdgpu_dm_connector to use struct drm_edid")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1236415
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 648d3f4d209725d51900d6a3ed46b7b600140cdf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -1016,6 +1016,10 @@ enum dc_edid_status dm_helpers_read_loca
 			return EDID_NO_RESPONSE;
 
 		edid = drm_edid_raw(drm_edid); // FIXME: Get rid of drm_edid_raw()
+		if (!edid ||
+		    edid->extensions >= sizeof(sink->dc_edid.raw_edid) / EDID_LENGTH)
+			return EDID_BAD_INPUT;
+
 		sink->dc_edid.length = EDID_LENGTH * (edid->extensions + 1);
 		memmove(sink->dc_edid.raw_edid, (uint8_t *)edid, sink->dc_edid.length);
 


