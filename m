Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4A3EDE48;
	Tue, 12 May 2026 18:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609234; cv=none; b=DRkdLHjtitW5hyzcaWNS+H1I+nNfLZycJQF9qrxdiK+JJggkRKGYfctcj4QKfbLX7G2fDBNxfMeUGB3ZRau58TFCnj7JdCtRH/b9bKDk8l/SqThRF5eRQL5K/ggoKojSz5cXZqhAw34OKyIjxDjDxmkkKq25Cg3uRSC2bYNXAEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609234; c=relaxed/simple;
	bh=4rKh/9SzDYkr/aA+7d51hTugqzoxS1xXhTQZckzD+Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/amGrTEN3mtXgfJIkWqUnSHLRZIyMeJWUnIxtHT+Pyx9o2vWd20IWA8YfyBvqxycKFNpZGxa3DZ664D0d/6nfGVlFsq/R1dcIB33BLYHsQd+YKRbPDVK6VC1bhFdpiNjM9G3zvCIV3pUAGjPFQr0+55y2w3Hv3BX5yBkRMQONc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+RByQI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+RByQI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BBCC2BCB0;
	Tue, 12 May 2026 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609233;
	bh=4rKh/9SzDYkr/aA+7d51hTugqzoxS1xXhTQZckzD+Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+RByQI/5T+V4qMZGiA7hz6x7364E2nuhfIkmximwkL6fOiyM3NTmBbQRssPpS7hl
	 XJP5w8TRYQH041PgD1tmMzAFeAlSBWcp2kfrmS8ezrUg3rn0R/mlrzSfuteBp55vzD
	 cKhgzFykCF+me1D4iT43IUpGgUORVrn2sbw7OYJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 075/307] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()
Date: Tue, 12 May 2026 19:37:50 +0200
Message-ID: <20260512173941.704318767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 2ff1a41a912de8517b4482e946dd951b7d80edbf upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 89bc500e41fc ("Bluetooth: Add state tracking to struct l2cap_chan")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1660,6 +1660,9 @@ static void l2cap_sock_state_change_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	sk->sk_state = state;
 
 	if (err)


