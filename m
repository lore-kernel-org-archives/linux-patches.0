Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3C03BB69E;
	Fri, 15 May 2026 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861130; cv=none; b=iqkk3aWLpWIy47suV1f9Rv4xVCVlFl5+fUFlyboap+BHz6aCkIr5TZ/Ao42o14gCfrZah1SBHccP9c+3fNyCeHE7eJwp9gOw1++8ey7/tHT3OgDBGCZrgJig+byAsc18GiMbeGhgKz/ntFXutHWriXT6f4BVXbqJ8GBNGiZ0cjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861130; c=relaxed/simple;
	bh=oNVc+p4LVRwSFW2YtJ6wBbgylEp4iNLXrkjsjYs/bE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKIWa5veD5pBsch0S+r5XQhdCIgLcpWTLc7UUMXRyBvUoABXkTpV+AfWu6/1YIXsgNUn9IjytS3h0UjR2jlBd2B0Nc1tf1FFyx8Cf/r5OpmLNyCnaJGv/c7kiyssyUqGbZf+A5OtQ6mJdNPL7p6ICdr4SuWhD2gOu1IsUhJC92o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdPPFbBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdPPFbBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B905AC2BCB0;
	Fri, 15 May 2026 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861130;
	bh=oNVc+p4LVRwSFW2YtJ6wBbgylEp4iNLXrkjsjYs/bE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdPPFbBd8YKGEsvKEHnZ+Bo40XPuKZeSpgpyRikvPuG1StEvSAd+V/zqVtow4g9k9
	 3zI9//m0sUFJPT5m/Ck3F7ORzTNixmUsWxpRbdk4ut48+W8vKzLKgkf4V4d0Wv5t5u
	 A3YFfdHtUKE9BbGrWoRoZpSHYbp5mNfu0kwmC940=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 211/474] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Fri, 15 May 2026 17:45:20 +0200
Message-ID: <20260515154719.576954612@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1464,6 +1464,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


