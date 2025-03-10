Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A20C2D023;
	Mon, 10 Mar 2025 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629380; cv=none; b=eLKZYAvMYOGFFiMhyYMWkmbYNx6ceA7xnVzH6aLFf+vUWHdZdHSn8n3BDA0WDAOB+TF9Mwj13ReSo2AQK1UL/aldunalcee/pco+tazaiM+0yCKlLwBPtQAWiLzroUp25RA/KciUK3fo4PEgbcMcjqDbN3NaPm57jg34o9yxLBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629380; c=relaxed/simple;
	bh=OaICwe9muZFP++wsW1uOLclBdg+A3yrrdlNrChh3+/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YStN05s60rxl+pTX6BGPO4lOfKQ84A0Uh09Xu2OuvoUjS2mlNlHlgnoDS8D+qsQNGpKMI8AIY2UddCithTpofx7LlEWIWpbfP4nu0qmSLvFDz983Ys3s0ABCjCJq6c0WajAo0CCvD6iGMSFgswJCkic7yp/q79+KBpa1Qg3qzaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVm0vxkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVm0vxkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6B0C4CEE5;
	Mon, 10 Mar 2025 17:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629380;
	bh=OaICwe9muZFP++wsW1uOLclBdg+A3yrrdlNrChh3+/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVm0vxkmbqCSrYhnn8cq5SA8mxdzT5W6R3ZShQnHmilnmrfWViJFqz2jkKhUSah5Z
	 wL+WyCmxYqL9Ve0EqXU0WAP4icYHyTPIxoYYnHkmLmbirFiyNng6o1K7v/BvnRo5Wj
	 bhRZdL3LBMqBmbrxSmRwzCbCaPYSh4nwPaBIKdqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 274/620] of: Correct child specifier used as input of the 2nd nexus node
Date: Mon, 10 Mar 2025 18:02:00 +0100
Message-ID: <20250310170556.436874033@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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
@@ -1658,7 +1658,6 @@ int of_parse_phandle_with_args_map(const
 		 * specifier into the out_args structure, keeping the
 		 * bits specified in <list>-map-pass-thru.
 		 */
-		match_array = map - new_size;
 		for (i = 0; i < new_size; i++) {
 			__be32 val = *(map - new_size + i);
 
@@ -1667,6 +1666,7 @@ int of_parse_phandle_with_args_map(const
 				val |= cpu_to_be32(out_args->args[i]) & pass[i];
 			}
 
+			initial_match_array[i] = val;
 			out_args->args[i] = be32_to_cpu(val);
 		}
 		out_args->args_count = list_size = new_size;


