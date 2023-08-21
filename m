Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E131E1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638C4C433C8;
	Mon, 21 Aug 2023 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648230;
	bh=S25ZaS0IS0BJ8eMGSuxTyoHD/A9Lln6xZyKXTHjAZyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmuDbbD7KrsFKkRPLty2tHpa1xKm2byjcTj9g2yRkQyuZt0MrtMe8yWblBa615N8E
	 DbS+EfXu7s91+8oiuzEE6qLLi8IByGybIlCOMxT1+sXtLIFyxnmCQZYD6fluupwMqk
	 HauUbHz4nN24X6aWygCHNbCQl6xF4/eMMJBE5DdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.4 102/234] vdpa: Add max vqp attr to vdpa_nl_policy for nlattr length check
Date: Mon, 21 Aug 2023 21:41:05 +0200
Message-ID: <20230821194133.325140939@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

commit 5d6ba607d6cb5c58a4ddf33381e18c83dbb4098f upstream.

The vdpa_nl_policy structure is used to validate the nlattr when parsing
the incoming nlmsg. It will ensure the attribute being described produces
a valid nlattr pointer in info->attrs before entering into each handler
in vdpa_nl_ops.

That is to say, the missing part in vdpa_nl_policy may lead to illegal
nlattr after parsing, which could lead to OOB read just like CVE-2023-3773.

This patch adds the missing nla_policy for vdpa max vqp attr to avoid
such bugs.

Fixes: ad69dd0bf26b ("vdpa: Introduce query of device config layout")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Cc: stable@vger.kernel.org
Message-Id: <20230727175757.73988-7-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1247,6 +1247,7 @@ static const struct nla_policy vdpa_nl_p
 	[VDPA_ATTR_MGMTDEV_DEV_NAME] = { .type = NLA_STRING },
 	[VDPA_ATTR_DEV_NAME] = { .type = NLA_STRING },
 	[VDPA_ATTR_DEV_NET_CFG_MACADDR] = NLA_POLICY_ETH_ADDR,
+	[VDPA_ATTR_DEV_NET_CFG_MAX_VQP] = { .type = NLA_U16 },
 	/* virtio spec 1.1 section 5.1.4.1 for valid MTU range */
 	[VDPA_ATTR_DEV_NET_CFG_MTU] = NLA_POLICY_MIN(NLA_U16, 68),
 	[VDPA_ATTR_DEV_QUEUE_INDEX] = { .type = NLA_U32 },


