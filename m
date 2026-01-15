Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59031A08AF;
	Thu, 15 Jan 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497057; cv=none; b=UlCH/D3IuDg+zIimwvcmAy+fiF//VBLIk1Aw47etz08KT5WzACwQPOrsXrIIulSKTc9GhoA+cpqe+1KMcaWZ9uerSqP6x7RdGpPDqBula5x2NIed3bl7vuqaxuGBaEJK+vMBxnN4oY7yL5SbEHXVlEFrX9DN4UiPTvNJXdFBS84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497057; c=relaxed/simple;
	bh=Y9yRK+0zPf6eqrzB4s+m0KLlbLy4W8yPNrOO5fAE1Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ut+7kuoKTSqNV5Wh8ILwdhIKd9tfl9FotDB6Q7A6ECOpTCV9K0qrGS0fClsOf0ZmIugUx2f6uEArJJFgO222KdSbD2Sbq7N/6iNz9vMa1aVJTCF7MY0mCml1DOc7JQ2VPAP8nEvvG/Wzc3lBQhmxIlMxNA77EMMgEYGzeAVQ6LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KA+1LCBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KA+1LCBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A280C116D0;
	Thu, 15 Jan 2026 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497057;
	bh=Y9yRK+0zPf6eqrzB4s+m0KLlbLy4W8yPNrOO5fAE1Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KA+1LCBMJTDXpoqpnst/i9bJc2EzvpJpJ6QA4tE/MEiseer8wrWpeHspv65KDmG4H
	 k1qWovK5BdR7g5cMXGfTFpt0ciT3/jdVjuYkP2ezUxK13xaVYTvocfMOVm29wW73ie
	 ZrCT+1KnavMSwd4pWaF+g3E1PVkEc+N3t6qDtMf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc7323743ca6dbcc3d3@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 09/72] wifi: avoid kernel-infoleak from struct iw_point
Date: Thu, 15 Jan 2026 17:48:19 +0100
Message-ID: <20260115164143.829049712@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 21cbf883d073abbfe09e3924466aa5e0449e7261 upstream.

struct iw_point has a 32bit hole on 64bit arches.

struct iw_point {
  void __user   *pointer;       /* Pointer to the data  (in user space) */
  __u16         length;         /* number of fields or size in bytes */
  __u16         flags;          /* Optional params */
};

Make sure to zero the structure to avoid disclosing 32bits of kernel data
to user space.

Fixes: 87de87d5e47f ("wext: Dispatch and handle compat ioctls entirely in net/wireless/wext.c")
Reported-by: syzbot+bfc7323743ca6dbcc3d3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/695f83f3.050a0220.1c677c.0392.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260108101927.857582-1-edumazet@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/wext-core.c |    4 ++++
 net/wireless/wext-priv.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -1084,6 +1084,10 @@ static int compat_standard_call(struct n
 		return ioctl_standard_call(dev, iwr, cmd, info, handler);
 
 	iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+
+	/* struct iw_point has a 32bit hole on 64bit arches. */
+	memset(&iwp, 0, sizeof(iwp));
+
 	iwp.pointer = compat_ptr(iwp_compat->pointer);
 	iwp.length = iwp_compat->length;
 	iwp.flags = iwp_compat->flags;
--- a/net/wireless/wext-priv.c
+++ b/net/wireless/wext-priv.c
@@ -228,6 +228,10 @@ int compat_private_call(struct net_devic
 		struct iw_point iwp;
 
 		iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+
+		/* struct iw_point has a 32bit hole on 64bit arches. */
+		memset(&iwp, 0, sizeof(iwp));
+
 		iwp.pointer = compat_ptr(iwp_compat->pointer);
 		iwp.length = iwp_compat->length;
 		iwp.flags = iwp_compat->flags;


