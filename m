Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD3D148832;
	Fri,  6 Dec 2024 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498763; cv=none; b=Nk+o1/CM6K0AoJTTXckEymmD9ZjqT5gstbjKtYDXpyCgcBuAWTnOs4yOqR/W5zwNPZEjI+HcgWpfbdnjZIyibAYFgWAlEUe1dFynL7T7zHmdTqxgpWHpyOe2KhkEBkPAQk7zZg9i7y21M6iLiRPq41ROMUYlTxRfVI9D8nX4grk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498763; c=relaxed/simple;
	bh=0Do8IpfeGJPUirRnVM9bALmL7GLlEHpGGdXhhpDf5NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txqTEU17m9QV5/5BC1aNubXiA9paIok1Q59AcP+JyQEQEfkWiz8VWMG5dV15MrK+fl+ObtOKpUKhjjzmRQdEVMXx9cx2fzPimALSTSCf83MLDejjkQAAhWaOCgsqVhF1Th6ErDHo+lMaVoKkT6cXnpDwUxqj6o6vytP0GusO4ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbAfxiLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbAfxiLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D063C4CED1;
	Fri,  6 Dec 2024 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498763;
	bh=0Do8IpfeGJPUirRnVM9bALmL7GLlEHpGGdXhhpDf5NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbAfxiLHnRDdTqmdHabRdNHzIZcv27tIa1nrJ/fZjv4BVPTSTHxGJrHf8SEpi4vaL
	 jINuwCNTogosErH2/xE+uGq5nJqwfcSwQ6iVIESCiQjhEHmFfDY8YrrXnnLgJZetXj
	 XOFPyLxuBkHeIz30KgDvfnjiN25LH1DdGexUygoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 659/676] iio: Fix fwnode_handle in __fwnode_iio_channel_get_by_name()
Date: Fri,  6 Dec 2024 15:37:58 +0100
Message-ID: <20241206143719.109748613@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -277,7 +277,7 @@ struct iio_channel *fwnode_iio_channel_g
 			return ERR_PTR(-ENODEV);
 		}
 
-		chan = __fwnode_iio_channel_get_by_name(fwnode, name);
+		chan = __fwnode_iio_channel_get_by_name(parent, name);
 		if (!IS_ERR(chan) || PTR_ERR(chan) != -ENODEV) {
 			fwnode_handle_put(parent);
  			return chan;


