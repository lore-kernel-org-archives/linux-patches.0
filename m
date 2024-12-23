Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A83186E58;
	Mon, 23 Dec 2024 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969991; cv=none; b=VOpgVTiSuldSVvjEZANxvFzGr53fFhdFShpuDK2NbO5ZHZ0Z5MmqdKcg3nCyBPMBt103oOqrpjpSqRvAWv60SIIW353n9DDTbtXMkul5cwxrnSIWX9G2PgEFTlctVnvthhVVN48t9Em1UGHlfacsjRC5qu8BhcVeAMQvBQgT9tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969991; c=relaxed/simple;
	bh=mbNAloy7nHT5BHz3Vkg/V4KDxRyXaJ7buhFUI3/Zb7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPMtaFI/I/0ZeyyxIyIsT7xKoxEihihFost9MO1VjXgR5GCJYLZiO8Kafl6Gz8Fc6eTChAW3fY63bnw+glJzq4tIwOdoW9hF1KW9TvNNEj7oJDUWX2LdUpSRWUrc+w/mm/vSrlfuY+2L5IB0LOb74cd0sruNMBUbspkGt6dhumo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWPIz6yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWPIz6yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F514C4CED3;
	Mon, 23 Dec 2024 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969991;
	bh=mbNAloy7nHT5BHz3Vkg/V4KDxRyXaJ7buhFUI3/Zb7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWPIz6yzXYPGkOVQoK6OP6YqItqkm2K+3xGw+IPG4fti7/iO2BV3sfDTeqSXBCYsh
	 tZMwANZlAw5dE2+2TRe23jEyRJLx+Q1ibS84eVUib4OjT8+vPDR2cjQRLiZF4rEaDi
	 BS0wp9C9T+pfTfrByFPTr+Ctn+O2k+VUh8qSkdgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 081/160] xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic
Date: Mon, 23 Dec 2024 16:58:12 +0100
Message-ID: <20241223155411.821028780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit e21ebe51af688eb98fd6269240212a3c7300deea upstream.

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
---
 drivers/usb/host/xhci-ring.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1192,8 +1192,6 @@ static void xhci_handle_cmd_stop_ep(stru
 			 * Keep retrying until the EP starts and stops again, on
 			 * chips where this is known to help. Wait for 100ms.
 			 */
-			if (!(xhci->quirks & XHCI_NEC_HOST))
-				break;
 			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
 				break;
 			fallthrough;


