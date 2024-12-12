Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F012C2144C0;
	Thu, 12 Dec 2024 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021023; cv=none; b=ZxFQ+nI6Gx3rv9txqt3qb139B7W9NAauJ/mqyyZvYlARhh1GpIOYBYzz4mhhAnDO4a7dgCHqbLhoMP22KumtzcfHcGzJQf/hFQIjpQYwWbWnijvp6Tmqzv40F056NVYNwSmSlw1SnDUhk86Lmfg9Vg2HgS1inNICmRreAibHXmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021023; c=relaxed/simple;
	bh=D0JvnPHPVDFc+NFmQ/6cUpoEKHUAdJpsahd6wi6cGgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPMEpkSuvilx/W+8wjifxwEvrANCFyNMj4eLBfxDntn76cB68Jb53mom1eFX56DNOUpaVUGKXPdJYs2avOpBVblbIR6ebZN2DXbNLIbruxhesxr/IGdVU+NpfK2HKqHVA4NSt+7/M8Jho9Q3leiB9etebUd7Yz+Vx1Ugne5p0uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlurvjWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlurvjWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC3EC4CECE;
	Thu, 12 Dec 2024 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021022;
	bh=D0JvnPHPVDFc+NFmQ/6cUpoEKHUAdJpsahd6wi6cGgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlurvjWnVB/powclH5pjfLQ6Byz8/MiRXv4rEX9Ss399wkajQBbYVZUz8Qxg60xLR
	 Nr4LZqkiYwsIu7YjLZRvaGb3QKZG7vra51PCa9UOab+ixAZrX5VHnnJvNRAu7ymL4M
	 xMgf+41iIUFVLIllXdT7+bypG5DCZJDE26JtM064=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.1 625/772] drm/dp_mst: Fix MST sideband message body length check
Date: Thu, 12 Dec 2024 15:59:30 +0100
Message-ID: <20241212144415.761480864@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit bd2fccac61b40eaf08d9546acc9fef958bfe4763 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -319,6 +319,9 @@ static bool drm_dp_decode_sideband_msg_h
 	hdr->broadcast = (buf[idx] >> 7) & 0x1;
 	hdr->path_msg = (buf[idx] >> 6) & 0x1;
 	hdr->msg_len = buf[idx] & 0x3f;
+	if (hdr->msg_len < 1)		/* min space for body CRC */
+		return false;
+
 	idx++;
 	hdr->somt = (buf[idx] >> 7) & 0x1;
 	hdr->eomt = (buf[idx] >> 6) & 0x1;


