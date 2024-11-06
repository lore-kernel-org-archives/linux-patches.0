Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54BB1E048C;
	Wed,  6 Nov 2024 12:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896513; cv=none; b=JXZA4qAGAZfwflFQBTEaZOUKwrEW7x+90/EJjCp+6z55OpMfZVDhcI5Sh3xJbYI3ItvNhYIS4yJop7lYsiHC7vM8REZ+a1vC0oP40cSDkFQixqyG1HmPrW48Lo8KjsTI6MYmgplJlewJbwveJ8bJf/ME1joNvwb78jOsmSgIhiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896513; c=relaxed/simple;
	bh=GyV1BA0+W3C69h0J+cqdTkAoRc2eiJIsrKnsHaJsi0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhL2UtsF0idLQbzXlwPtduf2BRoK1wYHPpFlnkO/d5+aEw8Y/DO/iVbxWU83UQFCzz9C8vR5N4+G0uKeewfhrR++CznDWnnLVH0klZzfj7KltakwxZ5yjf5hW14hET6cMs0HlLLZF6+Murq8qabxbSRieHNMGXFYasLhoQYTyvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=103Yauol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="103Yauol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24065C4CECD;
	Wed,  6 Nov 2024 12:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896513;
	bh=GyV1BA0+W3C69h0J+cqdTkAoRc2eiJIsrKnsHaJsi0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=103Yauol3TEkEa9XuWBzj4zJoU3KZVML3/mjnv3djltZjzWoXZ/icOCBliYF+E311
	 qecg2BmWAn7GhbXaKEIAu9C2JPJYA4+BPz6z7W3DvvH77dr64X4ywqgTl1YLac+OVb
	 MuitnaE9+IXxm14LnkHeCATOfHs4reVM86k9o5Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 226/245] drm/i915/hdcp: Add encoder check in hdcp2_get_capability
Date: Wed,  6 Nov 2024 13:04:39 +0100
Message-ID: <20241106120324.824360777@linuxfoundation.org>
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

commit d34f4f058edf1235c103ca9c921dc54820d14d40 upstream.

Add encoder check in intel_hdcp2_get_capability to avoid
null pointer error.

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722064451.3610512-3-suraj.kandpal@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_hdcp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_hdcp.c
@@ -677,8 +677,15 @@ static
 int intel_dp_hdcp2_get_capability(struct intel_connector *connector,
 				  bool *capable)
 {
-	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
-	struct drm_dp_aux *aux = &dig_port->dp.aux;
+	struct intel_digital_port *dig_port;
+	struct drm_dp_aux *aux;
+
+	*capable = false;
+	if (!intel_attached_encoder(connector))
+		return -EINVAL;
+
+	dig_port = intel_attached_dig_port(connector);
+	aux = &dig_port->dp.aux;
 
 	return _intel_dp_hdcp2_get_capability(aux, capable);
 }


