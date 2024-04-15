Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1472119;
	Mon, 15 Apr 2024 14:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192143; cv=none; b=jRqAQhXq2I7wvS2Rg7nNGTNm4wc23MWUvobBsND/6OwxD3JS+Fuq4jm1NVfQahKxT8iFfyNzdDnxYEtUBcFgdtE6EJgXeDecH4Ly8Nk9dAc/AleqQZQpsj+KFi40wFV+6itAueJ33okUKi4PAFpurac0kO6u/vRSWLRbMj8kv28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192143; c=relaxed/simple;
	bh=53rIqixae2dzsRzoBkNoELCNG5qOJQ8QG+9X47xg1VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n28S67WOUkdUUVa5R5ia5oy2gqIV/g2DppRo09DFXqWli7yV9YhDMOE5kjBiyTRIX54Xc8pzmmdIP187jEBA4KmCJpPfQfMxEeY+NGNeaXq80IPnf4ODD650IlmXl3rF2olQ0swD2B4UpNdtqx7+DBWv92sk3eFBqNEeb7GQ9r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDn3cYtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDn3cYtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A1DC113CC;
	Mon, 15 Apr 2024 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192142;
	bh=53rIqixae2dzsRzoBkNoELCNG5qOJQ8QG+9X47xg1VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDn3cYtfxwunZlptdvmqhc3QpcPGqyvDEEw2wWXRXiH0P1wINF+5lmIrph7uw2FAr
	 VMwtvhRZar2VVpAY9e2k3uLQ6iJmbGMP+UiyP114oTUd8CiQ40aa30LAXq9/cI/Ezo
	 REc10vR+kDNEaUQwXwaSPfbokGMIJ6HfOclMPC7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39ec16ff6cc18b1d066d@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 03/45] Bluetooth: Fix memory leak in hci_req_sync_complete()
Date: Mon, 15 Apr 2024 16:21:10 +0200
Message-ID: <20240415141942.344193355@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

commit 45d355a926ab40f3ae7bc0b0a00cb0e3e8a5a810 upstream.

In 'hci_req_sync_complete()', always free the previous sync
request state before assigning reference to a new one.

Reported-by: syzbot+39ec16ff6cc18b1d066d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=39ec16ff6cc18b1d066d
Cc: stable@vger.kernel.org
Fixes: f60cb30579d3 ("Bluetooth: Convert hci_req_sync family of function to new request API")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_request.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -108,8 +108,10 @@ static void hci_req_sync_complete(struct
 	if (hdev->req_status == HCI_REQ_PEND) {
 		hdev->req_result = result;
 		hdev->req_status = HCI_REQ_DONE;
-		if (skb)
+		if (skb) {
+			kfree_skb(hdev->req_skb);
 			hdev->req_skb = skb_get(skb);
+		}
 		wake_up_interruptible(&hdev->req_wait_q);
 	}
 }


