Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1F0236FBB;
	Thu, 12 Dec 2024 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020551; cv=none; b=p9MlPctpV1zfE2rqVnJxyHnIPiz8njG/asnaltRkp9ZdpYLJzMsY8zV3ZLg2gRjw79mZjHPpKuGjywzu57SxnF8q0yRcLaxZtzUM41ikyD+ik2Wm5T1oF0JdIMv0y0dAwKMbhfGRgrKp00SDnH7pi0XMBnascGiaeJK7J6GOuvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020551; c=relaxed/simple;
	bh=wIELYbxNZIe6V9iYPdDVPl1r/hBeXGDhz1yu+t7O7UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGfioj4sfWeer9UM+INb2J+PPvMhmTrf8rmxgSqkGdL6uQ80tVJU1i62RKUC9eQ4RI8U/7Sp7lCbriNtQLRCpAF39k0INqacUIkHQrCFj7kZWmIpAA8HWg4TgzryGOSKXwAopz8NwC8cD8jf2CJ6ZM0e5M6lA5egWoO/wAey27M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkVmbETv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkVmbETv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D804C4CED0;
	Thu, 12 Dec 2024 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020551;
	bh=wIELYbxNZIe6V9iYPdDVPl1r/hBeXGDhz1yu+t7O7UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkVmbETv6gNz8nVg+7JvmYZ5eIcbj716fTLJDr5I5T7wpvOKIIdUiv79iL6qkg3rC
	 PlZ3xFno77CSOx10Eltr2l+uOmqZDEDCdZFv5w6x9Ja+ssmc/625L09mDaQ7n1NGRV
	 hMX8mLVDjC0B4m1jTnJM+Wek9DlQrty1GUErSsh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 497/772] iio: Fix fwnode_handle in __fwnode_iio_channel_get_by_name()
Date: Thu, 12 Dec 2024 15:57:22 +0100
Message-ID: <20241212144410.487650251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Zicheng Qu <quzicheng@huawei.com>

commit 3993ca4add248f0f853f54f9273a7de850639f33 upstream.

In the fwnode_iio_channel_get_by_name(), iterating over parent nodes to
acquire IIO channels via fwnode_for_each_parent_node(). The variable
chan was mistakenly attempted on the original node instead of the
current parent node. This patch corrects the logic to ensure that
__fwnode_iio_channel_get_by_name() is called with the correct parent
node.

Cc: stable@vger.kernel.org # v6.6+
Fixes: 1e64b9c5f9a0 ("iio: inkern: move to fwnode properties")
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241102092525.2389952-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -276,7 +276,7 @@ struct iio_channel *fwnode_iio_channel_g
 			return ERR_PTR(-ENODEV);
 		}
 
-		chan = __fwnode_iio_channel_get_by_name(fwnode, name);
+		chan = __fwnode_iio_channel_get_by_name(parent, name);
 		if (!IS_ERR(chan) || PTR_ERR(chan) != -ENODEV) {
 			fwnode_handle_put(parent);
  			return chan;


