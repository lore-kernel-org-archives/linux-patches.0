Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C52213127;
	Tue, 12 Nov 2024 10:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408243; cv=none; b=Vj3UN66ldbeyUkrUMBO+L+qZd4P+g1BzxAxYi3dnk2SpwReUb3bErYONJnbTuiHX64+g3ThXLZq4oHRSHzlN/ZDCEkyi1jCoUajcpcfjlQ66VcZiO+yFXSEfO4QbjC5VMFzsGJMQEQrMC0j8vapxFWkknOYtWaMLpleEpHmX3qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408243; c=relaxed/simple;
	bh=32FkEhIbrlOzsPWIk8UMOG4a152fL+7yGAv9LdVmkWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiCUwKQoJgYmd2an8hjL2gkPIG2meO4XQRnj00igmw+tlvT4dbqyV1DQxCEleywQYHWhYxpxpBwlSFKrGdGVAZPY6SvJYs6862GRruBz14JVHOA5EdujJxZeRrpoZSkAW5zvAbtrcbC8gH4TvMGrM/63GNptnkN4mSZtYEc6b5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpuKQQVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpuKQQVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6684EC4CED6;
	Tue, 12 Nov 2024 10:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408242;
	bh=32FkEhIbrlOzsPWIk8UMOG4a152fL+7yGAv9LdVmkWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpuKQQVETBqYtbcKakOaE3re9BvBaVQZhjjGFS6Rbj3m1nLowSGcdyDkoaZjpvxoS
	 I+3a1/MgSafS/+9IsmSxwetvD/9hnRGtsSQZacF9P1ulVJg2ZMXgNlv84aKWun28iO
	 WtsaeRO2uVb5JMhPY9sjwgFu+GQMItjs0taMpPOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 104/184] drm/amd/display: parse umc_info or vram_info based on ASIC
Date: Tue, 12 Nov 2024 11:21:02 +0100
Message-ID: <20241112101904.856095261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 694c79769cb384bca8b1ec1d1e84156e726bd106 upstream.

An upstream bug report suggests that there are production dGPUs that are
older than DCN401 but still have a umc_info in VBIOS tables with the
same version as expected for a DCN401 product. Hence, reading this
tables should be guarded with a version check.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3678
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2551b4a321a68134360b860113dd460133e856e5)
Fixes: 00c391102abc ("drm/amd/display: Add misc DC changes for DCN401")
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index 0d8498ab9b23..be8fbb04ad98 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -3127,7 +3127,9 @@ static enum bp_result bios_parser_get_vram_info(
 	struct atom_data_revision revision;
 
 	// vram info moved to umc_info for DCN4x
-	if (info && DATA_TABLES(umc_info)) {
+	if (dcb->ctx->dce_version >= DCN_VERSION_4_01 &&
+		dcb->ctx->dce_version < DCN_VERSION_MAX &&
+		info && DATA_TABLES(umc_info)) {
 		header = GET_IMAGE(struct atom_common_table_header,
 					DATA_TABLES(umc_info));
 
-- 
2.47.0



