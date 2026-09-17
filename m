Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB174E2F08;
	Thu, 17 Sep 2026 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660358; cv=none; b=GFsTgx8CKW0OChddU4W4zK7rd6ECY9Iil00/ar4E6ODS4CzxJtlfDJUaUNROYWad66bFMXeAydSy840yHeYiQcq/cQ2k1W58Nd7VI3V0hgjer7zBuGtflNtb674NuuY4Jz+7QOLAAZGHcouXRWa+mrhdL+ZCX9qWOLf2/Jp2sGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660358; c=relaxed/simple;
	bh=nmmZiVhC86bga9qDkJX+RJELR0AcZV3IRVmQCrz4/yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFKBlteNPWAfFIvoCucXD+UlSrUtCpuxU3yxgpK1YdJeP0rqujPlXFQGrNtTC+rv4QVLL09DjDP/d+qP/Guo/8WW764cJz6y/iTpUrTmzAnXcoBbPfLhtr1brfNeydzqiDI5PzmfqaOi0pT8hHAGcWu1h4tPew6H+1iuVkh0cQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9avT3Pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9avT3Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76781F000FF;
	Thu, 17 Sep 2026 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660357;
	bh=IbDUvfFVDLVLkXttfgd97jcGBeo7SzkBAYFeC2OZcTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9avT3PvQBKMwehWUtU5hrJvVRXpdGifr9szhoHuO07TcYplrtGVdToHupyBERDsU
	 avqecqUXzV28p5gmknZh8xnqzKb2fYShzPXhR6g51nZq3TTaVFf9af7IfXiTzCKd65
	 qerUin7jnwctYP3ZeQVEXa0J2rB0yl4TH4ZpU9lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 7.2 564/733] ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink
Date: Thu, 17 Sep 2026 16:14:32 +0100
Message-ID: <20260917151406.379984493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit bf79662bc85e820ac3b846e2f347da29fbf6ac95 upstream.

TUNSETLINK allows a TUN device to change its link-layer type to
ARPHRD_IEEE802154 without initializing ieee802154_ptr. lowpan_newlink()
checks only the device type before dereferencing the pointer, so an
RTM_NEWLINK request can trigger a NULL pointer dereference.

Reject devices without ieee802154_ptr along with devices of the wrong type.

Fixes: 51e0e5d8124e ("ieee802154: 6lowpan: remove multiple lowpan per wpan support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://lore.kernel.org/0b715da69bd15a86ddc47dad5cf12da648211050.1787997209.git.zhilinz@nebusec.ai
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/6lowpan/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -150,7 +150,7 @@ static int lowpan_newlink(struct net_dev
 	wdev = dev_get_by_index(dev_net(ldev), nla_get_u32(tb[IFLA_LINK]));
 	if (!wdev)
 		return -ENODEV;
-	if (wdev->type != ARPHRD_IEEE802154) {
+	if (wdev->type != ARPHRD_IEEE802154 || !wdev->ieee802154_ptr) {
 		dev_put(wdev);
 		return -EINVAL;
 	}


