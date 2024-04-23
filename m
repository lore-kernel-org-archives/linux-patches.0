Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9B814885A;
	Tue, 23 Apr 2024 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908811; cv=none; b=s1+IPxXlvXyEgAU3yA9eqvPmDIz+Lxtv9vA7m8ENn3dhTuMaY2fZ8PvSGkf8KXqwsV4zxllPsB0nz2/2x7+NqIt1MVZJODPwkxNQC4v92GoPWnxn1NRd4oBZoaQ0CoYscESnR0LlcsJaHRAcBRrY2SQzdvXs48fGUhfC8ZVhasw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908811; c=relaxed/simple;
	bh=LBwP5xNEZJRWH+wiyiQ9zaXlBP1s7QklJsiO8LLkbxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1zJQUdHvTX2dE5Oqf49DKPUyl265gFJEIMNn+y5ZSX+H+y+COkHPU+nHqJa4NwaN0vGhjLTQrqxvCPKTnASk56FNEshRR0tdvfsS6pxZzNyEnIYiFkHm/G9SOu/hxJupztamwKQhWm/BJ63EoXKY2Ire5zWcum5O1AcozTe5cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBvc1eb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBvc1eb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217D6C116B1;
	Tue, 23 Apr 2024 21:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908811;
	bh=LBwP5xNEZJRWH+wiyiQ9zaXlBP1s7QklJsiO8LLkbxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBvc1eb2kK1iPjizB1c5HbfEy/eqID3ZvDpFpMeVF/mj+dHHIkHQs3PhYFvBAzsGC
	 H/Z69ZeLhv4xll8N8pDwGo4mS/L94t9gbRkATP04NLMpcZWPKgVisKqdc/JM6oQVAo
	 QLxF2gj1P4zk7eULddZTpWsbv3VxFgQV+QcNGSbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norihiko Hama <Norihiko.Hama@alpsalpine.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 55/71] usb: gadget: f_ncm: Fix UAF ncm object at re-bind after usb ep transport error
Date: Tue, 23 Apr 2024 14:40:08 -0700
Message-ID: <20240423213846.074476206@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norihiko Hama <Norihiko.Hama@alpsalpine.com>

commit 6334b8e4553cc69f51e383c9de545082213d785e upstream.

When ncm function is working and then stop usb0 interface for link down,
eth_stop() is called. At this piont, accidentally if usb transport error
should happen in usb_ep_enable(), 'in_ep' and/or 'out_ep' may not be enabled.

After that, ncm_disable() is called to disable for ncm unbind
but gether_disconnect() is never called since 'in_ep' is not enabled.

As the result, ncm object is released in ncm unbind
but 'dev->port_usb' associated to 'ncm->port' is not NULL.

And when ncm bind again to recover netdev, ncm object is reallocated
but usb0 interface is already associated to previous released ncm object.

Therefore, once usb0 interface is up and eth_start_xmit() is called,
released ncm object is dereferrenced and it might cause use-after-free memory.

[function unlink via configfs]
  usb0: eth_stop dev->port_usb=ffffff9b179c3200
  --> error happens in usb_ep_enable().
  NCM: ncm_disable: ncm=ffffff9b179c3200
  --> no gether_disconnect() since ncm->port.in_ep->enabled is false.
  NCM: ncm_unbind: ncm unbind ncm=ffffff9b179c3200
  NCM: ncm_free: ncm free ncm=ffffff9b179c3200   <-- released ncm

[function link via configfs]
  NCM: ncm_alloc: ncm alloc ncm=ffffff9ac4f8a000
  NCM: ncm_bind: ncm bind ncm=ffffff9ac4f8a000
  NCM: ncm_set_alt: ncm=ffffff9ac4f8a000 alt=0
  usb0: eth_open dev->port_usb=ffffff9b179c3200  <-- previous released ncm
  usb0: eth_start dev->port_usb=ffffff9b179c3200 <--
  eth_start_xmit()
  --> dev->wrap()
  Unable to handle kernel paging request at virtual address dead00000000014f

This patch addresses the issue by checking if 'ncm->netdev' is not NULL at
ncm_disable() to call gether_disconnect() to deassociate 'dev->port_usb'.
It's more reasonable to check 'ncm->netdev' to call gether_connect/disconnect
rather than check 'ncm->port.in_ep->enabled' since it might not be enabled
but the gether connection might be established.

Signed-off-by: Norihiko Hama <Norihiko.Hama@alpsalpine.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240327023550.51214-1-Norihiko.Hama@alpsalpine.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -888,7 +888,7 @@ static int ncm_set_alt(struct usb_functi
 		if (alt > 1)
 			goto fail;
 
-		if (ncm->port.in_ep->enabled) {
+		if (ncm->netdev) {
 			DBG(cdev, "reset ncm\n");
 			ncm->netdev = NULL;
 			gether_disconnect(&ncm->port);
@@ -1373,7 +1373,7 @@ static void ncm_disable(struct usb_funct
 
 	DBG(cdev, "ncm deactivated\n");
 
-	if (ncm->port.in_ep->enabled) {
+	if (ncm->netdev) {
 		ncm->netdev = NULL;
 		gether_disconnect(&ncm->port);
 	}


