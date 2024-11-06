Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5531E048F;
	Wed,  6 Nov 2024 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896510; cv=none; b=BU4OXPwSqw5URLmO2uzbX1xL8fVUyIj2vcJJMRxIG7J/7ZNxIK1sFER6ba9DKZmk+CmGlIQChwPK4yity9qe7/fIC6pUEVSU7OlxXcqfB7rws/64rBCzlTK8ugzxAXIC/576m0xywnpklLaA1ISs8cskvFotwB80NCIG8Kh4a3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896510; c=relaxed/simple;
	bh=yHbHfN06+SgUoFeWueIl4Q7OoRVWy8VqT/6F27SuMIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seQD3t5Yb2hLYkE1SJYch7jrtufg41556GUgRs+pJA6f+UHUzUzcCdvivcDBGmjACCpsLGcSWQx+agHeBm+jLv6juMo1QCg6w2FnV2R7g6g/Izf94TMcTPcoN9MMzGlIVcGWm4Ll3Ue/05SUF+HMInCu8b/4pX1baYflyx40okI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCw04Rq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCw04Rq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CCDC4CECD;
	Wed,  6 Nov 2024 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896510;
	bh=yHbHfN06+SgUoFeWueIl4Q7OoRVWy8VqT/6F27SuMIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCw04Rq3/jvA3+X2pcMBHf7JImlTjmNBDHUftYumABQ0f5cfk+QAVAPIbQ5U6xpnv
	 FCGupFCa8TVGYXyFGhpgK+JcXKDVIzpH+OiUUBBnYaOQXWw4azKsAMtnVtFUWOhur2
	 OTDoihkYNexQ855xASVon2+NkCClMG3ESGAXl4VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 225/245] drm/i915/hdcp: Add encoder check in intel_hdcp_get_capability
Date: Wed,  6 Nov 2024 13:04:38 +0100
Message-ID: <20241106120324.798588015@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit 31b42af516afa1e184d1a9f9dd4096c54044269a upstream.

Sometimes during hotplug scenario or suspend/resume scenario encoder is
not always initialized when intel_hdcp_get_capability add
a check to avoid kernel null pointer dereference.

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722064451.3610512-2-suraj.kandpal@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -203,11 +203,16 @@ int intel_hdcp_read_valid_bksv(struct in
 /* Is HDCP1.4 capable on Platform and Sink */
 bool intel_hdcp_get_capability(struct intel_connector *connector)
 {
-	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
+	struct intel_digital_port *dig_port;
 	const struct intel_hdcp_shim *shim = connector->hdcp.shim;
 	bool capable = false;
 	u8 bksv[5];
 
+	if (!intel_attached_encoder(connector))
+		return capable;
+
+	dig_port = intel_attached_dig_port(connector);
+
 	if (!shim)
 		return capable;
 


