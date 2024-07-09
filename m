Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0412E12CDB6;
	Tue,  9 Jul 2024 11:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524633; cv=none; b=TiKpZgbdN1Ns8DSvY7Z0D6HINypWbQxGT97u+SsCePcUPA72nOGruoXs+M55PzU6H9TQbzoXQQoLkwfdZKqMeeyqn/jCis4aFwomOKeCgZrDUKwlPpXObRCsGk5IUnW+On2e2Nv5o7tDejlGE8yoYpkJgOO3LZByy1bjukBirwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524633; c=relaxed/simple;
	bh=R2d6HXoFuV08rVaKRP3L1f7XAxjsgqoXrIdGvk3e9oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoLRlthOL3zvKqMHJGkzLtkbViZ7qsw7z2xxbjoqJMC5TGMrQ+hD5TR30xMN4rnszBcBQ/byA4Ks3W7hge0CCbvmeNwIyxX+uM9WZ/Kc8GKlhUO5W9fe+0nn6p5KatjeqctXGPDKS1rXfetofn0jTitx/GGalZWMMOkANU/8sU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3eFmMxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3eFmMxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B2DC3277B;
	Tue,  9 Jul 2024 11:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524632;
	bh=R2d6HXoFuV08rVaKRP3L1f7XAxjsgqoXrIdGvk3e9oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3eFmMxEjF041B7Mzg9qebY6Wev8yePuuUi76kCaA/Lsibi25uVXoCtIN/5wd/8qG
	 /YEA8uA5vAwOkd7oiImGWMz5X3wrbfvS3SNTi+/nV80uM+CwDZHPifY6TLGOcc3teD
	 8U9J1mLmOOBzYmfBuTEt6gYeketdejzuB44hFPRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/102] usb: xhci: prevent potential failure in handle_tx_event() for Transfer events without TRB
Date: Tue,  9 Jul 2024 13:09:44 +0200
Message-ID: <20240709110652.194662100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 66cb618bf0bb82859875b00eeffaf223557cb416 ]

Some transfer events don't always point to a TRB, and consequently don't
have a endpoint ring. In these cases, function handle_tx_event() should
not proceed, because if 'ep->skip' is set, the pointer to the endpoint
ring is used.

To prevent a potential failure and make the code logical, return after
checking the completion code for a Transfer event without TRBs.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240429140245.3955523-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7549c430c4f01..be5b0ff2966fe 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2631,16 +2631,17 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			else
 				xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
 							    EP_SOFT_RESET);
-			goto cleanup;
+			break;
 		case COMP_RING_UNDERRUN:
 		case COMP_RING_OVERRUN:
 		case COMP_STOPPED_LENGTH_INVALID:
-			goto cleanup;
+			break;
 		default:
 			xhci_err(xhci, "ERROR Transfer event for unknown stream ring slot %u ep %u\n",
 				 slot_id, ep_index);
 			goto err_out;
 		}
+		return 0;
 	}
 
 	/* Count current td numbers if ep->skip is set */
-- 
2.43.0



