Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA85A35E1A4;
	Sat, 12 Sep 2026 07:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198663; cv=none; b=NVoqmVVV/gkSuWfczy4+ONvf6KGNtdz9xLsSOUp0SGW35G3p+UMfKCKhPVv+Ujt6Hq/EdZXs0058hAhmfnOdnB6kwgeQ7BTqnx5O6ZpUp1c3xo1u8pXqunRUnyZ3HfzPOHmdYmQeZSI6puLlk0Xy7hOH1YsXiBHTPVloWdcl0hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198663; c=relaxed/simple;
	bh=hhIyD0rKvZ+EpAsWIRfgBAvzgKMA93XtYoQjwhQW0nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDoMcSujTvprT+5WcW6LwP+gllw9SlJpqMvWTvoz4JgiSqsTlVqEGxUHpN7Nx7pN9S/RMldrUF4OpqymtcbPkXK85vEXjQQpYWljHz7irvCJa6ccNHqOiYionj5fZfe3Mrh+qZ4iaj7PIdRUR1XagptdplcxdSXpj4FigPu2hLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1ufYo5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1ufYo5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1AB1F00893;
	Sat, 12 Sep 2026 07:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198662;
	bh=Q5xd2ULtCAlZVyHWJKYu7CSkfSFU2Py2hvpn0sRUYvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1ufYo5VRvqChqEW0tB+JSCLm039Ymx/Q5yjbSiJazljOTvYnHKrI6lp7WBJENlgB
	 rfzF0PwN1QvNegwUGi3tAdmnz58cfjdeEv/q6s1qIZU7dJfuHf6/Xe/9SZm9g8Gn3R
	 9znJkICmzWhQdiBuvRAmVedwWkyO+w0WbGgCCUSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0410/1815] cxl/features: Reject Set Features output buffer smaller than the header
Date: Sat, 12 Sep 2026 08:36:00 +0200
Message-ID: <20260912065658.517416703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit cde18d6c1d913a67ab0afd3d9475ece4be79da50 ]

cxlctl_set_feature() sizes its output buffer from the user's
fwctl_rpc.out_len but never checks it is large enough to hold even the
fwctl_rpc_cxl_out header. With out_len == 0 , kvzalloc() returns
ZERO_SIZE_PTR, which passes the !rpc_out check, the subsequent
rpc_out->size = 0 then writes through the poison pointer.

Reject requests whose output buffer can't hold the response header,
before allocating. The Set Feature reply carries no payload, so the
header is all that is required.

Fixes: eb5dfcb9e36d ("cxl: Add support to handle user feature commands for set feature")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260626104102.53892-3-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index d50e6b58d8fdb..2eedabb5f7023 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -523,6 +523,9 @@ static void *cxlctl_set_feature(struct cxl_features_state *cxlfs,
 	flags = le32_to_cpu(feat_in->flags);
 	out_size = *out_len;
 
+	if (out_size < offsetof(struct fwctl_rpc_cxl_out, payload))
+		return ERR_PTR(-EINVAL);
+
 	struct fwctl_rpc_cxl_out *rpc_out __free(kvfree) =
 		kvzalloc(out_size, GFP_KERNEL);
 	if (!rpc_out)
-- 
2.53.0



