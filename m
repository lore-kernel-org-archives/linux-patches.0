Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6891FC101;
	Mon, 23 Mar 2026 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275784; cv=none; b=CPwyMpWSWHiQ0dDCk/iXzv7dT+Hxt1DwU0398/69dR4DTvbatBO3zNYU+uGkvY+28jVC46mKYJAHmq/GqUbdyC17IY56XKXUvBIpuLLAjBjtQhu02jOhEoEqZM+Orr77XGWjU1IclttqHDK7DoNcONku7NdJJVSH74+npErPoa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275784; c=relaxed/simple;
	bh=E1tSXkIEcFABxAnFXbXbq7+mxNww3mv8NdZXuOpRgD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg8v/JCwOjfE8eCovmUDaKio3XG1AW9mp1sAW4XmK4Yvd+NRIOsf3SYBpa3ZtoaccQF214yxRci6vHCZIkA2L1S9aj4Je/+lmfFm8edF7rk9sZDNOPWXySml6iQo175ej+dfNIZ7LZ8qDJtjiO50nBsSCwGM+o4e1/RSIfGzPgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyMjwIsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyMjwIsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A74C4CEF7;
	Mon, 23 Mar 2026 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275783;
	bh=E1tSXkIEcFABxAnFXbXbq7+mxNww3mv8NdZXuOpRgD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyMjwIsPEAcHys3WKyK2AsHl1P5UpyhJ6kqYTgO8Fd2meI2peeBvNssVYx5UujdR8
	 WYj54fSksFqeJLeGgW1UV0DffY8yGRNI1jZ60BRlN79DMS1QTIY7i3kWqAoNV8kpM5
	 PHKUyRqxKy1ZJlwOKVq+jGzrMY+/jjboKglgIg1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 216/460] i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort
Date: Mon, 23 Mar 2026 14:43:32 +0100
Message-ID: <20260323134531.814559243@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit b6d586431ae20d5157ee468d0ef62ad26798ef13 upstream.

The DMA dequeue path attempts to restart the ring after aborting an
in-flight transfer, but the current sequence is incomplete. The controller
must be brought out of the aborted state and the ring control registers
must be programmed in the correct order: first clearing ABORT, then
re-enabling the ring and asserting RUN_STOP to resume operation.

Add the missing controller resume step and update the ring control writes
so that the ring is restarted using the proper sequence.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-11-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -500,7 +500,9 @@ static bool hci_dma_dequeue_xfer(struct
 	}
 
 	/* restart the ring */
+	mipi_i3c_hci_resume(hci);
 	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE);
+	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_RUN_STOP);
 
 	return did_unqueue;
 }


