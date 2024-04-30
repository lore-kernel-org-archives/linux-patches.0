Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCA7464;
	Tue, 30 Apr 2024 10:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474735; cv=none; b=REIb9pHrfJ9dhDbOWemzjTTY6zOoLWTAnnwJAeYXOQtWIJ30yWraTP3STHCIk85biDx+66HHMlMBsP22pES7FLIpbE+q1gUiFA0yvXYF0HtP7LwxMd+9ZEc5XaakZ9NlUWXtJKDW9P4/xa7Xkj+j3oFiN3CLABDMjIeMU9NY9xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474735; c=relaxed/simple;
	bh=CJKBWvH/xrlUdDdIFOTGKh4hqM3+Ns5oCr4sN67BRmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3k/oF2mre/pAohza7Kcyo99PeBVaeu7eIkzaTDTwd3+lYZtfDKRWjYpK9K44PMsG3qpXU3LX0/kzKN4R+9+gRjVt3L1Z5jYocc/VdJfd/F8E5JfBnbyaX5QiUrT2SuiUEi/fNwwaOqeKGM1wWVl9uFOoTxGwk9FEnl+/nqfgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4pG4wkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4pG4wkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257F0C2BBFC;
	Tue, 30 Apr 2024 10:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474735;
	bh=CJKBWvH/xrlUdDdIFOTGKh4hqM3+Ns5oCr4sN67BRmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4pG4wkZBmfgCLRq6/LgkN2IAlHSMSleO8LQijP0zLfeJroRZZePJ0YPkqakyHjx6
	 9oh9JzZP1rZPdcoxcvjzSJ4TF6r7qbUc+Dq/1k9lmqO4bhnLe/GV5Kze6z6zNarbkX
	 DkX/IR+kYEWGyUxe+/4PpNMsNU9VqtDyPslWD2Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39ec16ff6cc18b1d066d@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 002/138] Bluetooth: Fix memory leak in hci_req_sync_complete()
Date: Tue, 30 Apr 2024 12:38:07 +0200
Message-ID: <20240430103049.498047877@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -107,8 +107,10 @@ static void hci_req_sync_complete(struct
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


