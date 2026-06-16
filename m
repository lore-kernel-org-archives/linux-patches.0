Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716AC3C3C1E;
	Tue, 16 Jun 2026 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631979; cv=none; b=lRiQnAZaN+tfMHk4YRm86B4qyRt6esdmGe7DuWqb5hXIdy6XJqIjbf4NawTsDvJ+kRa0ATmQgbrcmEsmnAlJ2aXFIpIEn+F29ruMh8ClZT+EE/crapqwFlF1s8ZhDV0E6pmM37G9A4vEAAaSkw+s0G1sCK4Jw9yUMtP4P0eG1D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631979; c=relaxed/simple;
	bh=95KUR8MjpssyEDorr5ALAkaA/HxFAerYMsplIR7IqlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWr3wrhI0RKFJZhCOOHp5deXvUSXWDEDKUIklzbdHvk53oMLrDVBX/TsLOcp2oWqukB6n6SG54QxM4OoD9HtPK0iMYoKOIWyZzbT+LlLe+sJGSiGbUAoylv0upMlSVVN2RM6vjt3GMslLGVx59mxHcILoVyFgUa7f0FwAwJ47W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/E1Y4Lg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/E1Y4Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEFE1F00A3A;
	Tue, 16 Jun 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631978;
	bh=V/Y+1UVBL/5EpcHc4Pt4MB2Ix34Ey0iwua9eaU6pnnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/E1Y4LghbP64WlKMdlz7RhAMKTBfShMm7Rdo+FiyTnJUt4Ma0C/Emfd9khecXUs2
	 fxy7OfeyjAea13l22jfS7HudE+vCEyWonT/m291cgZpOPUqC79u0jgS6dBrE4eDwzF
	 GmGR/5a9Pb0Jx4Anb3tH037uh77hIkncuqVEdrK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 323/522] drm/amd/display: Clamp HDMI HDCP2 rx_id_list read to buffer size
Date: Tue, 16 Jun 2026 20:27:50 +0530
Message-ID: <20260616145140.958690263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit f0f3981c43b32cadfe373d636d9e9ca522bb3702 upstream.

[Why & How]
During HDCP 2.x repeater authentication over HDMI, the driver reads the
sink's RxStatus register and extracts a 10-bit message size field (max
value 1023). This value is used as the read length for the ReceiverID
list without being clamped to the size of the destination buffer
rx_id_list[177]. A malicious HDMI repeater could advertise a message
size larger than the buffer, causing an out-of-bounds write during the
I2C read.

Clamp the read length in mod_hdcp_read_rx_id_list() to the size of the
rx_id_list buffer, matching the approach already used in the DP branch.

Fixes: eff682f83c9c ("drm/amd/display: Add DDC handles for HDCP2.2")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 229212219e4247d9486f8ba41ef087358490be09)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -533,7 +533,8 @@ enum mod_hdcp_status mod_hdcp_read_rx_id
 	} else {
 		status = read(hdcp, MOD_HDCP_MESSAGE_ID_READ_REPEATER_AUTH_SEND_RECEIVERID_LIST,
 				hdcp->auth.msg.hdcp2.rx_id_list,
-				hdcp->auth.msg.hdcp2.rx_id_list_size);
+				MIN(hdcp->auth.msg.hdcp2.rx_id_list_size,
+				    sizeof(hdcp->auth.msg.hdcp2.rx_id_list)));
 	}
 	return status;
 }


