Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BB02907;
	Tue, 20 May 2025 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750518; cv=none; b=frbhBczwVbUuQvlLZxR90tS1YNdv4K3syatrW0NTey7g3k6k/bZpuGjLUNAGAZSgu5e/7SmTPqrmWpemCnqGO4BLui0aHq4Z56DZtxD/DXCu2U8COK3/3BGX0c3hwdPXbe+iK5GpMvN7CEjVC5bZjjL2ltW1IQknYxgBi1ofUPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750518; c=relaxed/simple;
	bh=RVLfctzsQ918M+Z04XjdGWw+N4baU1YJZScy213UdeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDjSO3aA4WheBdaO2Jq8m52rAZv4bw3ngNCXyCknivXtlm6mrr6pacJl1eSfXGuDB6pKclMc84NQ32prBKBdHu0dHFAPrzdV7G81teVOVgyz/46ghNxuB22JAYTuGihzXXRo9PMnMW+zdCnohY1vNEiOcgoqkZx6gr9ZQty65Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G16AieC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G16AieC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B33BC4CEE9;
	Tue, 20 May 2025 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750517;
	bh=RVLfctzsQ918M+Z04XjdGWw+N4baU1YJZScy213UdeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G16AieC5TZPFU+1f7xBsbznjijphe16IUdvUpQ78h3SnYYWrFTmTHE0HRhh/I80bJ
	 ZEd+STZhp4rjyAy5qT7u4pShomWKH3LOt7uuPNSilwm3+znsetxPIDLqr+b8Q3kqOX
	 xjm2Cp3gzrZPRQUt5e6rYE8T6Q359M7kMVMRwLpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 033/145] net: mctp: Ensure keys maintain only one ref to corresponding dev
Date: Tue, 20 May 2025 15:50:03 +0200
Message-ID: <20250520125811.861570454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jeffery <andrew@codeconstruct.com.au>

[ Upstream commit e4f349bd6e58051df698b82f94721f18a02a293d ]

mctp_flow_prepare_output() is called in mctp_route_output(), which
places outbound packets onto a given interface. The packet may represent
a message fragment, in which case we provoke an unbalanced reference
count to the underlying device. This causes trouble if we ever attempt
to remove the interface:

    [   48.702195] usb 1-1: USB disconnect, device number 2
    [   58.883056] unregister_netdevice: waiting for mctpusb0 to become free. Usage count = 2
    [   69.022548] unregister_netdevice: waiting for mctpusb0 to become free. Usage count = 2
    [   79.172568] unregister_netdevice: waiting for mctpusb0 to become free. Usage count = 2
    ...

Predicate the invocation of mctp_dev_set_key() in
mctp_flow_prepare_output() on not already having associated the device
with the key. It's not yet realistic to uphold the property that the key
maintains only one device reference earlier in the transmission sequence
as the route (and therefore the device) may not be known at the time the
key is associated with the socket.

Fixes: 67737c457281 ("mctp: Pass flow data & flow release events to drivers")
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20250508-mctp-dev-refcount-v1-1-d4f965c67bb5@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 4c460160914f0..d9c8e5a5f9ce9 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -313,8 +313,10 @@ static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev)
 
 	key = flow->key;
 
-	if (WARN_ON(key->dev && key->dev != dev))
+	if (key->dev) {
+		WARN_ON(key->dev != dev);
 		return;
+	}
 
 	mctp_dev_set_key(dev, key);
 }
-- 
2.39.5



