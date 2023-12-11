Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FF54F212;
	Mon, 11 Dec 2023 18:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZUWxqsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8146C433C8;
	Mon, 11 Dec 2023 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319053;
	bh=x51fZGKy8+QR6KrDbiS4MOrYNpDzsi7uU+dm79X4AUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZUWxqsIsvkUSB7XnZkH0PUO8H/Bqfy1BlCVMgc5ehxMqleb2PnUEsO6trf18cwMm
	 +zI0s/Cl6hF5cnqzjy/fRg3Wv53LHrK8r5bJDgKuchUSkCWhZe0eyOfymTF1nGj8uZ
	 1ZObIpWYWtaCkgQUGiXXraNM5R02DmLx+EXwsjAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/55] netfilter: xt_owner: Add supplementary groups option
Date: Mon, 11 Dec 2023 19:21:30 +0100
Message-ID: <20231211182012.975395610@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

[ Upstream commit ea6cc2fd8a2b89ab6dcd096ba6dbc1ecbdf26564 ]

The XT_OWNER_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID
to be also checked in the supplementary groups of a process.

f_cred->group_info cannot be modified during its lifetime and f_cred
holds a reference to it so it's safe to use.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 7ae836a3d630 ("netfilter: xt_owner: Fix for unsafe access of sk->sk_socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_owner.h |  7 ++++---
 net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index fa3ad84957d50..9e98c09eda327 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -5,9 +5,10 @@
 #include <linux/types.h>
 
 enum {
-	XT_OWNER_UID    = 1 << 0,
-	XT_OWNER_GID    = 1 << 1,
-	XT_OWNER_SOCKET = 1 << 2,
+	XT_OWNER_UID          = 1 << 0,
+	XT_OWNER_GID          = 1 << 1,
+	XT_OWNER_SOCKET       = 1 << 2,
+	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 46686fb73784b..a8784502aca69 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	if (info->match & XT_OWNER_GID) {
+		unsigned int i, match = false;
 		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
 		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
-		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
-		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
-		    !(info->invert & XT_OWNER_GID))
+		struct group_info *gi = filp->f_cred->group_info;
+
+		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
+		    gid_lte(filp->f_cred->fsgid, gid_max))
+			match = true;
+
+		if (!match && (info->match & XT_OWNER_SUPPL_GROUPS) && gi) {
+			for (i = 0; i < gi->ngroups; ++i) {
+				kgid_t group = gi->gid[i];
+
+				if (gid_gte(group, gid_min) &&
+				    gid_lte(group, gid_max)) {
+					match = true;
+					break;
+				}
+			}
+		}
+
+		if (match ^ !(info->invert & XT_OWNER_GID))
 			return false;
 	}
 
-- 
2.42.0



