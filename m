Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D123D0A1;
	Wed, 21 Feb 2024 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525500; cv=none; b=Onf/oMxIO0kJbx9IAJhdSYMicyVyGBiPQQ+rWf6ojYmgYY1TO34cqjFZ+gN1V8nFBQoPp/4r8Pgesx28efJJs5s4xw5Ul5ccMLMMXOBsOAJd/KsSBRyo+DQe34zHAtVs5Rm4/dqCHoZfpw22EJPKz9wdtwNoO3TCsVc3gXkkynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525500; c=relaxed/simple;
	bh=sLkl8R7cyNTnIPlZR+TrwPfUkmxBq8TPN9hKktXbp9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M03wVfirSzXilB+zwSbuyd3L17i7+XdBs4/sG4B0OculGEn0KSZa2pFDwAD1jQVYpIMOMuOQA2tYnvau6u7H3+wj8xrdOyy6DxDV2dPkUrxYrljkh+iofjzmV7JzKBsqB3j0Y+Zvdv5AAKWGtViHf2JjLGLyu57Y1Y80B/w1+u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUQHLIg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUQHLIg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10191C433F1;
	Wed, 21 Feb 2024 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525500;
	bh=sLkl8R7cyNTnIPlZR+TrwPfUkmxBq8TPN9hKktXbp9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUQHLIg3UxM+bJRvK2tOy3CqazC5WcYFqGRGn/bPb1yGr4i7mpAi6XgYC1WW3jrhy
	 VQXttA4qoHNxG+4PcMSV0Qptd3A81LFLSyHgdSZFiDn16/pXM1yU8vKGPKoky/w18Y
	 9UOozOFVLskayP18Icvetz9ijeiL644wZf8vl5O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 175/267] bonding: remove print in bond_verify_device_path
Date: Wed, 21 Feb 2024 14:08:36 +0100
Message-ID: <20240221125945.628667734@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2482,11 +2482,8 @@ struct bond_vlan_tag *bond_verify_device
 
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


