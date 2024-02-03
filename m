Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61147134C0;
	Sat,  3 Feb 2024 04:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933476; cv=none; b=aNIH0C7fZc3iWDkz1nVQAG13umcI3ydQ0ouC5NFuwuaEu5vtVRoivJWTbhko6RsZ9t8bHC2t4GT2CDh6NE7gDUQnGw9PX/Z0roMFc8RcUK0mDb6bIYeD2cgBNuGxdc0esNBJtyyOC5M6p8JAj7eDUi3i1nv1PIMGnW1rPaDJqug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933476; c=relaxed/simple;
	bh=k87zqLb+sPEb9yoN9+ZYs+qYEUenqnzInTntwg3i/j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTZ2RBDRYp32Y9Jow4ca6iDh4nDQa8Q+3x23mFBrV9uCqWx/aBhaKZzTpPVO04/tv4Y/hOPT9wABlaUdeq+EG0yysLXUMV5y+a76fEOhiM3ycztovFons92dtJgQ9yigl4tKqYvv6rjydYWwZLhdnd3usOIDyRnTevjihuOxmMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXd9LMgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXd9LMgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A72C43390;
	Sat,  3 Feb 2024 04:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933475;
	bh=k87zqLb+sPEb9yoN9+ZYs+qYEUenqnzInTntwg3i/j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXd9LMgERz0l/PCKfUCRTJ06aZ1Zk6mzJSHZe8JzzEvid3S6r8V3ADMadYUF+BL4H
	 QJmKGWjOTwAxgCIIwmYDajtTY6vJBm7UvjuuxJp9tE4u5xNkBvcoTPcuiLgaOBk4dq
	 OJf6R8vfHGlpzNbsxqnfeXM1/+vRL5HorDwO2bEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 219/219] bonding: remove print in bond_verify_device_path
Date: Fri,  2 Feb 2024 20:06:32 -0800
Message-ID: <20240203035347.379642185@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit 486058f42a4728053ae69ebbf78e9731d8ce6f8b upstream.

As suggested by Paolo in link[1], if the memory allocation fails, the mm
layer will emit a lot warning comprising the backtrace, so remove the
print.

[1] https://lore.kernel.org/all/20231118081653.1481260-1-shaozhengchao@huawei.com/

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2943,11 +2943,8 @@ struct bond_vlan_tag *bond_verify_device
 
 	if (start_dev == end_dev) {
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
-		if (!tags) {
-			net_err_ratelimited("%s: %s: Failed to allocate tags\n",
-					    __func__, start_dev->name);
+		if (!tags)
 			return ERR_PTR(-ENOMEM);
-		}
 		tags[level].vlan_proto = VLAN_N_VID;
 		return tags;
 	}


