Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988C926738C;
	Sat, 30 May 2026 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165953; cv=none; b=XGJ5/FgtZppoDwfPjzFq38t7kt3BPp1C1/gHQccPci87dWUb4/glxnZmjnqwiWTFyRewSQ8w5EaDh3E1qBeS6FNGM7MMy+czdgzaXxrJxZoP6Es24UCqgrCNDMXKt9FI1mXuuCHw43tjXCq5HDJ7kSnSjr0OCLLKpedXlj7Sgvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165953; c=relaxed/simple;
	bh=2lBd1yRuOAdOjK5xUoj07oz4BnKrPYxs2UlBTSMQpKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kkfwf7ML05NqIB2xy7IWv5uEctZ2V318b+HKt+GYpwJg3rWWUUZPMIgApWEpnuylFQEHtEwp3gHgpfJkZN+NodBCGMCXj+FjePe7pikiUhuXs3zCmK0GKEIvlkJS66QZty3YhT15zJeWcXCMHWlTV5WlaPj7MSrqDqrxZeeKM30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA1aMpKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA1aMpKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9317C1F00893;
	Sat, 30 May 2026 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165952;
	bh=QanbMkmDUx7gGxW6UeD8N8tAOLVAgZcVK4ns54r+Caw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA1aMpKXZzasPoHW9bjJgOHihi0ePGSvjDJK4hcdjo5K1qE/Qss49rwswt9NNY3Pj
	 IJsHlaS0EB7lWB4u6Ejcde8ek0qRVvfkA6lssR0m4WGqouEejWPpDeZL1Nbp+3nKqo
	 N0fbzwVR3DZefe6jAaQ5lpuq8rJSb31UJ0qxIBes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 230/589] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Sat, 30 May 2026 18:01:51 +0200
Message-ID: <20260530160231.026796244@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 0a120d96166301d7a95be75b52f843837dbd1219 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 80808e431e1e ("Bluetooth: Add l2cap_chan_ops abstraction")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1455,6 +1455,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


