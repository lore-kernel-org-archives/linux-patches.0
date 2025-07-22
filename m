Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84C9433A8;
	Tue, 22 Jul 2025 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192000; cv=none; b=q2h8pD1cKStVHHTLSpTCT3nmp5IWKCDgc4HbFJ6MB5K0dlU8GMDvW+y7+4y8cOGWEfPpElr41lINW75ejnNc+AfYuThuP/VZY5cxwgBbrvk0wgbRUQimYo2sXvPkSueO8DvtNy7H6MYlaKJ1dwJ0/W0V+ZEmyTR/T9W0KZV5R9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192000; c=relaxed/simple;
	bh=jQ2AXPVGYpJlMFhLlvkZ4C7Ug0giQysC39i/Ud1pOXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CexkW1EaNWNXzJPaY7iWxq1vtF64QHA+JJTuIPal8uA2S65no2ZroCZKfmmTPvJS3ZiKzu2QGpw7QX0lyqjmO/qEz+94La2A6qdp2mK79GeRK67UagZLeo2rubDmFTEzA13SUAjcUs/TLfYhSS6xp9nCBe/0LRfpXvyWtGpdfmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUegOAyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUegOAyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3730AC4CEEB;
	Tue, 22 Jul 2025 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192000;
	bh=jQ2AXPVGYpJlMFhLlvkZ4C7Ug0giQysC39i/Ud1pOXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUegOAyMfwOfw4PS6RantLKld0mDTdw5xPr4bfuC6pT1/oREuen1p2qzS6Cig8PqW
	 21ukxhpLC5BeNQ31hL2v6E74YA+R/SttonqA+x3iVYE2Wjm8WHsqgajo3JMd6Haiei
	 nmCqnlBCjEHRjHU47mygsh7Zo5MCmlE37cnid8nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 07/79] thunderbolt: Fix bit masking in tb_dp_port_set_hops()
Date: Tue, 22 Jul 2025 15:44:03 +0200
Message-ID: <20250722134328.651985984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1491,7 +1491,7 @@ int tb_dp_port_set_hops(struct tb_port *
 		return ret;
 
 	data[0] &= ~ADP_DP_CS_0_VIDEO_HOPID_MASK;
-	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
+	data[1] &= ~ADP_DP_CS_1_AUX_TX_HOPID_MASK;
 	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
 
 	data[0] |= (video << ADP_DP_CS_0_VIDEO_HOPID_SHIFT) &


