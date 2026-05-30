Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4697432D42B;
	Sat, 30 May 2026 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160362; cv=none; b=ld92ag1DdaJiWsO4uOzu1pPjZCotXt7ZvnppjLI95wTa92KD6edWdnLFlNsFs1ftGosaMmK6ZBsY7cnYXcXYXRCesxgELJ1JPDWCgX+Jmm/+2tUf+anknSIE775wn+GY5Ha2rOU9fPFGbKZfS6/ecBlgoI8baIxejBLAxPhnKLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160362; c=relaxed/simple;
	bh=z/wjeHk4aq/7JxaW+XZKKzWXfKCzOymynzlhFlgUH1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMA9aQDZ20IOkayApXZXgTnxtKN8xCRvJGWXk/lSpAribEn2MPJy9sexg2//3T2plIdzpZzFMEt4UCHKkrWQi3ACvb1FxQiiZT3+psAzdhtS8j1CJ0qcrvwvzMzOsLiVCd/qx/IYw7Co1BUU3fe0DmcrkdjryAH+0tk+47k08nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWlU6qth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWlU6qth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6281F00893;
	Sat, 30 May 2026 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160361;
	bh=6UOsdrDrG6fKgeLD6/x+b/90kfTovRhgTYijfexczTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWlU6qthxtHIigZSEzN8SY2Livt9ZBjTWq59KJiRTT4/pT8ETuKOzTdauGOdOlwo3
	 ilwqGY6FxRXtQuR8pq3u5NUeJR8fQYw/Z8LkdHHdRgBLOEfdgk+vitpMPIakyI+OAo
	 nHy1Rk06Ql/GJZ9xds5j9bdo/OHA69QT/0JF/54M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 318/969] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Sat, 30 May 2026 17:57:22 +0200
Message-ID: <20260530160309.188553854@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -1500,6 +1500,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


