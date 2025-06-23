Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6555E2222B2;
	Mon, 23 Jun 2025 22:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717421; cv=none; b=l/k3yr5m2iy58B2bIQ00J24QYw5w5fUZNPlybZBcSpxZzDl2ey2R1vHoT2EanWSGI2vj8GjK/b6ZtvShGlI8B48KXr5hls3IX/UlFaVLJhtfKPu8qhzHpeFECNGm2+Rn1dVYgcdgz8Mxk4z5N7CxqtBjba4WHAyh1BIm57EIcmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717421; c=relaxed/simple;
	bh=5+/Y+JNMO5zY17osI0o1iodz5yP8UqCKJOGBQxRREyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnCw9N+PZyEwKcMw4yh/RlJxedBJ66flP8zsAnAn40Y59h9LkrMw0/5fQc0w/m8rVsINO/zyecmp4WRAddixz2wXK2wqEq2AS9CVfZvbDjlXEKuDZ2HubGpLnqaPARz7RQ9Mg5v8+WAJ7mZPp8JcgiFtP00+XQtuzAPVvublbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vq4Fk0MB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vq4Fk0MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26F1C4CEEA;
	Mon, 23 Jun 2025 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717421;
	bh=5+/Y+JNMO5zY17osI0o1iodz5yP8UqCKJOGBQxRREyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vq4Fk0MBBTNn4Lfd2sNIG6BZoqcOb6+Z47cISo4HaNADNPkU92QY/NNaf1IOZwZLd
	 Lqa8uaygKPUhHE8l66SJmZuqtFIAQj9AnS5wdWjnuCw47olH42SVgP/WVJBBnXDiuw
	 OQYC42LjvTF++fto3Iq8rGD97u1qR2e/Gy868vpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 423/508] software node: Correct a OOB check in software_node_get_reference_args()
Date: Mon, 23 Jun 2025 15:07:48 +0200
Message-ID: <20250623130655.598602175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 31e4e12e0e9609850cefd4b2e1adf782f56337d6 ]

software_node_get_reference_args() wants to get @index-th element, so
the property value requires at least '(index + 1) * sizeof(*ref)' bytes
but that can not be guaranteed by current OOB check, and may cause OOB
for malformed property.

Fix by using as OOB check '((index + 1) * sizeof(*ref) > prop->length)'.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250414-fix_swnode-v2-1-9c9e6ae11eab@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 44153caa893ad..fdea6b93eb30e 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -518,7 +518,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if (index * sizeof(*ref) >= prop->length)
+	if ((index + 1) * sizeof(*ref) > prop->length)
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.39.5



