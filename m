Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9335533F590;
	Sat, 30 May 2026 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163087; cv=none; b=up5rGocl82E2+eCvJJXpLpCQyXR7bxNbxS+9VFTx/aBG2pVJM08r4m55YC95Ej5832h8DGMWs3FAupRyy0g0wGoIqYQPR+0N6DTdfW4nUHDtb7QagJPoZo1eMc4JyiaDi5q0dBZ82DoBkkcB5B0q+8pKjrvu6SS3vmFhVmYRQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163087; c=relaxed/simple;
	bh=6m/JMIDDVEeBZk1tHxjUS+2z8sLL7Jj6DedrazIei5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjVjRaj+9BK5A/mUwqfWXx0Y0SKyORVn6wwXqAgQDIxmTqJ+rpIT5D4yMcHCmlr2J178FF+QyWEl35uOcHd3oN2QyIYr5o2ts2H67toGjUZqB1bZonq29DInMiSOiVzorzDgZUU/++aSNlU4dMbkvBLXZiRbGzPpqwAyGKj0lAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kodXujcQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kodXujcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65011F00893;
	Sat, 30 May 2026 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163085;
	bh=DoPJYEd2GLCiqQQNnyEoTZN2p5sLobybNwvimTE5wcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kodXujcQqjaGWi8OBdf1iY+/OP7rn7XPgLB3NsBiGQHMDpQ8oFJWMHugCGFIQrbl5
	 kK9lkQRRCu5uPrfjD4/vMcRMTdZt++mU151VZUUmWUYms4XMdtBxJjIrdstLxgP8iS
	 jp02oHo1uheRJWMj+YuBXrdRs8UBeP3EvPkgR3fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 150/776] vdpa: Add max vqp attr to vdpa_nl_policy for nlattr length check
Date: Sat, 30 May 2026 17:57:44 +0200
Message-ID: <20260530160244.333253840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 5d6ba607d6cb5c58a4ddf33381e18c83dbb4098f ]

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
[ Minor context conflict resolved. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -847,6 +847,7 @@ static const struct nla_policy vdpa_nl_p
 	[VDPA_ATTR_MGMTDEV_BUS_NAME] = { .type = NLA_NUL_STRING },
 	[VDPA_ATTR_MGMTDEV_DEV_NAME] = { .type = NLA_STRING },
 	[VDPA_ATTR_DEV_NAME] = { .type = NLA_STRING },
+	[VDPA_ATTR_DEV_NET_CFG_MAX_VQP] = { .type = NLA_U16 },
 };
 
 static const struct genl_ops vdpa_nl_ops[] = {


