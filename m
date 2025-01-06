Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CE513AD20;
	Mon,  6 Jan 2025 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178776; cv=none; b=WFlJyumJI71XIMPrCW2pX6pr5AHmDPYdzn15yQde9Q3tnOTRTW5BAV0ANkyWxpdum2HI6WEOPHXUc79mhzMHf960ygRtTMMD5kqOL8tQyXIW7G8euqD6IaY1/oxNUqk/4/eIARHHcMDu/BH4ViaLVylH3ryh7RgGBL6gay1AFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178776; c=relaxed/simple;
	bh=guSrVGcQkIDqj0p9gBXU47BT0HS9xiQfb5U5N7UdV0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cwe8/yYaXI1pMmhPTUDILDl0OU3S3GS/MDZepZOb0b7+ty2ebIXXbZh0tv4imHfwe1rmfgxWIKML6cXJW0rqbvJ+hQZ8XYchmIXODBxV7tArk5ZRkW3uTHbWjPZGvsQTmPER/zcoE71lBaqReDxfN/QXnmcReM+pe55EvFly6jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWqGAlvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWqGAlvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F9CC4CED2;
	Mon,  6 Jan 2025 15:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178776;
	bh=guSrVGcQkIDqj0p9gBXU47BT0HS9xiQfb5U5N7UdV0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWqGAlvq+aF7CavJjOb2kxbjOijW7TwYT8fa9VaKstpzA4snHbMXCtDgeDhTtx+y0
	 WmyzUAQrrqRVfUjJ8iDMoWFWdGFwpiNsc51+r1mqSrbnB/TSlDlND+rrVG7sam/Vw5
	 vpijXoJQ1N9n50NX2GbgEJXgNhCH49xlGhg8Kzcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/168] drm/dp_mst: Fix MST sideband message body length check
Date: Mon,  6 Jan 2025 16:16:36 +0100
Message-ID: <20250106151141.786278643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit bd2fccac61b40eaf08d9546acc9fef958bfe4763 ]

Fix the MST sideband message body length check, which must be at least 1
byte accounting for the message body CRC (aka message data CRC) at the
end of the message.

This fixes a case where an MST branch device returns a header with a
correct header CRC (indicating a correctly received body length), with
the body length being incorrectly set to 0. This will later lead to a
memory corruption in drm_dp_sideband_append_payload() and the following
errors in dmesg:

   UBSAN: array-index-out-of-bounds in drivers/gpu/drm/display/drm_dp_mst_topology.c:786:25
   index -1 is out of range for type 'u8 [48]'
   Call Trace:
    drm_dp_sideband_append_payload+0x33d/0x350 [drm_display_helper]
    drm_dp_get_one_sb_msg+0x3ce/0x5f0 [drm_display_helper]
    drm_dp_mst_hpd_irq_handle_event+0xc8/0x1580 [drm_display_helper]

   memcpy: detected field-spanning write (size 18446744073709551615) of single field "&msg->msg[msg->curlen]" at drivers/gpu/drm/display/drm_dp_mst_topology.c:791 (size 256)
   Call Trace:
    drm_dp_sideband_append_payload+0x324/0x350 [drm_display_helper]
    drm_dp_get_one_sb_msg+0x3ce/0x5f0 [drm_display_helper]
    drm_dp_mst_hpd_irq_handle_event+0xc8/0x1580 [drm_display_helper]

Cc: <stable@vger.kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241125205314.1725887-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index f24667a003a2..f72b4ff169a8 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -319,6 +319,9 @@ static bool drm_dp_decode_sideband_msg_hdr(const struct drm_dp_mst_topology_mgr
 	hdr->broadcast = (buf[idx] >> 7) & 0x1;
 	hdr->path_msg = (buf[idx] >> 6) & 0x1;
 	hdr->msg_len = buf[idx] & 0x3f;
+	if (hdr->msg_len < 1)		/* min space for body CRC */
+		return false;
+
 	idx++;
 	hdr->somt = (buf[idx] >> 7) & 0x1;
 	hdr->eomt = (buf[idx] >> 6) & 0x1;
-- 
2.39.5



