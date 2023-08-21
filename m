Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001B31170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7545DC433C7;
	Mon, 21 Aug 2023 19:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647683;
	bh=FczYBzczb6PQCSzO5uywPJwqlkJX5PTn+4lftX16+6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkSShjSiQ2B2kZXWhltITQDFD96U3//3Pzfv0oEz6f0od4k6sUQMUqss+YY1dhAsl
	 prEVaM04RThbJEABiSFkD+XZ7gF+u2mPPlhZXFZSfhYpzehZ/2fdi78yf5zCtFQzBO
	 xgclRFWOKTKMa/bOFMaVvtXXUHoS93TXTFeXY7BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 094/194] vdpa: Add features attr to vdpa_nl_policy for nlattr length check
Date: Mon, 21 Aug 2023 21:41:13 +0200
Message-ID: <20230821194126.845944056@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

commit 79c8651587504ba263d2fd67fd4406240fb21f69 upstream.

The vdpa_nl_policy structure is used to validate the nlattr when parsing
the incoming nlmsg. It will ensure the attribute being described produces
a valid nlattr pointer in info->attrs before entering into each handler
in vdpa_nl_ops.

That is to say, the missing part in vdpa_nl_policy may lead to illegal
nlattr after parsing, which could lead to OOB read just like CVE-2023-3773.

This patch adds the missing nla_policy for vdpa features attr to avoid
such bugs.

Fixes: 90fea5a800c3 ("vdpa: device feature provisioning")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Cc: stable@vger.kernel.org
Message-Id: <20230727175757.73988-3-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1174,6 +1174,7 @@ static const struct nla_policy vdpa_nl_p
 	[VDPA_ATTR_DEV_NET_CFG_MACADDR] = NLA_POLICY_ETH_ADDR,
 	/* virtio spec 1.1 section 5.1.4.1 for valid MTU range */
 	[VDPA_ATTR_DEV_NET_CFG_MTU] = NLA_POLICY_MIN(NLA_U16, 68),
+	[VDPA_ATTR_DEV_FEATURES] = { .type = NLA_U64 },
 };
 
 static const struct genl_ops vdpa_nl_ops[] = {


