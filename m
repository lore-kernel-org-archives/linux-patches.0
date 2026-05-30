Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92454261B9E;
	Sat, 30 May 2026 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163592; cv=none; b=fYy0EVGgp4QzM9b3h1MbRNJYMDaqhubOCTxB0xkXisSGEC1i87mWonDbB8zDR/zm1PE2YlAZtfUas5Kuxv49eMQ3nxvGGeZP6e0s5RnEBEVGrGapeuWO3OMjYlnJpFOVLHnnvT1ZhdI/K8NpLfMFPKS9qZH5hOQvN3wMWKjhjg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163592; c=relaxed/simple;
	bh=y546Oj3H7ghCTEupcqCr39iBRsEmjV6jprhrEeI50+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEY2Z0NjEIbO5atdyvctpGsJpggjwhF4UPQ7EHSDX8HeoJ5oRyBgkKc8Setcg7uqbvahjqyCUsEyqJ9JpTSkcYmPCI+vbdra1GC1iPhJhxtHzvWjE3S/Cl9nOCL7Ruz8sSQ7f0bEh/lblh6/wxzToMWvSFTP/4WOAQNn0v2xHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8AczbbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8AczbbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F9C1F00893;
	Sat, 30 May 2026 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163591;
	bh=c0kIAkzNN7TrtndRQ31Eiy1LkMEO65Q+lWuQOp3tQXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8AczbbKceqBmuXH5LkYJV3MdLbXSuic3kNDvHSuW1/eQ63Q5AExOwZvlgCpJh3Hq
	 IotJiP732/RncOJfPBOi7Nth3/zwHNfi3t++xE/nnGg4ZIjIOidAf3AXQ24qij51YV
	 aBfScfmXvuhX03nqd7jeQpnjwiDcMb7xnuk9k8/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 305/776] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Sat, 30 May 2026 18:00:19 +0200
Message-ID: <20260530160248.451918495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1467,6 +1467,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


