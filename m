Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC70C5B5A1;
	Tue, 23 Jan 2024 00:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969808; cv=none; b=RKpFioXQtU1Dd0NN+D9mKvXSl4Sv5EfdpFodHwseTbLjLIsRD2EQmT+yooYJIj6K/rhPIWFGu08pSbfvel4EGwkFRw2maSxsv/dxZaTo7I43wsp/6U2zrdxzYxSCUUvwavwt5Hn+2iTd6+lMisz4zcAEGs5o4CPFSAgiQeNMZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969808; c=relaxed/simple;
	bh=VdWkLRRjmmd8qFOLbwjIwZ6LizXZXjeBZ9xGy3LVdMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hz00KKPRD2APNzgniuogKh8b7gmqa/qiCNeXbJEHDi7G0qaTdSha+XrLvNhKKJ4F5WtGwC1mcdAw+5qffVLq3FFdfqoNl4ODe11A43XuD3PJtfEt+SdG55fQ1QAuDweYEoGWIyrlfkcTiBVCT5MnmoSn+xi3+5FcoDGdr2Qj5Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHXOf1Fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHXOf1Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41548C433B1;
	Tue, 23 Jan 2024 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969807;
	bh=VdWkLRRjmmd8qFOLbwjIwZ6LizXZXjeBZ9xGy3LVdMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHXOf1FgJdFuMUOE9vwyBPoiBhQXs35/pkfrfLK/hE1+FCy3b6SC+FnFlLTABQx77
	 nGUb1Q7cm3Y3EBIUjwekj3Piw/b6UJETwWwPIWnBW3YWmqDBDLh0KDyp26jvorNHEn
	 YZ9Krv24+z3qyofWJZuFzni2DOk42hsEVCBjpVeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 462/641] Revert "net: rtnetlink: Enslave device before bringing it up"
Date: Mon, 22 Jan 2024 15:56:06 -0800
Message-ID: <20240122235832.496336255@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit ec4ffd100ffb396eca13ebe7d18938ea80f399c3 upstream.

This reverts commit a4abfa627c3865c37e036bccb681619a50d3d93c.

The patch broke:
> ip link set dummy0 up
> ip link set dummy0 master bond0 down

This last command is useful to be able to enslave an interface with only
one netlink message.

After discussion, there is no good reason to support:
> ip link set dummy0 down
> ip link set dummy0 master bond0 up
because the bond interface already set the slave up when it is up.

Cc: stable@vger.kernel.org
Fixes: a4abfa627c38 ("net: rtnetlink: Enslave device before bringing it up")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20240108094103.2001224-2-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2905,13 +2905,6 @@ static int do_setlink(const struct sk_bu
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	}
 
-	if (tb[IFLA_MASTER]) {
-		err = do_set_master(dev, nla_get_u32(tb[IFLA_MASTER]), extack);
-		if (err)
-			goto errout;
-		status |= DO_SETLINK_MODIFIED;
-	}
-
 	if (ifm->ifi_flags || ifm->ifi_change) {
 		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm),
 				       extack);
@@ -2919,6 +2912,13 @@ static int do_setlink(const struct sk_bu
 			goto errout;
 	}
 
+	if (tb[IFLA_MASTER]) {
+		err = do_set_master(dev, nla_get_u32(tb[IFLA_MASTER]), extack);
+		if (err)
+			goto errout;
+		status |= DO_SETLINK_MODIFIED;
+	}
+
 	if (tb[IFLA_CARRIER]) {
 		err = dev_change_carrier(dev, nla_get_u8(tb[IFLA_CARRIER]));
 		if (err)


