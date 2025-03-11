Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2222D1DF749;
	Tue, 11 Mar 2025 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706919; cv=none; b=JhAJQxgk3k8pQouhHcO5yEUgsK/9nZw/wlPcZ11Af76QPkfecjBxFSla9606EFZ4MtBpga+RFHbdA1xdE51tMD2OdxZNIKbRxPQTiskGlBsJh8JB81r9Fd0qaNOHB5L3ipme4SDwnucoTGGPB0DvEfyxLbvmG9G0FDc10l1/elA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706919; c=relaxed/simple;
	bh=cFeSBrY1sm/TpNSCY4yXUHe3mkhjMS/1LbyNJ6rIBU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft/GkuYLHoqjlAlvNI89bJVqO+8dpx3/dRdb4FZOqCR3uU7At8VnoFP+2WXGbnXAyS080G2XMyh7GR5zMvysUGThiBX53bhfhhl85zoJyZlK6p5nEnOGffu5vvUiY/JbL+e0Vv3KFizsBdnA6iWj/aY7ucu1AbE2OmYYe6BIEpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px8KpfkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px8KpfkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CCBC4CEEC;
	Tue, 11 Mar 2025 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706918;
	bh=cFeSBrY1sm/TpNSCY4yXUHe3mkhjMS/1LbyNJ6rIBU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px8KpfkZuJJVh7M/ynDNEgWQqLVFghPWoqMbXnH8bKRe1lHj2+RVMe2UX9ROfb2yX
	 SaYm+bJzf7nI7wtSI/dKtHWiRRFQxpa3oZXq3oI2nYmNmIewh/3KJaw6mWR5fOUglC
	 U3DjhT1qEdwlvnb+LMr+fm2nogW42h6NcBTfI1U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 181/462] of: Correct child specifier used as input of the 2nd nexus node
Date: Tue, 11 Mar 2025 15:57:27 +0100
Message-ID: <20250311145805.504323953@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1659,7 +1659,6 @@ int of_parse_phandle_with_args_map(const
 		 * specifier into the out_args structure, keeping the
 		 * bits specified in <list>-map-pass-thru.
 		 */
-		match_array = map - new_size;
 		for (i = 0; i < new_size; i++) {
 			__be32 val = *(map - new_size + i);
 
@@ -1668,6 +1667,7 @@ int of_parse_phandle_with_args_map(const
 				val |= cpu_to_be32(out_args->args[i]) & pass[i];
 			}
 
+			initial_match_array[i] = val;
 			out_args->args[i] = be32_to_cpu(val);
 		}
 		out_args->args_count = list_size = new_size;


