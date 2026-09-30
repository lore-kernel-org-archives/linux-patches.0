Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C74119FA;
	Wed, 30 Sep 2026 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797047; cv=none; b=kKXQcJXk0ZipUcpaUtfm2/Nh2rLm/XYxTrjij6+9SEykZRmD5/glJYSTerZk85YoZrTNSvckWg0I4DN0FqR1m4uqUNL3ar5tJ3dk4evcdj179x2AQeXVsRTeIqkz/FXHOymG253IxnybU8JUFRCsTttuTk6MwD1E5jfNDJAm6xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797047; c=relaxed/simple;
	bh=3pi/FD5Kd1QKvXypRQ7tSeUHb3J8tE/GpPBTP+wfsRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/VQ5Y1HNO/705wXDUu/3hrmKpsCkPF3t3tecOEon7LtLRXd2O559P6SF0ogEqEeD9L34wom6dcldnaP3iwxpO+GHuAJ2MzC9FO6VdGanMGu4pE0qokN3wR+Rj5vF4J6ziBNi33UsK7HKU5Uvndxa51DpNQAEH3EozxOjZwGr1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHWGYi4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHWGYi4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607C21F000FF;
	Wed, 30 Sep 2026 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797045;
	bh=Lcuv/vI1KwgdCR9ZdVtxXNne6kNf/8qXkruIERd3lLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHWGYi4K4GMACSGsnPoZj3LfcxX5iE7ianah/N5HpRRDpg7+mY6nbJk4GlOxmGiG+
	 M95ons0VGWLFpR+wqtwSWPhIuT/Nof4l+Xv7QH7OIW3RVlHSUG0Tk5GXKCODDGF5Kv
	 ku6D5d6FYq7u5N1yuZmXfyXMDa/lKHEi9vAfhB10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <weir@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1127/1193] net: arp: terminate device name before lookup
Date: Wed, 30 Sep 2026 17:30:11 +0200
Message-ID: <20260930152459.277823249@linuxfoundation.org>
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
@@ -1222,6 +1222,7 @@ int arp_ioctl(struct net *net, unsigned
 		err = copy_from_user(&r, arg, sizeof(struct arpreq));
 		if (err)
 			return -EFAULT;
+		r.arp_dev[IFNAMSIZ - 1] = '\0';
 		break;
 	default:
 		return -EINVAL;


