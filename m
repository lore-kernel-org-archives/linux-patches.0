Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA827285C8D;
	Wed, 28 Jan 2026 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616179; cv=none; b=YneRVGpu7KLVB5qtWvCKIs4m1bRxDu3Z29EDcgKAJTuDcGaurvS0fCvTJfD7q5+zVTXCtyzMxnNFC5hYW3hS5MLCjjRNyCSYcqGv8k8+B1KV8wDE21YmWgHvDLlgesnYGF2ZLxsbdmzL/tI641l6wPZPiYhaZe/cQzjlew+qd2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616179; c=relaxed/simple;
	bh=RDYQobSGdgJdqY+Yi5dmeV8c9D7VA8KPV1HBmyG5ad0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asJXnerisj5LtFftG8gkGOGeX4dDLbYR0+BA+i7hW3YMsagmI5sybOfIKVExrLL1hv3WDvqsO2nNcy5KnSP04YoaVixoWveIocGe0czzhQY1F343nCgUPwNSHQlzeOzXsjZrJ9Vruj0GHRteCGfVMdNuZ7aCt9Gkd9INpqKnFxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5aI7BG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5aI7BG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ED5C4CEF1;
	Wed, 28 Jan 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616179;
	bh=RDYQobSGdgJdqY+Yi5dmeV8c9D7VA8KPV1HBmyG5ad0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5aI7BG7i+Xt5l3pEdCjRFgCXS4WjlzbLqo3fmJEZQXLR9nU3+g+lXAJeshr26Uqx
	 FJWYCNtxGjZvWq4ANRlHkwRDgoKJ4XBnIrANfxckAMyPtvdxpR4MdZyOh8Kz9kftHW
	 oabjSm3Q+M7CNu3zwYfWtVdn1Vm+1ruR27e4UZZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 206/227] net: txgbe: remove the redundant data return in SW-FW mailbox
Date: Wed, 28 Jan 2026 16:24:11 +0100
Message-ID: <20260128145351.851168751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 3d778e65b4f44c6af4901d83020bb8a0a010f39e upstream.

For these two firmware mailbox commands, in txgbe_test_hostif() and
txgbe_set_phy_link_hostif(), there is no need to read data from the
buffer.

Under the current setting, OEM firmware will cause the driver to fail to
probe. Because OEM firmware returns more link information, with a larger
OEM structure txgbe_hic_ephy_getlink. However, the current driver does
not support the OEM function. So just fix it in the way that does not
involve reading the returned data.

Fixes: d84a3ff9aae8 ("net: txgbe: Restrict the use of mismatched FW versions")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/2914AB0BC6158DDA+20260119065935.6015-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -65,7 +65,7 @@ int txgbe_test_hostif(struct wx *wx)
 	buffer.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
 
 	return wx_host_interface_command(wx, (u32 *)&buffer, sizeof(buffer),
-					WX_HI_COMMAND_TIMEOUT, true);
+					 WX_HI_COMMAND_TIMEOUT, false);
 }
 
 static int txgbe_identify_sfp_hostif(struct wx *wx, struct txgbe_hic_i2c_read *buffer)
@@ -103,7 +103,7 @@ static int txgbe_set_phy_link_hostif(str
 	buffer.duplex = duplex;
 
 	return wx_host_interface_command(wx, (u32 *)&buffer, sizeof(buffer),
-					 WX_HI_COMMAND_TIMEOUT, true);
+					 WX_HI_COMMAND_TIMEOUT, false);
 }
 
 static void txgbe_get_link_capabilities(struct wx *wx)


