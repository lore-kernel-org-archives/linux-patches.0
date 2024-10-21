Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA01E5726;
	Mon, 21 Oct 2024 10:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507424; cv=none; b=tVAFaszbH4n3jx4w/Hp0EFTFj+pKo4B11UvDbII5za/w8D88K/JV4JCaBZ4B3QbBS5H0BwVqtGQvQlTYzCS9rIxJSDSsB+yoguwVYdO004g86QcxCyTqj+iePGWTQpdbqLkuNmzE29oWMm9C8Xu4L8LOej1YvA9s7RKAYdoh3Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507424; c=relaxed/simple;
	bh=h6w9Fucz7uFg45+vGPjufB/Eydxs+0i51jCEI9CvdpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0k2bpjNZQ2lJJrVZTkLGbGsJ/XrHvswwRe4EgkSvglMQdegCd/WyOsm8CcD7XU/2y1FLEXjpeU2zIPwHfVzd0g+44BFNS3xrTtqWEA7VROH2iGp14kyS8rNJm6zb1ayTFUYoiolfScLs46Z+suJLsOOOBAnnQ69p3wGuLk8yaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWkEiRBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWkEiRBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E96C4CEC3;
	Mon, 21 Oct 2024 10:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507424;
	bh=h6w9Fucz7uFg45+vGPjufB/Eydxs+0i51jCEI9CvdpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWkEiRBChyVuKDJw/IxwVpM9xOy1DT6xQrU+Ifozph4QmwbB/vkN1LAdpJaNFQtLp
	 XpzCZFgia7aJqTgTb67Ajl5BLJ/WCHiTihL2Ow7qb4qsoxeKmfgHSmWUVkCQNWKorc
	 /GnOJM/vrdZnFqLXXeJDtKPjU5eMYzkoTCc157cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 73/91] xhci: Mitigate failed set dequeue pointer commands
Date: Mon, 21 Oct 2024 12:25:27 +0200
Message-ID: <20241021102252.669346232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit fe49df60cdb7c2975aa743dc295f8786e4b7db10 upstream.

Avoid xHC host from processing a cancelled URB by always turning
cancelled URB TDs into no-op TRBs before queuing a 'Set TR Deq' command.

If the command fails then xHC will start processing the cancelled TD
instead of skipping it once endpoint is restarted, causing issues like
Babble error.

This is not a complete solution as a failed 'Set TR Deq' command does not
guarantee xHC TRB caches are cleared.

Fixes: 4db356924a50 ("xhci: turn cancelled td cleanup to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241016140000.783905-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1006,7 +1006,7 @@ static int xhci_invalidate_cancelled_tds
 					td_to_noop(xhci, ring, cached_td, false);
 					cached_td->cancel_status = TD_CLEARED;
 				}
-
+				td_to_noop(xhci, ring, td, false);
 				td->cancel_status = TD_CLEARING_CACHE;
 				cached_td = td;
 				break;


