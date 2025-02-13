Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584F31411DE;
	Thu, 13 Feb 2025 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460481; cv=none; b=mUolP4El0TnhqPpJmNgT1S4ok/ypjAMqMy+q4uP3qsroB85iW93G9z2PNLbW3QIsCpX2diPMOm3JmWmPuZEJkF8a3s7WqVAr5yMwDrLZaNO3L7FNgrGKntmxRLFcj0Zb3sK7A/7R8pyKuRAtp0Li4vrKSENUL5828dEg7BWwSr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460481; c=relaxed/simple;
	bh=lfbeVohbFfwfBSAQ482iPtxtXS2CPbhE+VBqavaXm+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSRYIalomI48MyGL5ZTkS1EpqOsg7FM6amOcCHfvWrW5PtlDRqPSh22PYts44YYLYum7XqhQNDv1lQmv4e0B8ViT0Jef/ZRLnwAZXZ9OX/AX/VxfxNJoyln7B7wfgjXEx7S9HczCFfO5PdCrdZwn6NAiBjUM2SlT/6YOCgcY66g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I92jdWd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I92jdWd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD2AC4CED1;
	Thu, 13 Feb 2025 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460481;
	bh=lfbeVohbFfwfBSAQ482iPtxtXS2CPbhE+VBqavaXm+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I92jdWd/OKIrGIavLUr2Ir0wmfBT4H1JktVKrHKLdvaci2ErKise3pW/2VN+xpnKm
	 KMI7TPgpoClxFf4PSWsBOk5gqeiYv7C/aoPaePlkue9LaODRJhXYr5tVPUormIheVo
	 Mf/yWUBKUMVyLrpMapNEDSV3UEbV5aLO3s77FeNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 123/273] of: Correct child specifier used as input of the 2nd nexus node
Date: Thu, 13 Feb 2025 15:28:15 +0100
Message-ID: <20250213142412.203082140@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

commit e4c00c9b1f70cd11792ff5b825899a6ee0234a62 upstream.

API of_parse_phandle_with_args_map() will use wrong input for nexus node
Nexus_2 as shown below:

    Node_1		Nexus_1                              Nexus_2
&Nexus_1,arg_1 -> arg_1,&Nexus_2,arg_2' -> &Nexus_2,arg_2 -> arg_2,...
		  map-pass-thru=<...>

Nexus_1's output arg_2 should be used as input of Nexus_2, but the API
wrongly uses arg_2' instead which != arg_2 due to Nexus_1's map-pass-thru.

Fix by always making @match_array point to @initial_match_array into
which to store nexus output.

Fixes: bd6f2fd5a1d5 ("of: Support parsing phandle argument lists through a nexus node")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-1-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1453,7 +1453,6 @@ int of_parse_phandle_with_args_map(const
 		 * specifier into the out_args structure, keeping the
 		 * bits specified in <list>-map-pass-thru.
 		 */
-		match_array = map - new_size;
 		for (i = 0; i < new_size; i++) {
 			__be32 val = *(map - new_size + i);
 
@@ -1462,6 +1461,7 @@ int of_parse_phandle_with_args_map(const
 				val |= cpu_to_be32(out_args->args[i]) & pass[i];
 			}
 
+			initial_match_array[i] = val;
 			out_args->args[i] = be32_to_cpu(val);
 		}
 		out_args->args_count = list_size = new_size;


