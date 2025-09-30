Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3392F9D9E;
	Tue, 30 Sep 2025 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244816; cv=none; b=hPHmki6VNAODOOJF9l6DDxKy2RXN7KubAv4ODfAbQgnEg9xkgJ/L+2UJwKJNy70Zz7yAqorKUGZ92TL47qWD2nqmP5llMkpoaCtASYONwUo6tFrgrPCZnhmUGEpnPLHp1t3EoYlAkRyl8cj9N+QYWAli/rBXklfU7kpYnojgz4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244816; c=relaxed/simple;
	bh=Ib7EsOT7P/yp/UoGfNXwlJOdz643++wO6DOV6qQvX6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OClteLatNfxvhpGScD1Az7RYL2ZYmS6exLURRajUtBGUMuM3UdYLBFpX8e10R1wdynD5sg7lPNO41sRDNHxNXiErEOB3ftCg1NTWMy4BNueCA6VMXiUu+QacJ/4Zp/cv+ah0427OPkiabJlQsJ5eudU0iZbFtjSm6qL6BsyOhoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w071OgUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w071OgUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BA0C116B1;
	Tue, 30 Sep 2025 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244815;
	bh=Ib7EsOT7P/yp/UoGfNXwlJOdz643++wO6DOV6qQvX6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w071OgURaumAWxZAaC3b1wa2iZBHLLw3fO1p8ET+pmBVlUEs7ad6qMeKf1128A3PZ
	 /Xn+lPQyjF+yVH9Fy/vXwUQSViVmLmfz2N3KTvN1MiYlJz+xxcL3yfUgV8kn8o+DLy
	 WjESDzlZmeHXorVGu/BSRqmdVay3+bobR1Gj/Oq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 091/143] drm/i915/ddi: Guard reg_val against a INVALID_TRANSCODER
Date: Tue, 30 Sep 2025 16:46:55 +0200
Message-ID: <20250930143834.855878350@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 7f97a0a871d9532f2e1a5ee7d16d0e364215bcac ]

Currently we check if the encoder is INVALID or -1 and throw a
WARN_ON but we still end up writing the temp value which will
overflow and corrupt the whole programmed value.

--v2
-Assign a bogus transcoder to master in case we get a INVALID
TRANSCODER [Jani]

Fixes: 6671c367a9bea ("drm/i915/tgl: Select master transcoder for MST stream")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://lore.kernel.org/r/20250908042208.1011144-1-suraj.kandpal@intel.com
(cherry picked from commit c8e8e9ab14a6ea926641d161768e1e3ef286a853)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index d58f8fc373265..55b8bfcf364ae 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -593,8 +593,9 @@ intel_ddi_transcoder_func_reg_val_get(struct intel_encoder *encoder,
 			enum transcoder master;
 
 			master = crtc_state->mst_master_transcoder;
-			drm_WARN_ON(display->drm,
-				    master == INVALID_TRANSCODER);
+			if (drm_WARN_ON(display->drm,
+					master == INVALID_TRANSCODER))
+				master = TRANSCODER_A;
 			temp |= TRANS_DDI_MST_TRANSPORT_SELECT(master);
 		}
 	} else {
-- 
2.51.0



