Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C92641CC;
	Tue,  8 Apr 2025 11:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112819; cv=none; b=k9mUsF7OIRXbbpPCQbQApZaeswi+6x2cQoYtyCXTHVIUSdLO37ZI9a0wHGHN0d51D0EIK0nLiaCw9SDkvHv39zerGDP9bkNihyu5nVLmK8F51qox2NmlTCTnWZKv4Xl8GP2dN30YyiLAcvIJPrtoossLtTXntynQYROtHVUgtEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112819; c=relaxed/simple;
	bh=BsX0iQBanqjAUTfvniuP1BcjviwFS8/PzDhPycvM78I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYuhZ8kXFZ3gnLCZl2jp+G2JZZB9raPQ2xrLqkkYL9f3mLPZHFVnik5w049zZA83bhvRd+JsknQ8itGZ5ap2HjUEckKlzNHvu9Lb/nZ0AsR5ziCQXKdYfDC/9LHaYgfTM8NRVA9mPWymC5A20HsGvxl/7td0JIvS4aDEoaS6FZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5DYVa1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5DYVa1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E25C4CEE5;
	Tue,  8 Apr 2025 11:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112819;
	bh=BsX0iQBanqjAUTfvniuP1BcjviwFS8/PzDhPycvM78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5DYVa1X0WVMomrwhKXVxNt+LDFMCJ9QpE+YZf2c/b6M1q3w2GUzLv15dsEl/AowQ
	 3l5Gav/xFSvC4jYuBhgiaGXlgcLfMXqiat8FG2mBu5Gey+0t6p7JgotMmdNSuZrlGI
	 nRjM1NkfpBOIMbR9jSn2h4eQJc0+M/sK0fVaX4JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/279] of: property: Increase NR_FWNODE_REFERENCE_ARGS
Date: Tue,  8 Apr 2025 12:49:12 +0200
Message-ID: <20250408104830.892563200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit eb50844d728f11e87491f7c7af15a4a737f1159d ]

Currently, the following two macros have different values:

// The maximal argument count for firmware node reference
 #define NR_FWNODE_REFERENCE_ARGS	8
// The maximal argument count for DT node reference
 #define MAX_PHANDLE_ARGS 16

It may cause firmware node reference's argument count out of range if
directly assign DT node reference's argument count to firmware's.

drivers/of/property.c:of_fwnode_get_reference_args() is doing the direct
assignment, so may cause firmware's argument count @args->nargs got out
of range, namely, in [9, 16].

Fix by increasing NR_FWNODE_REFERENCE_ARGS to 16 to meet DT requirement.
Will align both macros later to avoid such inconsistency.

Fixes: 3e3119d3088f ("device property: Introduce fwnode_property_get_reference_args")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20250225-fix_arg_count-v4-1-13cdc519eb31@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fwnode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 2d68606fb725d..f0833bafe6bd4 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -67,7 +67,7 @@ struct fwnode_endpoint {
 #define SWNODE_GRAPH_PORT_NAME_FMT		"port@%u"
 #define SWNODE_GRAPH_ENDPOINT_NAME_FMT		"endpoint@%u"
 
-#define NR_FWNODE_REFERENCE_ARGS	8
+#define NR_FWNODE_REFERENCE_ARGS	16
 
 /**
  * struct fwnode_reference_args - Fwnode reference with additional arguments
-- 
2.39.5



