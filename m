Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF688801;
	Tue, 30 Apr 2024 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476053; cv=none; b=KGDbAy/byiqa4aIuQQ7NK5znIcONouVK1JQcob7W7Re7EgCrnVAUpzHpmpZsGCPOBIuI2M8K4SHTvtXMXHFQmCh051qjLIuaWyswJ9edE6qNgpLmZl+H6YvRtQjZEmUIg42KWpU+zZHEPPaFqDRUabC30C266MpCYqgcTmFQNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476053; c=relaxed/simple;
	bh=KnfD3PEtQI1s1Bhd1kjMc+BqSkY3EYz1zbeFad/uZ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDosXavEyWKB8sTS/GEqz3wcMhd2WxQppOH4fA7EciYP8IiIVSzUAMHxnTEAHhYMUN/dwNLI3ST4t/VjIpDTn93T1T7yD5qIXe+F+A5hgbuQmxV67j87P/unMo42XV18p8rTzJTeIkGX1M9F0z1Un+MCaIsbS8imfHuzF6EANI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG4Z4BlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG4Z4BlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95D1C2BBFC;
	Tue, 30 Apr 2024 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476053;
	bh=KnfD3PEtQI1s1Bhd1kjMc+BqSkY3EYz1zbeFad/uZ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG4Z4BlZq999t7Jl4it4dXoI2LVtqxmeqrpjyvR9IvrqW5Oc1kZmbYN6uU8DF/6uO
	 wf4z3DG307DKa2Va89HoW7ObM5wzVNYosktooiMg8sy/wmvQQAoH4e83DFCF00WEYP
	 uWtaWSaU1ZJ9gTrnSD7CxW/WGxaGfYs38Dty5pVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39ec16ff6cc18b1d066d@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 002/107] Bluetooth: Fix memory leak in hci_req_sync_complete()
Date: Tue, 30 Apr 2024 12:39:22 +0200
Message-ID: <20240430103044.730213999@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


