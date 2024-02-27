Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F101B13B293;
	Tue, 27 Feb 2024 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041105; cv=none; b=mJ7/NiA3xqjOLtm/wx6ZeHMGNesuNC2Wkf9v/FBwd3Yn48qLbDJoXcWHfcH4eP/SUN/fU/OFLPWcQbT/nNu2+SIC0r/PDFdlRuPmrps5Zgv+VjbOGyp2nPBqk+3IRhjo8J5uLg4y9UnDnBCPUCaX6P9V+6QeuVZleSdlHeV1fgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041105; c=relaxed/simple;
	bh=QxQ8GbroggAaEbpZpOrenWcuD+TYnBg0pO3LA463ICA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltgmSS7RXIKwrSm8Ww9Zk153k2YapNKlF2rdUsqUbLEbtFDWq98OSAwtzEFhlCXJcKoBamcB+ggGanKhM0QZ32R2zSQdKv2XndVQazq9N4+SrCVQoO/JsigjbCpiMeOurWTzJVS6Xp5FXR2naPiPvsWsLFD0cv29yffI8D4cENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyDRUcbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyDRUcbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCCFC433F1;
	Tue, 27 Feb 2024 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041104;
	bh=QxQ8GbroggAaEbpZpOrenWcuD+TYnBg0pO3LA463ICA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyDRUcbThKgONpbsE63JLn5NVg6kGocFn0lKGfmarzW8/wNTrRm72mc6EoZ09NiXl
	 aVhi4/M0aL0REEmBbNmb96fOU51vY/6m8T8AkEdzGYlUAMSFkh8ruMvbRBrWuX+uZ5
	 svXqYi6MUN/68nIYoXHtspDmDuDzUN4PSD7EcKOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 222/334] selftests: mptcp: pm nl: avoid error msg on older kernels
Date: Tue, 27 Feb 2024 14:21:20 +0100
Message-ID: <20240227131637.933714127@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 662f084f3396d8a804d56cb53ac05c9e39902a7b upstream.

Since the 'Fixes' commit mentioned below, and if the kernel being tested
doesn't support the 'fullmesh' flag, this error will be printed:

  netlink error -22 (Invalid argument)
  ./pm_nl_ctl: bailing out due to netlink error[s]

But that can be normal if the kernel doesn't support the feature, no
need to print this worrying error message while everything else looks
OK. So we can mute stderr. Failures will still be detected if any.

Fixes: 1dc88d241f92 ("selftests: mptcp: pm_nl_ctl: always look for errors")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -183,7 +183,7 @@ check "ip netns exec $ns1 ./pm_nl_ctl du
 subflow 10.0.1.1" "          (nobackup)"
 
 # fullmesh support has been added later
-ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh
+ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh 2>/dev/null
 if ip netns exec $ns1 ./pm_nl_ctl dump | grep -q "fullmesh" ||
    mptcp_lib_expect_all_features; then
 	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \


