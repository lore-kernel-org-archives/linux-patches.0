Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708C316D9B8;
	Mon,  6 Jan 2025 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178850; cv=none; b=XhAaleNP6XYyfTDbPC7ZQe6+lywMiIRex4NaCg5fBZwRcmD+afsucWeo6TA3+GV/8e2lQAE/Un4Fl79hmDooITib4khvRNIthYTWw2Q35EPNSQMWNYVlnCyfdrh0L7eDFktHws0rpLF4aCkQnihtMZ0lAeKEKJBN4ZoNxF/pwIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178850; c=relaxed/simple;
	bh=EeCVExciV73jD07j7E3+Q9qeCMfhC5mmXBD/HNZ7Jds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iurCJ4C3CJ7nex9OxjcZs06+ggp9cbcTj/zXUl+wxgVX2x91tTnqv2bYW2p9O2PJvwR7wVMLdpyEPY1lgNTbG3bxxHOw9oA46WV2OKXcXv7EkPoHu21z08FZLOuKcjf1Zd7J66TUWMfAyvsUKTqqXkXOHyOOHMJmIW7XZDAjMLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8ymC84C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8ymC84C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA11C4CED6;
	Mon,  6 Jan 2025 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178850;
	bh=EeCVExciV73jD07j7E3+Q9qeCMfhC5mmXBD/HNZ7Jds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8ymC84CeBFaRybdldjbhv3BvHHh+YPF89TG5U8CNXdAv4mQUf/5+sc6uOdXzBk4r
	 rMgA6Rd0ABTYM/Euc7h/WJpwlGBJyyMQ/loWhCZ1qYFM344bnVk27zLX7emQ3BMzqD
	 2xwJJxJF6BWIGfbqFK9plnmmbqphSe1gS8cZBfo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/168] xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic
Date: Mon,  6 Jan 2025 16:17:02 +0100
Message-ID: <20250106151142.759323794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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
index 2694d7bf48a7..0ff70c859f14 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1171,8 +1171,6 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
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



