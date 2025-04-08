Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92A227BA4;
	Tue,  8 Apr 2025 11:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113207; cv=none; b=Z5viKCGo6que0AW0d48IPX+Uozwn4YtsYY8HC1REPNP2q6cijd+9Zdh7wLnb6NpV2OTYhaektE+pIMrSYVn0f8jgiHVOGG29wcpnS6HoNNEbrFZVglB8Ar3JI6x7sxdNXCpDmvtneOva3KCrhHr4nKfpM+qMc5bpLu0fQMqhMfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113207; c=relaxed/simple;
	bh=7Zm5MHhNP0WJbG+tpgISk4apGunnGgcTdEXAMkhvVys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdl/kjb1l7T2W0Ge3AcbuR1vvdFRRemgW1XVa46jAMLhDHkNKnkKD6AVR2pVHs4o2172KBvOFyT61v0+jRAXO3V+77uG6TPYtQGhxPB4G/lLukUc5raKk5FyP+P6f5KqHe3VfkFRBaaCPBRg1SFQRWVS+DFVth6+F2XaqYxpmL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FShQ8XjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FShQ8XjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EC9C4CEE5;
	Tue,  8 Apr 2025 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113207;
	bh=7Zm5MHhNP0WJbG+tpgISk4apGunnGgcTdEXAMkhvVys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FShQ8XjNQp3yv0L7WCJErfOEUmpAWAq8TgEmOIa86xLA6eqGch583IvL6jbSJ6rjS
	 vawIYpYbVkBCE44x1AoRxFVbTt6ntpXBAKnGDQ5FNJV68qeCdLlrTTdZbrgjWb6+wh
	 TtXpb63P+/14VQGVAOg8rn1fRfi1IWxCQmrHZYKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/268] of: property: Increase NR_FWNODE_REFERENCE_ARGS
Date: Tue,  8 Apr 2025 12:47:57 +0200
Message-ID: <20250408104830.278844829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index 525cc031596b6..7efb4493e51c0 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -83,7 +83,7 @@ struct fwnode_endpoint {
 #define SWNODE_GRAPH_PORT_NAME_FMT		"port@%u"
 #define SWNODE_GRAPH_ENDPOINT_NAME_FMT		"endpoint@%u"
 
-#define NR_FWNODE_REFERENCE_ARGS	8
+#define NR_FWNODE_REFERENCE_ARGS	16
 
 /**
  * struct fwnode_reference_args - Fwnode reference with additional arguments
-- 
2.39.5



