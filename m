Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3D0352FCB;
	Tue, 26 Aug 2025 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217145; cv=none; b=jsgTV6hOe0nD2If+4xgENnXCWA6vYVpgKCRND5kt8/fR5NEXcJ/vg45GXEhrcJzbJA0Yvf8nEJkuSqTxHjB5hfZRYJlzjnUmmVlUB9k8nImYvJn/VDhbmZWKUs4isr958i2Ibfwfc8U7KbBgtIkkge8NTj86bbjyx2BIMt1amrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217145; c=relaxed/simple;
	bh=jhFk0oSQkGEJJSYDH20MRw2ov9m2goSGxUTmKoz93IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPCX1BgUwi4oe04QJn9sQakUlOUe1tdzRPY+TYcnbdW8bS/g99B211aObhfzWKmAPW2NkJuNhMBJkm/LXNP0LU/Rxpq6olEoUQI7rUT/Wc6e1067FFk4tcZujpRJDgp2M+VflCti8rk2BqIDl2y9SmuTLDIBnCIBPIB9wD0a5C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JzA4xKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JzA4xKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0235AC113D0;
	Tue, 26 Aug 2025 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217145;
	bh=jhFk0oSQkGEJJSYDH20MRw2ov9m2goSGxUTmKoz93IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JzA4xKrK5XlmgMHxmDshJv2Kdu9QqC+zY9jqfpl33eZ9v4//s6mGJZtrTt59pr4F
	 AWNWi4LYqTCwB34vhq0A7fWrCeU1LJXwzFXWGCvEpLKGPQoIx74pqJigZkp7caJM5z
	 i2Bx+crNooVUYHKtxffwUHLdITa54x0VnU3LYl2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 007/523] thunderbolt: Fix bit masking in tb_dp_port_set_hops()
Date: Tue, 26 Aug 2025 13:03:37 +0200
Message-ID: <20250826110924.758243494@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 2cdde91c14ec358087f43287513946d493aef940 upstream.

The tb_dp_port_set_hops() function was incorrectly clearing
ADP_DP_CS_1_AUX_RX_HOPID_MASK twice. According to the function's
purpose, it should clear both TX and RX AUX HopID fields.  Replace the
first instance with ADP_DP_CS_1_AUX_TX_HOPID_MASK to ensure proper
configuration of both AUX directions.

Fixes: 98176380cbe5 ("thunderbolt: Convert DP adapter register names to follow the USB4 spec")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1179,7 +1179,7 @@ int tb_dp_port_set_hops(struct tb_port *
 		return ret;
 
 	data[0] &= ~ADP_DP_CS_0_VIDEO_HOPID_MASK;
-	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
+	data[1] &= ~ADP_DP_CS_1_AUX_TX_HOPID_MASK;
 	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
 
 	data[0] |= (video << ADP_DP_CS_0_VIDEO_HOPID_SHIFT) &


