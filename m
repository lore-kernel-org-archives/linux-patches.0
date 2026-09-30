Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225F4F93B9;
	Wed, 30 Sep 2026 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783940; cv=none; b=OEqvwV9jCi9wsPZooXgEGUWhq4NzJ4vuGWPOnw2B+5ol5vcgI5RzP+vbsJgWoytfiSbJJ+Bf47C2TWTuZ+s2Wcfb1MQkhR3zlUgLuaoCWR94NWsgxIVC8nnShPnQc41ycNVje7nEfsixvY+pFsrsgxV790/6qYJ2KGmJBnwEl2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783940; c=relaxed/simple;
	bh=Gp7RXrhmTU0+x7i+3kIDvo1Rxanouxo1JN7K74R7F14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQmzlRWtX22ZzQbmMRvZLza6X7EDzDOAHt+kqpB/SSs1HxttRexQxxIfcdc3cfWiqXKvCw38OhA/J+jD4GDphbVZztONwO/LHJQhq0xgJ8tib3G7UsT0EaSEbvMlUrNU/opc9ZxURw8/rnWg2zLRFNUlHaaB4ka/P/y7M6ap9jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRvlYNgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRvlYNgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5839D1F00893;
	Wed, 30 Sep 2026 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783934;
	bh=PCP/WumqT8LW7zYCxSRz+NWz4CCggJ/twoiyCP723e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRvlYNgnkVgtM09YeR0IP7x0CDO7/GURhhWvfRvhwLbd4v399TFskJEiroqhJA8/H
	 xREnk0lffEfMwnw0r4vFDwcb0fNB6eoJdwuOr7/43Cw8fy+SiVhQ66+QjWB3y/cK00
	 yzGcaHZncoN8FXheP3T1UOpfRT9wi+oiCMpjriiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <weir@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 573/595] net: arp: terminate device name before lookup
Date: Wed, 30 Sep 2026 17:27:46 +0200
Message-ID: <20260930152400.056042664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Zijie Huang <milkory@outlook.com>

commit d8b6529e80bcb4fb8177121404cbb3377acaebd2 upstream.

The ARP ioctl copies a user-provided struct arpreq into a stack object. Its
arp_dev field may contain IFNAMSIZ bytes without a NUL terminator.

Such input is passed to dev_get_by_name_rcu() or __dev_get_by_name(), where
strcmp() can read past the end of the stack object when a matching
alternative interface name exists.

Terminate the field before the lookup to prevent the out-of-bounds read.

Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zijie Huang <milkory@outlook.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/fabf02a70787d17299e4b3153eadffaf20d154b3.1789910973.git.milkory@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/arp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1201,6 +1201,7 @@ int arp_ioctl(struct net *net, unsigned
 		err = copy_from_user(&r, arg, sizeof(struct arpreq));
 		if (err)
 			return -EFAULT;
+		r.arp_dev[IFNAMSIZ - 1] = '\0';
 		break;
 	default:
 		return -EINVAL;


