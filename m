Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EBD250C1D;
	Wed,  5 Mar 2025 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197531; cv=none; b=mlDGfsUNJCrBrFCcvmHz70qfnx00wlKmg7V/NQUzMtz47tWMxy2VuB0cyWDvaIPjGjpZ5XwjSG8pFZXZS6oCTyCvDVpho8chlSTA7/XAqexkFhACk6l8nRnp3GJANZLtFXzVOK4EnQgtwfp3yLtBUm6lv8leDXHiT/sihehlVIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197531; c=relaxed/simple;
	bh=VbfUJBPyGqCOVarpTkazrFndcymySGIIOKz1gptnJAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvBTXYxC0WebfggpgiC70HbqZ37oDxNh2z1+YgJRgCl9A+B12lxQ6zdmqOb3ho26Y+3u4dbqHBsfparWjUeuZVy1q4227ig9sU7fagdZiSQMeqIUU1CeWJnWlASzskWCtpJG2lqB6zSd94S+OvonPQZul17eAJPV6kjwuUmqrWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjihjKKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjihjKKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A08C4CED1;
	Wed,  5 Mar 2025 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197531;
	bh=VbfUJBPyGqCOVarpTkazrFndcymySGIIOKz1gptnJAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjihjKKEpWQJ7v3eJcfTQH3UMTYCCd8FQGMTkGy5psZl6rhDYfA9O0Ue+NsymzS3j
	 rZYA8aMGLUlZ39e45Yl5+myq9ZQyLACUC4AGRiq28lO51rkF3IVDNY+tfaFlN6WpFk
	 pMzjz7pM9Lc77mAKYhXvYbQm6byqPrHbCJfL6XJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/142] IB/core: Add support for XDR link speed
Date: Wed,  5 Mar 2025 18:47:11 +0100
Message-ID: <20250305174500.829731540@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 703289ce43f740b0096724300107df82d008552f ]

Add new IBTA speed XDR, the new rate that was added to Infiniband spec
as part of XDR and supporting signaling rate of 200Gb.

In order to report that value to rdma-core, add new u32 field to
query_port response.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/9d235fc600a999e8274010f0e18b40fa60540e6c.1695204156.git.leon@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: c534ffda781f ("RDMA/mlx5: Fix AH static rate parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sysfs.c                   | 4 ++++
 drivers/infiniband/core/uverbs_std_types_device.c | 3 ++-
 drivers/infiniband/core/verbs.c                   | 3 +++
 include/rdma/ib_verbs.h                           | 2 ++
 include/uapi/rdma/ib_user_ioctl_verbs.h           | 3 ++-
 5 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index ec5efdc166601..9f97bef021497 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -342,6 +342,10 @@ static ssize_t rate_show(struct ib_device *ibdev, u32 port_num,
 		speed = " NDR";
 		rate = 1000;
 		break;
+	case IB_SPEED_XDR:
+		speed = " XDR";
+		rate = 2000;
+		break;
 	case IB_SPEED_SDR:
 	default:		/* default to SDR for invalid rates */
 		speed = " SDR";
diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index 049684880ae03..fb0555647336f 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -203,6 +203,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_PORT)(
 
 	copy_port_attr_to_resp(&attr, &resp.legacy_resp, ib_dev, port_num);
 	resp.port_cap_flags2 = attr.port_cap_flags2;
+	resp.active_speed_ex = attr.active_speed;
 
 	return uverbs_copy_to_struct_or_zero(attrs, UVERBS_ATTR_QUERY_PORT_RESP,
 					     &resp, sizeof(resp));
@@ -461,7 +462,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_PTR_OUT(
 		UVERBS_ATTR_QUERY_PORT_RESP,
 		UVERBS_ATTR_STRUCT(struct ib_uverbs_query_port_resp_ex,
-				   reserved),
+				   active_speed_ex),
 		UA_MANDATORY));
 
 DECLARE_UVERBS_NAMED_METHOD(
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 186ed3c22ec9e..ba05de0380e96 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -147,6 +147,7 @@ __attribute_const__ int ib_rate_to_mult(enum ib_rate rate)
 	case IB_RATE_50_GBPS:  return  20;
 	case IB_RATE_400_GBPS: return 160;
 	case IB_RATE_600_GBPS: return 240;
+	case IB_RATE_800_GBPS: return 320;
 	default:	       return  -1;
 	}
 }
@@ -176,6 +177,7 @@ __attribute_const__ enum ib_rate mult_to_ib_rate(int mult)
 	case 20:  return IB_RATE_50_GBPS;
 	case 160: return IB_RATE_400_GBPS;
 	case 240: return IB_RATE_600_GBPS;
+	case 320: return IB_RATE_800_GBPS;
 	default:  return IB_RATE_PORT_CURRENT;
 	}
 }
@@ -205,6 +207,7 @@ __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate)
 	case IB_RATE_50_GBPS:  return 53125;
 	case IB_RATE_400_GBPS: return 425000;
 	case IB_RATE_600_GBPS: return 637500;
+	case IB_RATE_800_GBPS: return 850000;
 	default:	       return -1;
 	}
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 62f9d126a71ad..bc459d0616297 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -561,6 +561,7 @@ enum ib_port_speed {
 	IB_SPEED_EDR	= 32,
 	IB_SPEED_HDR	= 64,
 	IB_SPEED_NDR	= 128,
+	IB_SPEED_XDR	= 256,
 };
 
 enum ib_stat_flag {
@@ -840,6 +841,7 @@ enum ib_rate {
 	IB_RATE_50_GBPS  = 20,
 	IB_RATE_400_GBPS = 21,
 	IB_RATE_600_GBPS = 22,
+	IB_RATE_800_GBPS = 23,
 };
 
 /**
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index d7c5aaa327445..fe15bc7e9f707 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -220,7 +220,8 @@ enum ib_uverbs_advise_mr_flag {
 struct ib_uverbs_query_port_resp_ex {
 	struct ib_uverbs_query_port_resp legacy_resp;
 	__u16 port_cap_flags2;
-	__u8  reserved[6];
+	__u8  reserved[2];
+	__u32 active_speed_ex;
 };
 
 struct ib_uverbs_qp_cap {
-- 
2.39.5



