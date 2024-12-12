Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB806F2FE;
	Thu, 12 Dec 2024 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017986; cv=none; b=Ff9X+h3ghwNl7n+N32BFDr52/IefX3dz76XjiqvJgArJN0uqqm5GbHexsK56uTJywZV+MrsNl/kgREAHqIpXic7XwCQ19nQy4Wu+h05lSmt+J6aYQ71FA/AUQPuzHhaYx5lFfR5noxzOSFdcVIkKuJPHQNBftfB7dcQv6/4HYsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017986; c=relaxed/simple;
	bh=6/HOC1tZavkIT+IUwhmQPwbl6txPm3leAsWR65L+ZKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niK72WuSXuLOeCCq2r7LaoN0JCFF5rgdGHwewE/WEddiwdFMg0SysiVuQn8uEWyZCeYulNDqo/JwiakYmYqlk+Km2d6oGhseRdkQI9JuOsWrjDHsM/MFlynctOVgjXsz55vm63iz/DO4hvtPk1RmNyroUnf0gF468EIay6Q5zng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPeaMHhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPeaMHhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23914C4CED4;
	Thu, 12 Dec 2024 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017986;
	bh=6/HOC1tZavkIT+IUwhmQPwbl6txPm3leAsWR65L+ZKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPeaMHhCEvMc3Zz4y9eYEWw6LmSRhHADrbnPDuKApUvEe8/cAoEa3JJrGokmE4YRL
	 ZttgjAqig6o5Dl2VxpMqfwCjwX/JxsoHx0jqGjKkIt5wXuUnzkxH61cBCQir4fHmtG
	 DYe5OZUuePs/YTCjQ1ZHsfXzmS/EMH7S7ZRk95RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.6 166/356] drm/dp_mst: Fix MST sideband message body length check
Date: Thu, 12 Dec 2024 15:58:05 +0100
Message-ID: <20241212144251.195017625@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


