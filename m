Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63AA2E4271;
	Tue, 22 Jul 2025 13:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192342; cv=none; b=YFF+J5JIUHrvwsQbCvLzyhl35SRRNON1hn1t58fQMMbxLNHxNSMUI3ec9DX8pq65y/SwLuoSeYMVkmGrGF1xNiaxjE7g2TLRq1wprdD7/+Yy3SayHR3B2rg7xoqRn9eVd1ctPnJanTXKnXRleEbyqxWanLK/HTiYL4OLccM8+wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192342; c=relaxed/simple;
	bh=oyuy1wK5aXUgnOEtfFsK1aYtZMBT20UsnV21QOjppmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN6kq1lfafrUKrNHcIEULkY72Db1YUGaNhY2yeX33jrMPnUAk34nbHw19lFv+8lQ8Zp3Ty01xUPGEYsR4ITt1PbF5eAp1MRyXBUoj1QYrrxgs4ip/4OGTjlZ3oko8wyg+CR5fhGqRXyx5g9KazsXL9SNy+YHpdjnepxI/x+b9I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOlp6WCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOlp6WCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDC0C4CEF1;
	Tue, 22 Jul 2025 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192342;
	bh=oyuy1wK5aXUgnOEtfFsK1aYtZMBT20UsnV21QOjppmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOlp6WCkSvLDXZgo+UzDCp02ZxEwWHZwmnhqgh6Tvhg6DqihG8VxOZCcRft+u0eW+
	 0DOQWtYilAhwqWJ3ecJmXffNKk7mI7Q8XU6XEXNaic1BTPpuWaUQxHJvWQGpD8lq0Q
	 k+yBOOtapdIHQxnt/hoRcJDnQ9Kmqc0SrgBJqz0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 011/111] thunderbolt: Fix bit masking in tb_dp_port_set_hops()
Date: Tue, 22 Jul 2025 15:43:46 +0200
Message-ID: <20250722134333.797303661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1465,7 +1465,7 @@ int tb_dp_port_set_hops(struct tb_port *
 		return ret;
 
 	data[0] &= ~ADP_DP_CS_0_VIDEO_HOPID_MASK;
-	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
+	data[1] &= ~ADP_DP_CS_1_AUX_TX_HOPID_MASK;
 	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
 
 	data[0] |= (video << ADP_DP_CS_0_VIDEO_HOPID_SHIFT) &


