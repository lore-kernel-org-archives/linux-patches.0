Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AFE8632E;
	Tue, 11 Mar 2025 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705714; cv=none; b=sX9r9BLW5KkNYZPRjDd7jtmbc7MixIMFBTdVSpHS3XTe0ecLKjhZEdTLWl/vja3Ne69DfoM3Afa7EuiyUJfx4yfxvTQUC5VZZwrM1LjVUj6VoRdMmA537Lo7QeJKa5xMG0hHhQ24EXjCBoZBHV+DqHAdUxGSngZfC94BVwly9Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705714; c=relaxed/simple;
	bh=+hfaDzzaLSqf31Y6UWIIkgOa14vtiKqipkZkENe96BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWR//B7gCnugtsX/Xtc1VDSJnSpdjzTl/sD3G/fBEXmLt/ciUB4k28baeKkpcODzrFe8rnokvZtsTNYvta5nHt3fCGxddVaIowte80vyTr/FYoUn/Tijpfv19wlPL95wzmfIGSyTVBL2kjDULivMgeoFcQlJ/yoNAAIyn7B5KPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Or/pg+Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Or/pg+Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BD3C4CEE9;
	Tue, 11 Mar 2025 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705714;
	bh=+hfaDzzaLSqf31Y6UWIIkgOa14vtiKqipkZkENe96BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Or/pg+CdNG265M/0g9MEk4X8DeODP8Trp4L3XtzEkddeMCzY/2JvIA0Uep4HOsBMY
	 GB6pSc0IBBHHLQT14pd4mZjDq79rci3JtgXswrGKy+FVHlTjDVZR8y31favst1Pu7D
	 04ipFZ2UUDLHrW6TnGknfL7FtnOvdgB7Qi0KalE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 130/328] of: Correct child specifier used as input of the 2nd nexus node
Date: Tue, 11 Mar 2025 15:58:20 +0100
Message-ID: <20250311145720.069146910@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1733,7 +1733,6 @@ int of_parse_phandle_with_args_map(const
 		 * specifier into the out_args structure, keeping the
 		 * bits specified in <list>-map-pass-thru.
 		 */
-		match_array = map - new_size;
 		for (i = 0; i < new_size; i++) {
 			__be32 val = *(map - new_size + i);
 
@@ -1742,6 +1741,7 @@ int of_parse_phandle_with_args_map(const
 				val |= cpu_to_be32(out_args->args[i]) & pass[i];
 			}
 
+			initial_match_array[i] = val;
 			out_args->args[i] = be32_to_cpu(val);
 		}
 		out_args->args_count = list_size = new_size;


