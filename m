Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCB251FCDA;
	Wed, 30 Sep 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789520; cv=none; b=CbN7sdWGOPQknZjfLJ7y3j1rNIJEgnld+S6skpr0XeP5BLIB5SkOTpeM1CHUSmlrgh5thVcgz6v9WXb04QGHg+HGxzp0N66ZMJ/iN+r/rJeUDb+NhrzvReRJwyjGGUgBTs+PoHMQEFFFVoiaU2pv5NiKHUD0fhIcH2UQLNx6w68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789520; c=relaxed/simple;
	bh=N8nPL0/Ce3AsUugcs8lLlEp9VYBikF0cHfiMyS00UkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7zv06Iwk5ous89infGEMlOY6hUuCawKQH3cv+Y45s6Pu/5jjTgTPsWxEq3yBdiE/U+gCGKocE7UCLyzq2lYEqWNgPeTPyamOcY9aFjRCo5stNq4sqnmqYlG2G007rtPaTjnKg2EvVUypLafru+ghXlmi9EN0NYYVLmeBx8041U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3Tk049W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3Tk049W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A5F1F000FF;
	Wed, 30 Sep 2026 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789518;
	bh=+XFEKdLUgL5BAyBMnTKsjTZQY8C/rSPN3VSe0UEaCRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3Tk049WyNs0/fBorEnJBYN1jz1Z1TI97ydhwo6qTF8EFCXeJU3fTgTP7b6/HvvdB
	 PCKZadlItM7bmwcSVBUvoITeIlUolUsa1d3kHQnwY6Trq+EBs7tcNjbe8Rzj6o1c3+
	 6+2D/lJEhPiNMbi3pn5c514wR7uNBdSYv7ImtAYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <weir@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 507/877] net: arp: terminate device name before lookup
Date: Wed, 30 Sep 2026 17:23:38 +0200
Message-ID: <20260930152425.601459461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1276,6 +1276,7 @@ int arp_ioctl(struct net *net, unsigned
 		err = copy_from_user(&r, arg, sizeof(struct arpreq));
 		if (err)
 			return -EFAULT;
+		r.arp_dev[IFNAMSIZ - 1] = '\0';
 		break;
 	default:
 		return -EINVAL;


