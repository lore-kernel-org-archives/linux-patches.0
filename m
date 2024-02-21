Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F507BB03;
	Wed, 21 Feb 2024 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522931; cv=none; b=ue8mhzQE83xvYqpra4CyFvsG3Z5boDHhi/A6c8FrRK5W/SzYP/GR//ObO/uQRjmT6k21/+eyrY5pimK7dw07VB88jHXyolB8oVn1up5jk7aY0aoVTHNA97hKG7l9ksiVupkuaOq1J3OBZefSUX+4V+fldDUkcnBsNEbdq+7bI4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522931; c=relaxed/simple;
	bh=BHGWHit0q5LnBooufl6NdWPAFFc4f/kbQyLD37IYP4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My8kWC7ZOwKK0pOItpGk2cw4v14YBicuVLc0mxqnUbterRuQwpjZehlkJDAMBEJKEP3mg1qHwh37zkyxLNYNvmjuaF2OPAimqJmDx9FpTshZnF2DbciK4kPzxwhnxFsTNESzgwUmhrFRTUovtYYkTxMQJrE+XNEuFYFJoGFlvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMeNUqNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMeNUqNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92C2C433F1;
	Wed, 21 Feb 2024 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522931;
	bh=BHGWHit0q5LnBooufl6NdWPAFFc4f/kbQyLD37IYP4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMeNUqNl1+zZubMqZjMnYcOo+S2w02uwcIVAqmTPZJCKgwRNTzJc262M4hvWNj+LC
	 B14xUb6fxh5PohbNbJ2qt+56AtsJe0kDYKPega5ugsCB8Y9MahLimelCkcoIvje/je
	 KsOEvoUY0PjYPssvhk5ylpbzuaggv9lrw5dt0SHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 294/476] bonding: remove print in bond_verify_device_path
Date: Wed, 21 Feb 2024 14:05:45 +0100
Message-ID: <20240221130018.854912356@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2893,11 +2893,8 @@ struct bond_vlan_tag *bond_verify_device
 
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


