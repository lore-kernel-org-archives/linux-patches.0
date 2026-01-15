Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFBE2C324E;
	Thu, 15 Jan 2026 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496921; cv=none; b=qAjzd+smb9M+xRjX226r9SJoug5xKdVW+54+dhl9DyG+95IEaq09/V+yePZw66tpkGPn78yHzzSpmMZIx2moieBOaccoLVhO97CHGG4yw0maDe9hub3lyf9rbfyzEmH2JaKyNM4HtGw0tge5tRuC4uYe6vGecN0ua95xJRYXJ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496921; c=relaxed/simple;
	bh=gSdVr3mzw3ozMY7QPYhbEfgMCAJe6QIkVqsqO+Zhub8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeldIAfM+XzlNUFIdd48P+JxGzjG+xsPYZ75JH2BPKfpSoe13k+FS2lo2rZfLtB5N5/qq27pfAy5oXIyWdF1xOID/hvHPos21EEe5NbIZbn6CNpxkRhTEyVlS69Cxv65lxpKhp/MG1brbqAUYH8dPVpqThPLy+Nw5yLSnYBN2ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6o7R292; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6o7R292"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B2C116D0;
	Thu, 15 Jan 2026 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496920;
	bh=gSdVr3mzw3ozMY7QPYhbEfgMCAJe6QIkVqsqO+Zhub8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6o7R292fqVA4Q/kLDTpvJxLwx0RMVOKGyjAK+1IGepKMdkMLkvODrjWg4SSzVyfo
	 WoQqrmtRiJB3B6IW2LH9+5BZl6J//NPFQjXE2cPvq6+QnmmMnxy/rQcN7XAXisSk0p
	 K1F+JPemjET4rwNlTUm9nXVEVU4u/3uUI7X2m4Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 62/88] net: usb: pegasus: fix memory leak in update_eth_regs_async()
Date: Thu, 15 Jan 2026 17:48:45 +0100
Message-ID: <20260115164148.556322062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petko Manolov <petkan@nucleusys.com>

[ Upstream commit afa27621a28af317523e0836dad430bec551eb54 ]

When asynchronously writing to the device registers and if usb_submit_urb()
fail, the code fail to release allocated to this point resources.

Fixes: 323b34963d11 ("drivers: net: usb: pegasus: fix control urb submission")
Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Link: https://patch.msgid.link/20260106084821.3746677-1-petko.manolov@konsulko.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 81ca64debc5b9..c514483134f05 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -168,6 +168,8 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 			netif_device_detach(pegasus->net);
 		netif_err(pegasus, drv, pegasus->net,
 			  "%s returned %d\n", __func__, ret);
+		usb_free_urb(async_urb);
+		kfree(req);
 	}
 	return ret;
 }
-- 
2.51.0



