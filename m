Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBBF3B6366;
	Thu, 30 Jul 2026 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424364; cv=none; b=julGbSsWhL6ngpmgLZxwkzgGIlkOSJjixhXB5nYuxhwhzdFIuU9F5dtNitvBEXRaDNSedRl2Wn4xgUj+EQ1UTScaxMp+feuuKRIp8kprUUtWYBbYmOpPgmOz9fVdWT2sCk5I7aiPoI/gQ6zboXBg1f5NgItz/tqgSFp17qSgo8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424364; c=relaxed/simple;
	bh=DVQf8/RR70XNBRijlsscRxFtuHXyuv9u8q7MXSsJQ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0qL61tltlweGdvbFwL3soP1NjLJ11iuoQ+RVmCTbC0oeWZJ909K9glvkDERWALgHhCcAgs2OaZLHeSnYta975KeWYl8yy3fqABX4Ls8aat2CUrdjXXpY2wGecTBGBjFHYt8bBCYBh8OCt1AJsTQiGKnCK8MdIHlWe1yPMrxSCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sM2Ye/md; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sM2Ye/md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EFB1F000E9;
	Thu, 30 Jul 2026 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424361;
	bh=msGSjqgVE+gmp+ErOQkNEfDHovYGjNnbxor+cnqt9h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sM2Ye/mdEf9eNH6NggB320vW0GG+8La1iqM1WMC+XCo+lMDB3IGY3kfiyAqLEZKxF
	 Fp7yPpIubk7YihkBGUYj0jrHLcqyOKJFloqRVTGgHvT6kntQf/ssBUFnp2RwYcMP2q
	 OTIMhy4xK7+u9II3BClLqGiVT3uLtwJ8fssJYMOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 360/675] drm/i915/hdcp: check streams[] bounds before overflow
Date: Thu, 30 Jul 2026 16:11:30 +0200
Message-ID: <20260730141452.783243737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit bbb15a6b042d02e5508a02b4847e02d2579ee7bc upstream.

The data->streams[] overflow check is done after the buffer overflow has
already happened. Move the overflow check before the write.

Side note, emitting a warning splat with a backtrace might be overkill
here, but prefer not changing the behaviour other than not doing the
overrun.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: e03187e12cae ("drm/i915/hdcp: MST streams support in hdcp port_data")
Cc: stable@vger.kernel.org # v5.12+
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260625170304.1104723-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 9284ab3b6e776c315883ac2611283d263c9460fd)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -140,6 +140,9 @@ intel_hdcp_required_content_stream(struc
 		if (conn_dig_port != dig_port)
 			continue;
 
+		if (drm_WARN_ON(display->drm, data->k >= INTEL_NUM_PIPES(display)))
+			return -EINVAL;
+
 		data->streams[data->k].stream_id =
 			intel_conn_to_vcpi(state, connector);
 		data->k++;
@@ -150,7 +153,7 @@ intel_hdcp_required_content_stream(struc
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (drm_WARN_ON(display->drm, data->k > INTEL_NUM_PIPES(display) || data->k == 0))
+	if (drm_WARN_ON(display->drm, !data->k))
 		return -EINVAL;
 
 	/*


