Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC2013A25F;
	Tue,  9 Jul 2024 11:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524293; cv=none; b=QKRTbNNFWBlYNdCtlk3cuDtTmlss/xZDryKS4mzKFDYn4IfDRfZ5kU2BljUnjf9+1DFUpwmn67CyAoJq1Zfv3urpM/37gR55+l0fMxMAkNOatS0irnWx/mBa75kr7yD9z1F2x+A4AhKsF+Z5CLTN3cqMa92YR7B1G/vdKs+IDBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524293; c=relaxed/simple;
	bh=Wjt7z0yvxIjzHjh/G50Hd3PFPfvVmcQGMT+9VKHjdLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyJygjeM+FQz6XcXpCHzzhGvlv/BWO16NncOJGjjMXj51rUv5fgQdsEfKjZ+KcMwnVbUt2wkZpisbjS6fNeBx4cVj/JZ9CD+fjASwBZrRV0XRQ2YQotF6DUTUtFBpQFt5OO99G30mDzGfiP0ysYIwkpoUQAXCumSOtm1YFbnnPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBKDPMe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBKDPMe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5B3C3277B;
	Tue,  9 Jul 2024 11:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524293;
	bh=Wjt7z0yvxIjzHjh/G50Hd3PFPfvVmcQGMT+9VKHjdLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBKDPMe6ugZBIGH6XhTyp2ODnibwb3wZrVwoavBgmqhqmI6tcI/sQ1YLAUHtm2iYo
	 FxsMpkk7v9xPI0GrrGnZ825qYP4HantVXr2e57pd68bSWCIYK1XfFvRjINaq3JzTbz
	 Ca5+GnrXvDDSuK0LCwf9PbvZmKoW4UkSTZxq1JAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 095/197] Bluetooth: Ignore too large handle values in BIG
Date: Tue,  9 Jul 2024 13:09:09 +0200
Message-ID: <20240709110712.640699363@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 015d79c96d62cd8a4a359fcf5be40d58088c936b ]

hci_le_big_sync_established_evt is necessary to filter out cases where the
handle value is belonging to ida id range, otherwise ida will be erroneously
released in hci_conn_cleanup.

Fixes: 181a42edddf5 ("Bluetooth: Make handle of hci_conn be unique")
Reported-by: syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b2545b087a01a7319474
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0b3a76fcfedf5..eb59f418eb6dc 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6910,6 +6910,10 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 
 		bis = hci_conn_hash_lookup_handle(hdev, handle);
 		if (!bis) {
+			if (handle > HCI_CONN_HANDLE_MAX) {
+				bt_dev_dbg(hdev, "ignore too large handle %u", handle);
+				continue;
+			}
 			bis = hci_conn_add(hdev, ISO_LINK, BDADDR_ANY,
 					   HCI_ROLE_SLAVE, handle);
 			if (IS_ERR(bis))
-- 
2.43.0



