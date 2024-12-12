Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C823121504F;
	Thu, 12 Dec 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016330; cv=none; b=ICWPkEHo/+H1ob9i/ndSoSFG//UYSy57SFhIcfHNLDFZHFQ2UwY5Ab0+P4U2piR3Yf04letV792gn6pcOCH3m58OApVkfguRyyBoKkRGQwcU34/Ein7K5aQElGtx+eXxpAjmkwxHH3eDCs2A6vu8D1OMGXUOENsFD2ZnxkhpY4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016330; c=relaxed/simple;
	bh=MN9gVi7jp/3dkYnc4NZ1l1JgpG4aV/qUfQIqev0uGXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjcTCoE0NK8UR4nWR9O2O2zyLhVPAe+AxBgwKThrTA8gUm6PGszqlAGGI+s2+WVlHaEcLMXyblPReGFiG5dXRNNqDJlLy8bhMOLGk0CWvfRygxct8rfE88Zebfv/X6K1QgZbHR0pT8kt2pZUChoIpaItpsGgrg17U3eDzdAW0Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLXiEk6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLXiEk6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36227C4CECE;
	Thu, 12 Dec 2024 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016330;
	bh=MN9gVi7jp/3dkYnc4NZ1l1JgpG4aV/qUfQIqev0uGXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLXiEk6ahUzu/9TI46Y/yNzOdCAzi55mYwf7T7X+cBbWcZdTEkzpLRLJe4pV+DiPs
	 f7y9JkJcYcWci54cPZuOJi/tNJSl/ZxrebiQLU/+rjJRocFb3fbP4cOWTyDqO/LsOi
	 o2AOGFRYE0X4BVcBle17SBpiaGKtfJFRZBiM4U4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.12 169/466] drm/dp_mst: Fix MST sideband message body length check
Date: Thu, 12 Dec 2024 15:55:38 +0100
Message-ID: <20241212144313.478312977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,6 +320,9 @@ static bool drm_dp_decode_sideband_msg_h
 	hdr->broadcast = (buf[idx] >> 7) & 0x1;
 	hdr->path_msg = (buf[idx] >> 6) & 0x1;
 	hdr->msg_len = buf[idx] & 0x3f;
+	if (hdr->msg_len < 1)		/* min space for body CRC */
+		return false;
+
 	idx++;
 	hdr->somt = (buf[idx] >> 7) & 0x1;
 	hdr->eomt = (buf[idx] >> 6) & 0x1;


