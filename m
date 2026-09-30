Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E424D42882B;
	Wed, 30 Sep 2026 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787731; cv=none; b=JPmIB8BukGfUBRIjdacJkocoXdzdFgsni6EZvmsWxBsMGdF++9DOfox3pXg+cGZ4fgAEe2v/bpzbL6OaL44+4KVi1pEPbmy3X3cnvikRT13EZyN325Tib+NmpwCIPANHe/JSodG9wuYK1XoU2bALOiplx8Id8zW+w7wD6B3LxWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787731; c=relaxed/simple;
	bh=H13PVwCyJj9ct8xBZWhQfNXDIUDl5kAHqpzQFGvO87A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd2bJP+FZTXDUjTSGDNGu+VwMcDUKZEuywssEY77fg8bSY8g/x36yInAnF0068ybphuT061Yx+VMb4DskCr1idxH2gIy8V5qJts+firCk5JM6F4WbxkrIb/UkuAhqmDO0FCdL2xsE7p5hnTJ8YT/BJh/Xuy8L18eodktSLxUPsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrpW/XxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrpW/XxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89A31F000FF;
	Wed, 30 Sep 2026 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787729;
	bh=ByjlnPpEA+BQQf8W5Mw+Ziq+Nm9PY5wOEW30PspOdZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrpW/XxWNTNgFV4E36OVPLMYf8FHYB+6sCfa236e7ZFDipFcZTx0JOWe+SWXqs+YF
	 wTYCYGO/Hooqb0VcgY8NbzcoHHIuXz6Fd1uCgQqOgJfKW3MwO8FH8vp+OSKLoBviOZ
	 As8Thncv5PtmWXQMrS47o/X2Fud2L4a4N8LCz6OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <weir@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 332/457] net: arp: terminate device name before lookup
Date: Wed, 30 Sep 2026 17:27:17 +0200
Message-ID: <20260930152353.182688137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


