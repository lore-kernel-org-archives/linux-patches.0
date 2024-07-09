Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF79C155389;
	Tue,  9 Jul 2024 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523661; cv=none; b=n8MeWR+AKNTipe9pu2f3Ht0L6/qECGyTKWyFG/AVkKS991lgqd5KQxyVAop96yqDvsAxXqxRdlsiOEYOxVnCH6FiApajTT8PgSktjCruWQ0WEvSlTUDLymEA9UQ+O4zf6j3555xGShSZMhqu2E3UuDJY4bPeD+kT3618UfxxD9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523661; c=relaxed/simple;
	bh=wsy0oC3C4yj87ANf0f+B0WB+U6Yqk4O/iH3ES/XfHNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/vuXYuq5Ye98m5XT8GWoddUSVOkTv2Wbkj4QMOHkMtKYAkJZuWBYLa3jd51vpddUjTKz4p+zeBC/3BJ6lGUdyEnBQKOB9PZ/abf+V6oga3Y59+dnrRzhf6f5NHbUpoMvPoZZ22dFOv5rDlUrmNinhvEitNG8noPVZDFOwHcyjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGQUeNGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGQUeNGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79324C3277B;
	Tue,  9 Jul 2024 11:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523660;
	bh=wsy0oC3C4yj87ANf0f+B0WB+U6Yqk4O/iH3ES/XfHNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGQUeNGqPl4aPsA0nhSSnT0sxp0e127YE3Z3lM2D9ezijh7tj5CHpLYLNjQK45a9d
	 1xZ5cLhyX07GnjEctYx9bvGXZk+idrLKFOCyx4hUetD3Q4rwCBKkWELZn6jScDcd7e
	 ucBA7u/u3FjaAzZMXl00IZRKvnbuSdlmMjXbvtpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/139] Bluetooth: Ignore too large handle values in BIG
Date: Tue,  9 Jul 2024 13:09:27 +0200
Message-ID: <20240709110700.765547152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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
index ffb7d43597a2d..727f040b65297 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6905,6 +6905,10 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 
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



