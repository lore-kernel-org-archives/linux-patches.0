Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE0238389;
	Thu, 13 Feb 2025 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458937; cv=none; b=AnYykWSlmDNhAYOiEAN7xpTEIqJjvnvC+4Fc/Jh35Cko2rraPI+V42AcyrHiVgM+UgcjNAoZx6roiLVbrB6XtD/ZuQfJdEf0i2FtKXMZFHD0bBLYh5Q0FwwAYHhDyVKv1NYGMYtbQ//pew0BSMh7H5ijLb6PwDPwfnuK9H4spiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458937; c=relaxed/simple;
	bh=QiBfHnwKvCboGlXs89ZxY3Cq8jVs0jHtgJtA+75CtyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbPAKnWQaQxl6LuMaDrTlSz3+0Tk/viBWUIaOM0B+IKrakeCzRqxpVS3YH6mgkNvkP5gGn4gQtR+xs75wCttyJkKhW1kTZrQupOFiHo3ackZbBRUEPaNsCesZbT02Ms4K0c+YYiyBFjzU45rYClhO0x9pov4EtKZi8qPMzllLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUu+mv3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUu+mv3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D1FC4CED1;
	Thu, 13 Feb 2025 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458936;
	bh=QiBfHnwKvCboGlXs89ZxY3Cq8jVs0jHtgJtA+75CtyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUu+mv3qktArHSFlZLZIs3xnje4sA4vAvA3qB7GCGl7iT2I/6LVrMc2fB09xUKRIm
	 oMls4Drk9JZYlU+xwwOmaMUNZAvg8o5lMJV028HvCqoWT1+eLr041dm7kIUcpbSxoO
	 O/woFn2HkXxc3LwKvufeYlnYVOkNaBZ/W5bdPfHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 120/443] drm/i915/hdcp: Fix Repeater authentication during topology change
Date: Thu, 13 Feb 2025 15:24:45 +0100
Message-ID: <20250213142445.243618670@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 448060463198924c0a485e7e1622fa8a9c03cf3e ]

When topology changes, before beginning a new HDCP authentication by
sending AKE_init message we need to first authenticate only the
repeater. Only after repeater authentication failure, it makes sense
to start a new HDCP authentication. Even though it made sense to not
enable HDCP directly from check_link and schedule it for later, repeater
authentication needs to be done immediately.

--v2
-Fix comment grammatical errors [Ankit]

Fixes: 47ef55a8b784 ("drm/i915/hdcp: Don't enable HDCP2.2 directly from check_link")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241217083723.2883317-1-suraj.kandpal@intel.com
(cherry picked from commit 605a33e765890e4f1345315afc25268d4ae0fb7c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 8fee26d791f4f..3bf42871a4f08 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -2180,6 +2180,19 @@ static int intel_hdcp2_check_link(struct intel_connector *connector)
 
 		drm_dbg_kms(display->drm,
 			    "HDCP2.2 Downstream topology change\n");
+
+		ret = hdcp2_authenticate_repeater_topology(connector);
+		if (!ret) {
+			intel_hdcp_update_value(connector,
+						DRM_MODE_CONTENT_PROTECTION_ENABLED,
+						true);
+			goto out;
+		}
+
+		drm_dbg_kms(display->drm,
+			    "[CONNECTOR:%d:%s] Repeater topology auth failed.(%d)\n",
+			    connector->base.base.id, connector->base.name,
+			    ret);
 	} else {
 		drm_dbg_kms(display->drm,
 			    "[CONNECTOR:%d:%s] HDCP2.2 link failed, retrying auth\n",
-- 
2.39.5



