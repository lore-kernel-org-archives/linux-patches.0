Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAEF1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93320C433C7;
	Mon, 21 Aug 2023 20:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648228;
	bh=HyjCIrWwlRMrvk9h78kLY8b27RD8dbrbvSWE4JRBcaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmzHvf6KAyNXd+ZetT4ahrs+JJ7fglBRNZkuJyJRe1VzXjnOh2gw0FKeeec+9+ZAJ
	 gzEXXw15ntBR/xgzqeDQr09hZNhH7iCNhujO7YBwMglnjr3qzttR+3MevYc/5jU7wO
	 k0tBITsa2pLQyQsw9biqZr60qXH2AaUk1WxnGjh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	stable@vger.kernelorg,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.4 101/234] vdpa: Add queue index attr to vdpa_nl_policy for nlattr length check
Date: Mon, 21 Aug 2023 21:41:04 +0200
Message-ID: <20230821194133.272284647@linuxfoundation.org>
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

commit b3003e1b54e057f5f3124e437b80c3bef26ed3fe upstream.

The vdpa_nl_policy structure is used to validate the nlattr when parsing
the incoming nlmsg. It will ensure the attribute being described produces
a valid nlattr pointer in info->attrs before entering into each handler
in vdpa_nl_ops.

That is to say, the missing part in vdpa_nl_policy may lead to illegal
nlattr after parsing, which could lead to OOB read just like CVE-2023-3773.

This patch adds the missing nla_policy for vdpa queue index attr to avoid
such bugs.

Fixes: 13b00b135665 ("vdpa: Add support for querying vendor statistics")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Cc: stable@vger.kernelorg
Message-Id: <20230727175757.73988-5-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1249,6 +1249,7 @@ static const struct nla_policy vdpa_nl_p
 	[VDPA_ATTR_DEV_NET_CFG_MACADDR] = NLA_POLICY_ETH_ADDR,
 	/* virtio spec 1.1 section 5.1.4.1 for valid MTU range */
 	[VDPA_ATTR_DEV_NET_CFG_MTU] = NLA_POLICY_MIN(NLA_U16, 68),
+	[VDPA_ATTR_DEV_QUEUE_INDEX] = { .type = NLA_U32 },
 	[VDPA_ATTR_DEV_FEATURES] = { .type = NLA_U64 },
 };
 


