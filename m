Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A0A377A82;
	Thu, 20 Aug 2026 16:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244053; cv=none; b=eveYAJhaPIpvjFfVf1ZSTmlRApa5oOSKDs2cWnnlOtaQl3phcc7f/n/PYlhXyhVeA9UK7GwclqoPlWMF2iZvataNKMTfM8Se3yFRkgvlLy4c7HkZYN+EmuchncN8YadjzurzCJ5cXOSjF8EsZaE6sB3MQPoSxSkMxQ5VPHXLO2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244053; c=relaxed/simple;
	bh=FhCJXr1bk7/drz7gPd0FD5tKCbEZ/PcUru9XkknIgVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ/QtiANcTd1riTgsfOrXsZKWXw9XP0/72fSgOLviId6wzGRtvGlcHyXfbjmW7wGvirrlei8Z7VGRnx6ssONgLLXx/QrrlQkGoCQIoPHWKULNg6xHZgyq0phxqZxVrmjsboE2lY5Zl44w6vbk4guUZi31ZiRzCqMP1mzAiS2ii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7lwHts2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7lwHts2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606001F000E9;
	Thu, 20 Aug 2026 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244051;
	bh=ZiAOFY5MpIb4MZQ0cgg93EWJkNl+c3irc4+Qm565+EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7lwHts23Dwccy+jFWcifxgO1wAnPy9UPWkHMJwMufykdjQgikBi/HztzHQ/13tRh
	 rcP8rJDFBsaA0cvM4styClMoQZKH9Fdjd9gFINHlHzCKlJKqath4TXmaZzCm+EK0FX
	 mqw0hUUfArNnKruXFMBQl2idgO6tOwLxubvxq1Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 035/235] drm/amdgpu: Reject UVD message with invalid number of h265 refs
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145217.496107801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 9fca434208f1f9ab977feac62df8ebb1cc7ce893 upstream.

Same change as for h264, avoids overflow later when calculating
min dpb size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a4b0720e4f1601f97f59a2be9c1b4b94fa6527d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -715,6 +715,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		image_size = ALIGN(image_size, 256);
 
 		num_dpb_buffer = (le32_to_cpu(msg[59]) & 0xff) + 2;
+		if (num_dpb_buffer > 17)
+			return -EINVAL;
+
 		min_dpb_size = image_size * num_dpb_buffer;
 		min_ctx_size = ((width + 255) / 16) * ((height + 255) / 16)
 					   * 16 * num_dpb_buffer + 52 * 1024;


