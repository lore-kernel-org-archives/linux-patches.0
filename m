Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1C9450915;
	Tue, 16 Jun 2026 15:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624520; cv=none; b=TA6wyK+4YZ8mXJMxtdzGdsDiIpRkBIScoHi5Z3eZmahT9h5Qai2sbOiOXuc4oTAFXvDna4OrEUeTPC07ZZ2URqQMbWw5c5AMAZAx3jjaJd3gmlBQNlXeJvqXu/r3M4e6ViBkxx3af/4JDzl5vEgsnQ5IBq0Vk/65lthPFAy6vsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624520; c=relaxed/simple;
	bh=eNDqILKCYeCYthEZAAtj/3oaGF1hsgw9+ulzFc8w/Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4AC0GDN4vkji6Uw6lNKCX3DOxt+JQ7PFw9wfBpL+s+ikcoNenIPwsBan8g5KKS7YaGmI9kN/U8FNsqqLjNlHSwzsE+K3tU15zujZWXiXtDcjX8uAES8BVeeMLFYiBMgDzNbURBKJQweQqUEIopdP0ItZGeQVTzAKO8gQoK+khY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qA9YDgcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qA9YDgcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEFD1F000E9;
	Tue, 16 Jun 2026 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624519;
	bh=YQ/QwdFue0H/ns9a1YzaetghPB2bRmQqEiWkdRwkcqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qA9YDgcI+gB3Vft+kPgtoWN0WA0C8uFPwGDwhOjkOvgUPdxdvk05UJXTw0L34OtbL
	 eRKEj6IlX1RLpd78k8WDIOf1ylaDjJQp6zE0vr6OavPJjVkXUWYdbSoxi1UXoxPUtQ
	 8DtO5sjMa0A3fLtYA6W/UzuOt2y3cYB2tggkp79E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 353/378] drm/amd/display: Clamp HDMI HDCP2 rx_id_list read to buffer size
Date: Tue, 16 Jun 2026 20:29:44 +0530
Message-ID: <20260616145128.724887505@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -529,7 +529,8 @@ enum mod_hdcp_status mod_hdcp_read_rx_id
 	} else {
 		status = read(hdcp, MOD_HDCP_MESSAGE_ID_READ_REPEATER_AUTH_SEND_RECEIVERID_LIST,
 				hdcp->auth.msg.hdcp2.rx_id_list,
-				hdcp->auth.msg.hdcp2.rx_id_list_size);
+				MIN(hdcp->auth.msg.hdcp2.rx_id_list_size,
+				    sizeof(hdcp->auth.msg.hdcp2.rx_id_list)));
 	}
 	return status;
 }


