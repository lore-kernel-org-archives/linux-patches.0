Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF6E51118E;
	Wed, 30 Sep 2026 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786015; cv=none; b=NF7/S0f+MRdWI+mQ1lfPpZBUOSjvr6S2nWnE5Rzr5kvUTmta8z8O6KGWFoN7Tp5z5vorML57rV3+X8Ji4CBMg5bdt6hhty1XRG4iGSXPSJy1OgBc+EtWbq93WFATKXLawD0N1e5htTWbjsvZB8Y6FmdqvNiIMST+dIVmve39/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786015; c=relaxed/simple;
	bh=empdlhUbtzgrIZdSyKTRKryfn2BFB89kNE12eGykjws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOZiVZEi/MFH+Nduyy62FamtXUFaGhWtU0Kq2+3QrjobGUXqJ0MVXuHW1NJ20E5fRo9wWus/2wpMm/STSYogx7INdaOhjJFk1SoBmEQ58Ev1qaEEULeFCkH3dJGtEdbCx164xE/Rrqh6JdzjRXxKS+t3WHT067MpuH1xqwNH8MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+CKcRP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+CKcRP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C711F000FF;
	Wed, 30 Sep 2026 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786013;
	bh=E9B87U3DcjUOI/7fKnOwFvOtWVZFNqC7srTX9kOAl6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+CKcRP174CfHk7oOYZ43rPSuti3Ab30PdZ8uqlSBT/ZPvqZJIP/1O53ZO1H6wiZV
	 yKKC2i8IkGNb0pbQosFm4GX8vmEwty75OF7d1D+mo1Om8JwG/5BL5XZdKwLmFXSlvr
	 JZnsFiNdBRH3lq6ggsVsmSVcsG7yeQ+AdfXIf8VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 712/982] Bluetooth: hci_sync: Serialize local codec list cleanup
Date: Wed, 30 Sep 2026 17:24:08 +0200
Message-ID: <20260930152432.050349020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 9a10987a2f160a44a638c9a35994ca6e3089696e upstream.

hci_dev_close_sync() clears hdev->local_codecs after releasing hdev->lock.
Codec list additions and both traversals in sco_sock_getsockopt() use that
lock, but the close path does not. A close and BT_CODEC query can therefore
interleave as follows:

  hci_dev_close_sync()          sco_sock_getsockopt()
                                hci_dev_lock()
                                fetch codec entry
  hci_codec_list_clear()
    kfree(entry)
                                read entry->id

The reader then accesses an entry which the close path has freed. KASAN
reported:

  BUG: KASAN: slab-use-after-free in sco_sock_getsockopt+0xfa0/0xfe0
  Read of size 1 at addr ffff8881001c3450
  Call Trace:
   sco_sock_getsockopt+0xfa0/0xfe0
   do_sock_getsockopt+0x537/0x7b0
   __sys_getsockopt+0xf2/0x170
  Allocated by task 92:
   hci_codec_list_add.isra.0+0x2c/0x440
   hci_read_codec_capabilities+0x224/0x590
   hci_read_supported_codecs+0x2c2/0x640
  Freed by task 92:
   kfree+0x131/0x3c0
   hci_codec_list_clear+0xd8/0x160
   hci_dev_close_sync+0x92a/0xfa0

Take hdev->lock around the clear operation at its existing point in the
close path. This makes the clear wait for active readers and prevents a new
traversal until the list is empty without changing teardown ordering.

Fixes: b938790e7054 ("Bluetooth: hci_codec: Fix leaking content of local_codecs")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5362,7 +5362,9 @@ int hci_dev_close_sync(struct hci_dev *h
 	memset(hdev->eir, 0, sizeof(hdev->eir));
 	memset(hdev->dev_class, 0, sizeof(hdev->dev_class));
 	bacpy(&hdev->random_addr, BDADDR_ANY);
+	hci_dev_lock(hdev);
 	hci_codec_list_clear(&hdev->local_codecs);
+	hci_dev_unlock(hdev);
 
 	hci_dev_put(hdev);
 	return err;


