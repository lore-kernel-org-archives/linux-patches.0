Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B992D21ABC1;
	Tue, 29 Apr 2025 17:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948822; cv=none; b=M8NtIJ42oVLpbc4859E7G0C8N0H3Yj8zxWELqCSYrjFuWxn3PbLgEr5IihSMXC90C60jeBeZw4qwoxRpnBUxmDWJlIij9GVECYi/FKx0ajj4fLNtuTa+VIz0IAZNSpfRfqUBonvmlfo4dEx5etpAc4Rn9lUDiPNCLySvSnW8BMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948822; c=relaxed/simple;
	bh=Bx/89LlKEw7AzPyjwGzKr/OXt9wz3vYcI7KWrzAzzRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfxSkPv9V5iExbzqnzLMeTkulUqmastYQwLswQqZ/ctcel4xCEH0fnj5FpglkymPG4VpvGRZkS/ts4cEr0PE4lOVOTWCn9zWcpSpUP3nN/vvbcYZFfi4xUYxmP1jQ9qZ8zDnhqLNvn/0ygPyk5I7/RNQFA0s8irTS6JnmbwXfEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEGwj8jY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEGwj8jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFA6C4CEE3;
	Tue, 29 Apr 2025 17:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948822;
	bh=Bx/89LlKEw7AzPyjwGzKr/OXt9wz3vYcI7KWrzAzzRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEGwj8jYX6oyvOdjbXRNlbZOOc/zDD5Pi1ioEmpaWl497+JfD5SWDwx/SZwMHADSC
	 rUUQOJ/218xr6Ew/r7dVY9C/WldeF2DwZblGd0S9wysZAZnjaYr0ReT+uPqfl8KLjX
	 cI5LRcYzacUY/Zwa6BRz2T2Am8KqClQMOD6n7fXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 088/373] i3c: master: svc: Use readsb helper for reading MDB
Date: Tue, 29 Apr 2025 18:39:25 +0200
Message-ID: <20250429161126.783245141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Stanley Chu <yschu@nuvoton.com>

commit c06acf7143bddaa3c0f7bedd8b99e48f6acb85c3 upstream.

The target can send the MDB byte followed by additional data bytes.
The readl on MRDATAB reads one actual byte, but the readsl advances
the destination pointer by 4 bytes. This causes the subsequent payload
to be copied to wrong position in the destination buffer.

Cc: stable@kernel.org
Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -315,7 +315,7 @@ static int svc_i3c_master_handle_ibi(str
 	       slot->len < SVC_I3C_FIFO_SIZE) {
 		mdatactrl = readl(master->regs + SVC_I3C_MDATACTRL);
 		count = SVC_I3C_MDATACTRL_RXCOUNT(mdatactrl);
-		readsl(master->regs + SVC_I3C_MRDATAB, buf, count);
+		readsb(master->regs + SVC_I3C_MRDATAB, buf, count);
 		slot->len += count;
 		buf += count;
 	}


