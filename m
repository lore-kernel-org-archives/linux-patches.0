Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9873002A9;
	Tue, 12 May 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608428; cv=none; b=Qay3uN4Hwm7ipVvtAH6Ui7RmAaZ5d3T5/sD/0Q2CDqqZ/AhVum81CbTo1LO9H66qITROWwm7A0gH1peP53C+FDWhqYcq9GOlWH++Kh725pa4tjbf1Z3vYkzx/iPOBoa6cfqU7KMhwuhUFS6spDrF9bv6i20iQULP/k9Dy14PBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608428; c=relaxed/simple;
	bh=Vf07paAlrQVP89G7gI85KiRWn9Qoezw36t5eeEzmJsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyPjMbnqSNdLiqN/xtq4jDXtn7/3ZcrJZJMOeTOVE4erPbFSgI7KMa07SeWo5pWv552SBZyc6mHNOEAYNTVjzxp0JCA9+duOQxcxQGD+OiDxA9k3PnslUduy1sefVa2DNNRpprYPeJuQ/zrFOLXWJN7qia3wgCyvZIpWkNj4QCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3cjSZg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3cjSZg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F2EC2BCB0;
	Tue, 12 May 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608427;
	bh=Vf07paAlrQVP89G7gI85KiRWn9Qoezw36t5eeEzmJsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3cjSZg9RpnwSp4tWzFT+QsGT2GqGZhtbvjtq+vGoBSsXn0WFETsnMjmMk50R6BaH
	 L2wen4QUxHSbdRif5A8gV1sPeYl14VCQcAwSXiVZuHhk9i21DSGbHYDmjE6xKfXdXe
	 iZSc0SHUZafcDmh+CLmerZvxw/+UWswFr1vtWl4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 073/270] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()
Date: Tue, 12 May 2026 19:37:54 +0200
Message-ID: <20260512173939.988529291@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1643,6 +1643,9 @@ static void l2cap_sock_state_change_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	sk->sk_state = state;
 
 	if (err)


