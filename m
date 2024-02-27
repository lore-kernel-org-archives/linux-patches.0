Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9813B79F;
	Tue, 27 Feb 2024 14:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042727; cv=none; b=XWl5PdoOAzgn3/4cxFZwWR7aNyHT7CSxw3AGuzbuUF9O+4zw4v0NqvX0My3HtH0yBchqnDORfNA43kMj/ytzfUSrujXplZGS3DzZBu7EI8qm/8l3LplTyj/lpf1BvTrYDhztWJN9kfUqYx+4LISj93JmPRShYLuDMaiMQzCX/h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042727; c=relaxed/simple;
	bh=UPgLodhMqrelpXzVZhbNFedhMbuUNf/J1UL2td6/qcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0pEar2U5VJ1t4rGZxNFQUhseeaunHckojS8QenWf638Sxqh8z29Cq+EthSiBdUjGeU7JabS9aaeRuIM5NtbzFEv/WABDFKvKtC4my3mQepxi/N2D/Rmc5rv0UZMps3Xfntme4JrcdALMMO7IvX1QwImywN12tKK2XUYtsYtL48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzJBCGMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzJBCGMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56118C433C7;
	Tue, 27 Feb 2024 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042726;
	bh=UPgLodhMqrelpXzVZhbNFedhMbuUNf/J1UL2td6/qcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzJBCGMdk0cEFTpleWHGVOH1Uyz9W4ngKQxR92TEQ4zRvBcuW00YNFdtc5cJCLv3m
	 tERAfR6dBFEXQgMht5zwUgeb3nyYEAmc5hljDYiT/3yxlcIplpmovKiZYlOmwDnf/1
	 oOEqYP+BNiC0cYbj5JygHP5dO3yUcpPEOqm3zaRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 099/245] usb: cdns3: fixed memory use after free at cdns3_gadget_ep_disable()
Date: Tue, 27 Feb 2024 14:24:47 +0100
Message-ID: <20240227131618.436155855@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit cd45f99034b0c8c9cb346dd0d6407a95ca3d36f6 upstream.

  ...
  cdns3_gadget_ep_free_request(&priv_ep->endpoint, &priv_req->request);
  list_del_init(&priv_req->list);
  ...

'priv_req' actually free at cdns3_gadget_ep_free_request(). But
list_del_init() use priv_req->list after it.

[ 1542.642868][  T534] BUG: KFENCE: use-after-free read in __list_del_entry_valid+0x10/0xd4
[ 1542.642868][  T534]
[ 1542.653162][  T534] Use-after-free read at 0x000000009ed0ba99 (in kfence-#3):
[ 1542.660311][  T534]  __list_del_entry_valid+0x10/0xd4
[ 1542.665375][  T534]  cdns3_gadget_ep_disable+0x1f8/0x388 [cdns3]
[ 1542.671571][  T534]  usb_ep_disable+0x44/0xe4
[ 1542.675948][  T534]  ffs_func_eps_disable+0x64/0xc8
[ 1542.680839][  T534]  ffs_func_set_alt+0x74/0x368
[ 1542.685478][  T534]  ffs_func_disable+0x18/0x28

Move list_del_init() before cdns3_gadget_ep_free_request() to resolve this
problem.

Cc: stable@vger.kernel.org
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20240202154217.661867-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2537,11 +2537,11 @@ static int cdns3_gadget_ep_disable(struc
 
 	while (!list_empty(&priv_ep->wa2_descmiss_req_list)) {
 		priv_req = cdns3_next_priv_request(&priv_ep->wa2_descmiss_req_list);
+		list_del_init(&priv_req->list);
 
 		kfree(priv_req->request.buf);
 		cdns3_gadget_ep_free_request(&priv_ep->endpoint,
 					     &priv_req->request);
-		list_del_init(&priv_req->list);
 		--priv_ep->wa2_counter;
 	}
 


