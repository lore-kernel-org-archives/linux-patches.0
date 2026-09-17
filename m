Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E84F4E780E;
	Thu, 17 Sep 2026 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660132; cv=none; b=fLYwXyb5B4ok3cASQ1spWNmjGEbdUvyf0TjT0bqGM1qRGs9XfXvIpVVgH1d8zbeZwsanH07wTCPk/CA4Gy4tSrGz9fZkBztKpW5Rx0pUjb7D9cweQOu9H+hmD0pK1/ShlQ1XNbyRGaaLOQt87XkgQyVAYYmOu7UPb3z2R9lR8f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660132; c=relaxed/simple;
	bh=ESNTdHK23fIE40czIxDLelwDafJkG3QQQjKXad9dGB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljTSl6dCBqDII7NlKEVGSO89peCSAIscRBYaiBSteV35e3ikF6oESQjhpwP4QhevVtYLzcMtTHIAOSeWG+Zfoi2XZBX80N3DIcr8qMzNt4qews2NZaiaJMqduogup1MuImQtQd/dsmN0UMtW48LofWHl9aFocaYT9bzX/OhZH9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmIfFo+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmIfFo+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCECB1F00899;
	Thu, 17 Sep 2026 15:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660124;
	bh=iV4CBgQHA9y32iOD9d4Ncjd6AC9t8f11msAv0xXfopg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmIfFo+hOr1q1na4k1Djs8qkaZCRXgvSnaG6RW9ENJ/3+bM4/cUbl9yV77fRyrFfX
	 PPEedRsFuZbYVjljKkDf6hecVo1HPeLS7jnWbvkSKhDmiVuZ9DoqmKibebGOE7NqUI
	 L0E7ENnwsW/4QunKgwSlrW98pcJ0LI+ctJnU5FwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 486/733] dm/amdgpu: fix malformed link_settings debugfs output
Date: Thu, 17 Sep 2026 16:13:14 +0100
Message-ID: <20260917151404.150537930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit 622b4e8505aa7453a53d17fa3a288871f270fc8b upstream.

[Why]
dp_link_settings_read() passed strlen() of each format string as the size
argument to snprintf() and then advanced rd_buf_ptr by that same fixed amount.
The format-string length has no relation to the formatted output length, so
snprintf() truncated each field at a NUL it wrote inside the buffer while the
pointer was advanced past it. The result is a buffer peppered with embedded NUL
bytes and fields that are silently cut short, so the data read back from the
debugfs node does not reflect the actual link settings.

[How]
Use scnprintf() with the real remaining buffer size
(rd_buf_size - (rd_buf_ptr - rd_buf)) and advance rd_buf_ptr by its return
value, which is the number of characters actually written. This both bounds
each write to the space left in rd_buf and keeps the output a single,
properly terminated string. The now-unused str_len local is removed.

Fixes: 41db5f1931ec ("drm/amd/display: set-read link rate and lane count through debugfs")
Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 43b9f0f18693c7f7b75613f3aeae25fa2b4e2f76)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |   20 +++++---------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -196,7 +196,6 @@ static ssize_t dp_link_settings_read(str
 	char *rd_buf_ptr = NULL;
 	const uint32_t rd_buf_size = 100;
 	uint32_t result = 0;
-	uint8_t str_len = 0;
 	int r;
 
 	if (*pos & 3 || size & 3)
@@ -208,29 +207,26 @@ static ssize_t dp_link_settings_read(str
 
 	rd_buf_ptr = rd_buf;
 
-	str_len = strlen("Current:  %d  0x%x  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Current:  %d  0x%x  %d  ",
+	rd_buf_ptr += scnprintf(rd_buf_ptr, rd_buf_size - (rd_buf_ptr - rd_buf),
+			"Current:  %d  0x%x  %d  ",
 			link->cur_link_settings.lane_count,
 			link->cur_link_settings.link_rate,
 			link->cur_link_settings.link_spread);
-	rd_buf_ptr += str_len;
 
-	str_len = strlen("Verified:  %d  0x%x  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Verified:  %d  0x%x  %d  ",
+	rd_buf_ptr += scnprintf(rd_buf_ptr, rd_buf_size - (rd_buf_ptr - rd_buf),
+			"Verified:  %d  0x%x  %d  ",
 			link->verified_link_cap.lane_count,
 			link->verified_link_cap.link_rate,
 			link->verified_link_cap.link_spread);
-	rd_buf_ptr += str_len;
 
-	str_len = strlen("Reported:  %d  0x%x  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Reported:  %d  0x%x  %d  ",
+	rd_buf_ptr += scnprintf(rd_buf_ptr, rd_buf_size - (rd_buf_ptr - rd_buf),
+			"Reported:  %d  0x%x  %d  ",
 			link->reported_link_cap.lane_count,
 			link->reported_link_cap.link_rate,
 			link->reported_link_cap.link_spread);
-	rd_buf_ptr += str_len;
 
-	str_len = strlen("Preferred:  %d  0x%x  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Preferred:  %d  0x%x  %d\n",
+	rd_buf_ptr += scnprintf(rd_buf_ptr, rd_buf_size - (rd_buf_ptr - rd_buf),
+			"Preferred:  %d  0x%x  %d\n",
 			link->preferred_link_setting.lane_count,
 			link->preferred_link_setting.link_rate,
 			link->preferred_link_setting.link_spread);


