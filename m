Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0628027CB33;
	Wed, 23 Apr 2025 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419987; cv=none; b=O7KhmYyC779JVm9TM4uFMc8YVPZC9T+/jenqjgw68jwgEzXx7IdcgRVvELc9XVwyA/4+0TGkDUvSVh5YItsora3B9dyklOMziwYxTrGvfObPzZ4v90aQoF0vPtPq5wtzIX+Dq+JEMkg5PMxa7E1JkBl0OlZDL1kEMJrHqyM6nnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419987; c=relaxed/simple;
	bh=R/dJmAGBPcmpYmBYdjSI8XtVJQu98ghImYLsA8+pD5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5fCzwqPtzLK/JfaxyJyVLUolNgdJYGnBQUAQU1QD+3MY2mACcR8ezVDqGws+YOvAxjB8xBcO7hHUEn1XIAgZMTdi30DxK03f8sGiiTjof94vNgdtYfcYZ0MJO0UqG2DtzDCW6+QV1d0XWq6bZjbBI5fxjoNVQ5saLhj3Dk6w3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH5mQjz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH5mQjz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE7EC4CEE2;
	Wed, 23 Apr 2025 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419986;
	bh=R/dJmAGBPcmpYmBYdjSI8XtVJQu98ghImYLsA8+pD5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vH5mQjz+4yaz/HhZ+GWK3IgUNW5aB2Dp28gaTCuJLhJ7y/k/wdf+/sMimsO/0Km7K
	 NALAIh1BrbgX1gzLoAo9ZMIMjPpfTgDLpA2i9U4nFWL/hawsDsLpinMRt5+z+dYssK
	 WLGy7bPoAK35/vfpG7FEBFgQbpWu9n2EFGHPPWGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/291] rtnl: add helper to check if a notification is needed
Date: Wed, 23 Apr 2025 16:39:56 +0200
Message-ID: <20250423142624.712503350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 8439109b76a3c405808383bf9dd532fc4b9c2dbd ]

Building on the rtnl_has_listeners helper, add the rtnl_notify_needed
helper to check if we can bail out early in the notification routines.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20231208192847.714940-3-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 369609fc6272 ("tc: Ensure we have enough buffer space when sending filter netlink notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index ad5f15d369235..f532d1eda761c 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -145,4 +145,19 @@ static inline int rtnl_has_listeners(const struct net *net, u32 group)
 	return netlink_has_listeners(rtnl, group);
 }
 
+/**
+ * rtnl_notify_needed - check if notification is needed
+ * @net: Pointer to the net namespace
+ * @nlflags: netlink ingress message flags
+ * @group: rtnl group
+ *
+ * Based on the ingress message flags and rtnl group, returns true
+ * if a notification is needed, false otherwise.
+ */
+static inline bool
+rtnl_notify_needed(const struct net *net, u16 nlflags, u32 group)
+{
+	return (nlflags & NLM_F_ECHO) || rtnl_has_listeners(net, group);
+}
+
 #endif	/* __LINUX_RTNETLINK_H */
-- 
2.39.5



