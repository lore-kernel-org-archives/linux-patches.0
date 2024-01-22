Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B3812F59C;
	Tue, 23 Jan 2024 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971755; cv=none; b=XUuQap0UhOpKEqPwFLdfwV+DmxLqzMCMxdwf9WrZff6BPe9qZshag6CrvlTn4FrkBEDJNXi20S7zhYuu3AOCTsyS15PazU9k5P3g/1r62GAdVMkC34YHy6Py6QSwS5yFZGCI7OOxHCGhP37HdXwfsUOWCu6bzDdSgwL3MFzkLDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971755; c=relaxed/simple;
	bh=NOxBVvxjkrQZfHiHcZej9nfsT5V4SfuT/23gYgh1OKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeoNjhAnUw8zD6cj9KFIkEADsT3pPoOf2BK+yViyBFvzGEX1FZE3iUzydn/zJoimADmqmsXnE6NQHCrqhyDfZeWaBIex+Lz/lstgaTpWy3sqU3otC076TM0ijVbJ8oEb7V2eWXMDNm/RZUEqCm6y8BYawd+lkO/tcQujUcGr9JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7rxlWHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7rxlWHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4306C433F1;
	Tue, 23 Jan 2024 01:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971755;
	bh=NOxBVvxjkrQZfHiHcZej9nfsT5V4SfuT/23gYgh1OKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7rxlWHtKUmyQcM+AzQQhXOPh+PWmorUpK9R4b328UICCVUvRL12EljwPXsk6xITU
	 c5NZEiXlB5tsxcuw/MsTZFFhPTIvwVvzLAbKBm6zSKUts1UE32dgV3LW1C+3uTKIbj
	 UsdUKcXQ+7tNK5Cejb4chLISFPrvigbHHS8qtnrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 311/417] Revert "net: rtnetlink: Enslave device before bringing it up"
Date: Mon, 22 Jan 2024 15:57:59 -0800
Message-ID: <20240122235802.600186498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2797,13 +2797,6 @@ static int do_setlink(const struct sk_bu
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
@@ -2811,6 +2804,13 @@ static int do_setlink(const struct sk_bu
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


