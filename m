Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D33158536;
	Mon,  6 Jan 2025 15:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177172; cv=none; b=j/PLzYzNkY2YC+HUs7dbkR4iXPzUBO+EOSJUKw8ddHWyyBMd0W6kctzj30/r54AB0l++KZ1skFGCGTyqBbhWGj1RglTNf7pxjQqxhncdz3b/zAfMwbTQnp56SQkY33zUzoY8+uuPkjqibe9x2xwrwlHC4IhfO3aRn5L6bNULEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177172; c=relaxed/simple;
	bh=E26dHV62E3R21mGVEQbG2CZEA7hQvsGzDkpI742XScA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrT/ZmymH6dpTX4OV7L0N9Xiy7TigxxhAFy+vZySbtlZpKnwL8KnCMi0XVZKbhrN0MAXv39LHbAgGrzoWsDcsTLGVGEBrlPFfIRL9D5T3hRFycf6EFqwtl9Ther2pC29iRxhZaeuaI5FWxXT+ty7bfhAy2S523GEqXM+YS+C/1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS632WWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS632WWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B23C4CED2;
	Mon,  6 Jan 2025 15:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177172;
	bh=E26dHV62E3R21mGVEQbG2CZEA7hQvsGzDkpI742XScA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS632WWNA6ftNarBEgIkZ9WaKGvBzvvsIk0cSlCznPbpofG6Sb9W3mO3QQ+lNewkj
	 Auc6R9dWQnIz9efH369+00siII/uMkj9dj8rugAhBkfAy7x0DCet1cAsUQyz0JaH2L
	 SbctnTsbS3cgp1rNGP1DgUnPHvvd5RzVYfxdZfCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/222] xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic
Date: Mon,  6 Jan 2025 16:14:39 +0100
Message-ID: <20250106151153.443813059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit e21ebe51af688eb98fd6269240212a3c7300deea ]

xHC hosts from several vendors have the same issue where endpoints start
so slowly that a later queued 'Stop Endpoint' command may complete before
endpoint is up and running.

The 'Stop Endpoint' command fails with context state error as the endpoint
still appears as  stopped.

See commit 42b758137601 ("usb: xhci: Limit Stop Endpoint retries") for
details

CC: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241217102122.2316814-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d318310e3135..729319d81753 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1203,8 +1203,6 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 			 * Keep retrying until the EP starts and stops again, on
 			 * chips where this is known to help. Wait for 100ms.
 			 */
-			if (!(xhci->quirks & XHCI_NEC_HOST))
-				break;
 			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
 				break;
 			fallthrough;
-- 
2.39.5



