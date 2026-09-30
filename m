Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9629A3CC7EB;
	Wed, 30 Sep 2026 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796183; cv=none; b=kUXVeRBc8aP1BDX2rIFWljfFXNQKO8camgtxSca94UIFi/Q5s9EwoltljBU2WjVOSpLGbcFAU4mzql3sTNVKZ2OCncrkdD4ttKBzFpsnD+Vu1cjzj5RVRCz108AIt1G2/D1twZyNqOJgUVpR07n0f/jtGhUdY25HrYVGnQi1Y5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796183; c=relaxed/simple;
	bh=fsEuFshFC2Bts4jKG9I4NxAwveaNF2xW0gyMS+9A1/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcpIIhyWgV0Psnqs4XQ1cCdM6pEi0B/672TrOEZBhhOZuxluY9l9TeBqafmdSt7GeHSQ7hS0tHaT0CPOXfC9woBTEHBwj9RsncrIURmm0bZq5daA70gFQRE9aN1JYE3iXkDqHZomkvmGq5HNlP9FaiiJk3sa4x1QZZeEX3dVs8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dC83QfL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dC83QfL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07DE1F000FF;
	Wed, 30 Sep 2026 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796182;
	bh=F6RvZ53hrDXUUcnmyPIny3CW8Jod2AqEnFSzBtEdS44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dC83QfL7SCu0cQ8l1vrGw8cSZsaruahhvKctd+idIjsrPXHnRTtfaxCCYpb4owCsp
	 5MPO8Jdb8JKwn4NHzgymNaBgoQ3vhXDGsauUTvt4eQUUfKVFT57QmlENvCG+gHkw+V
	 0XW4+ARVKAsUeI+VVlEcphymOpOM5F/9laQaAV+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0806/1193] Bluetooth: ISO: Fix parent socket leak in iso_conn_ready()
Date: Wed, 30 Sep 2026 17:24:50 +0200
Message-ID: <20260930152452.149768022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ca18ee413a7cb6f09885778039225e58bae0d607 ]

iso_get_sock() returns the parent socket with a reference held, which is
dropped by sock_put() once the child socket has been set up. The error
path taken when iso_sock_alloc() fails only calls release_sock() and
returns, leaking the reference and thus the parent socket itself.

Drop the reference on that path as well.

Fixes: fa224d0c094a ("Bluetooth: ISO: Reassociate a socket with an active BIS")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 23776ffbc60a3..23bd4d8c397f7 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1772,6 +1772,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 				    BTPROTO_ISO, GFP_ATOMIC, 0);
 		if (!sk) {
 			release_sock(parent);
+			sock_put(parent);
 			return;
 		}
 
-- 
2.53.0



