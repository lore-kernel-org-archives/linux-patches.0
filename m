Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21127148316;
	Mon,  6 Jan 2025 15:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176722; cv=none; b=dNs+JjikVpuqVeg34Md3gKwO7cTrM0NXa1L4cGo2d5L5NbOZPcSu5hPjOFnaI113Fb3bVkwvAJ6aTuKnlt7AYy4YcfNr6DakTOvCs5gESHaLclY7+ib/jcYqwk2CaEvmkhiGQxSonB5tI32e++88w+3Xma1aw4zFuh06bImYt9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176722; c=relaxed/simple;
	bh=t1MYbj2ZhdmRCacU6+Qizw46Np8sE4p/McAxBn6pxJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBIKxfc2eiQY0LhEbfScVq54ChX7eKB8MA3cOs/nsuAh7z4jxwmgQy7qdm/7K8rPIPRNHiTVMYez3Me6VrpaO82VP133x7SB8I27Bfn+KFF+QrldmTaMyvzP78yvaw8Ti5kVkr+Xp5vis/iLIox1GGNm5wvIK5nj8pZCz/X8CxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEIXXdVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEIXXdVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B27C4CED2;
	Mon,  6 Jan 2025 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176720;
	bh=t1MYbj2ZhdmRCacU6+Qizw46Np8sE4p/McAxBn6pxJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEIXXdVURtxhxwb6bX4X2yNiQP2yn2YKWGh3sE/Lw1twErWPjY7EBw55xyuPxIlD3
	 8Oh0yccWDX+XV4lCKhk3TTiV18bdYqKi8pa0YbTqD1KF4y/dh8fMa3w89a3mzvok4m
	 Kmqfv+qEHVT6aum67w7yHIaGM4krFhZc0wWUoJHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/81] xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic
Date: Mon,  6 Jan 2025 16:15:42 +0100
Message-ID: <20250106151129.828132232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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
index 4a3a8a3fa69d..e5b2a3b551e3 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1164,8 +1164,6 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
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



