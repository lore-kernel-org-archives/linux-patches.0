Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A9314885A;
	Tue, 23 Apr 2024 21:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908641; cv=none; b=bFXJw6gjofYaDJyxFUoM0j9N+V0hgOpgp6biRu+6H2AcXT9kjW5g+GHsIp/mV20u84r7oNqiVwqRFJMKxeBuh6Q4fS498FnDOuKYbwDS2+pwNV26etK0Ng8BC/Su3OLI7n15ASjB8cRWmu6HufCbfE+lpCItUfurNQAkdbLaw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908641; c=relaxed/simple;
	bh=xhyZwrIfNievX6mmH16x3u32/7AyTaMIHdT8ThRdpZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7190VV7e2G+CtjA20SSHTf7wkbD66pLCbipuqe1K5MzUosnLvo1G8JEvASs3upAOd7cc3lVymtecX7dM58DsDSshIwNGkfXZc4V0mv/ZBL6sxrCJiknkCAhkNqu4ipodk1BoxS7PAtnanCRt+medSs8WEHhOILDoI04aqRYK5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwKiKs2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwKiKs2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243C0C116B1;
	Tue, 23 Apr 2024 21:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908641;
	bh=xhyZwrIfNievX6mmH16x3u32/7AyTaMIHdT8ThRdpZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwKiKs2HZpj9k1nKAeT8rQUjo6IIf2AKD/6sox0/dQtrQA363qgm0IuOBry/UKVr9
	 Z9MMkQ6Ao2bTFdI9hLKzLnz9ct81i8C5xMwtFSNXQbW9kk/Rz5qbww9dMhBy/ryE0Q
	 +XVEChHT+nJovNyawuK/i1+1rkc8ofElFZ26qe90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norihiko Hama <Norihiko.Hama@alpsalpine.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 124/158] usb: gadget: f_ncm: Fix UAF ncm object at re-bind after usb ep transport error
Date: Tue, 23 Apr 2024 14:39:21 -0700
Message-ID: <20240423213859.760535486@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -869,7 +869,7 @@ static int ncm_set_alt(struct usb_functi
 		if (alt > 1)
 			goto fail;
 
-		if (ncm->port.in_ep->enabled) {
+		if (ncm->netdev) {
 			DBG(cdev, "reset ncm\n");
 			ncm->netdev = NULL;
 			gether_disconnect(&ncm->port);
@@ -1354,7 +1354,7 @@ static void ncm_disable(struct usb_funct
 
 	DBG(cdev, "ncm deactivated\n");
 
-	if (ncm->port.in_ep->enabled) {
+	if (ncm->netdev) {
 		ncm->netdev = NULL;
 		gether_disconnect(&ncm->port);
 	}


