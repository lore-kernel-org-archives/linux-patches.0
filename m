Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9FC38389;
	Thu, 13 Feb 2025 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457745; cv=none; b=WQoawMPgusnxO4Ak9MfDulVjgTeQlVBInNLTAJNiiBQJNz3xchs1wYH8Crkvfce7ijex8WlW2P9XtuZT8nBZg6evobL44Dpb1b2aopWPT12fSQLayaNCUulacMAodDMc2OgBhM9pnNVKLdP2pEVxwfhbs2xreNcN7kTRXPwk86Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457745; c=relaxed/simple;
	bh=lHf0oQpe6JHrsZ4Ig8v85M+ULhQDWsMfkJVYBe3dZfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcZeu96jciA6bi16jTk8JoI6YKykjN+W8q6mGNOpA3cLpiYPZUHDaas4ZR2/KQC04irD1DIEApsSKxJESe7N8TwqQZHNrTUKWFz5W3+dtVlat6HLEHQ74UCSO8mI5rCZ/9Ks3P1NKGKg6CxauIuIbbfFwU1vQa9zKDpxQwEmxQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0ZFjKFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0ZFjKFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1BCC4CEE2;
	Thu, 13 Feb 2025 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457745;
	bh=lHf0oQpe6JHrsZ4Ig8v85M+ULhQDWsMfkJVYBe3dZfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0ZFjKFyP1wJZAHh4edRjBuSU0aqzK7zgPqwmZKWpgFFj5r0vidA7n1J67d1pYgkj
	 Nw0oPdPK6sSxQrqKGc2iWJMOhXj4c2YEEP5JBiyRXw+fpRgnz4BYMp0peHOXN9AX/T
	 bbYkowIdYQY1+ZCqwhHTkDuaT3nPs4yq7xxjqK8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 194/422] of: Correct child specifier used as input of the 2nd nexus node
Date: Thu, 13 Feb 2025 15:25:43 +0100
Message-ID: <20250213142444.031210229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1493,7 +1493,6 @@ int of_parse_phandle_with_args_map(const
 		 * specifier into the out_args structure, keeping the
 		 * bits specified in <list>-map-pass-thru.
 		 */
-		match_array = map - new_size;
 		for (i = 0; i < new_size; i++) {
 			__be32 val = *(map - new_size + i);
 
@@ -1502,6 +1501,7 @@ int of_parse_phandle_with_args_map(const
 				val |= cpu_to_be32(out_args->args[i]) & pass[i];
 			}
 
+			initial_match_array[i] = val;
 			out_args->args[i] = be32_to_cpu(val);
 		}
 		out_args->args_count = list_size = new_size;


