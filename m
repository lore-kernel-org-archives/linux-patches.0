Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DCD42A15B;
	Fri,  7 Aug 2026 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114208; cv=none; b=SGCPGGP5ZodOVHVMkhUZ/JDVXHCuzMbE/6YdI69OzBWsM0Ngb2lkXDPpoU2SaFNajfNLdsxLxI2MkW/GsaJ1FvTfwIGeFXtuDWcxFnNgiECAi5xPC1bQJclBMgFBhaf+LYHIjoOAIcW6LTGdpggrzsb83TGINJCMvgCRBui9oQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114208; c=relaxed/simple;
	bh=M4D4zDBH5kgk+jeJpl5yjHKxsHl16UK0kc2bqENhP7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKdmZsO2ypzu0aBTTx1wvTAC7mMmUs1SvX/cmTPs6H57YQ2kOI4wDjViFANGKUBPYAs2jzBhupvRF+4AoLB0N/64JubwMHgWDxncf+QHSQArJx22ZxtANvAMN623kjXunMS/SrTSK2PDwEhIyd54PNmsjO0O45Xs8PAeH2V2ovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/KIcvme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/KIcvme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0191F000E9;
	Fri,  7 Aug 2026 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114206;
	bh=NDAgcYCUnr3ImeFWaq0i9ZUAHWe3kh0m9voYFnHGTX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/KIcvmetfNIcKRHktHu7xGfuJupjNj03cRnD4cZ1fC2mA7Sqd5IalJxRzsgPSYdN
	 XAYHDnJ4DfMfggnjPVDi0nMk3kRyezQ6FI9LwU+TAKNClnKzDhDX8Z6OORSr+gPOHw
	 z5UvHUGTUXrgBVdeqq7tkgGCj5Jhp/hUpANM4kp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 183/337] net: ipv6: clear suppressed fib6 rule result
Date: Fri,  7 Aug 2026 16:36:26 +0200
Message-ID: <20260807143422.525792061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 6aea62e433fe1b586202a5fee8b5807ce635e1d7 upstream.

fib6_rule_suppress() drops a suppressed route with ip6_rt_put_flags(),
but leaves res->rt6 pointing at the released rt6_info.

If no later rule supplies a replacement, fib6_rule_lookup() still sees
res.rt6 and returns that stale dst to its caller. A suppressing rule can
therefore leak a released route back to rt6_lookup(), and the next put
hits rcuref_put_slowpath() from dst_release().

Clear res->rt6 when suppressing the route so suppressed lookups fall
through to the null dst instead of reusing the released one.

Fixes: cdef485217d3 ("ipv6: fix memory leak in fib6_rule_suppress")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/4b8acb7787d54e440155585dd32ebdf0bef7d122.1784710966.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/fib6_rules.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -302,6 +302,7 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_s
 
 suppress_route:
 	ip6_rt_put_flags(rt, flags);
+	res->rt6 = NULL;
 	return true;
 }
 


