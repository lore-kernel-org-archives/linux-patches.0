Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6A651FCC6;
	Wed, 30 Sep 2026 18:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793623; cv=none; b=Yb+kyu51I/p8MsYhBWjtkUdgm3znLhUq4tDZ5omScxMeCVKrg/hq2NPI4UxR74asojTdKkc13VxbL/Ai87kbDDLvKb3Ou2ZVUo3NsFQjBlRprwcEdirjN5GuntPAAj4TNouYDr2kJrzKKpWsG5sNMGB71EdUPQZ+u7mzAtMpzeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793623; c=relaxed/simple;
	bh=ok9tsgPjwdRwliyZV+Nvs9iG0MrasMRdadDWcMPPrzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iK84LsonHhou1+GYGZ2wPlDDCrRXDUADKQuHXN0nm6Lb1WWAvhzuGKhJOQBxz8/EgJnktPooy9nR8944REU0ySenFnz8hxd5ME6LJNjY5IijWYnb1U+zUb8aEk0za6N8GkmmqMI5TgoUmC1C/uY4u7SPDR8AfIvmPEnGimlxchg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0S1ZWlIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0S1ZWlIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE4A1F000FF;
	Wed, 30 Sep 2026 18:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793622;
	bh=QyJJzEXDCw8EBkLqlWOnCUVL2m6qf0tb3rnWL2daUs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0S1ZWlIRfHfQS/LKdPackGXWFdKwc/u1DJZbaS6Gm5xI8sQJvIaL21sFlvB5D2dJx
	 5BjYAvhGfWJuGQCCHkD3rd+MrG5WieB+nRAYFhcHzZkSD3LKO1wREujTxoc6KVdqnO
	 w66HWMgmxY3TYDuDfQvcCzbbuTRAx3jKXMT4VzpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <weir@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 275/395] net: arp: terminate device name before lookup
Date: Wed, 30 Sep 2026 17:28:57 +0200
Message-ID: <20260930152346.626574994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -1278,6 +1278,7 @@ int arp_ioctl(struct net *net, unsigned
 		err = copy_from_user(&r, arg, sizeof(struct arpreq));
 		if (err)
 			return -EFAULT;
+		r.arp_dev[IFNAMSIZ - 1] = '\0';
 		break;
 	default:
 		return -EINVAL;


