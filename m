Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4926C3DF001;
	Mon,  4 May 2026 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904853; cv=none; b=WJxSDdNzayxsm3EjsY46QbqSY91l30YiAvipqpKPly3DCyTsYWHuuN+WheUZlp/rTUBZmyYVe/E51ysF0TFEHPyiYE0AymewpOi/qdFF50LudMPr7zVmbB0bmJoNZROd3Gq8+Hz1q9YaRXWjS7PkSBY5wyCuzvxSmhJCPRC6RlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904853; c=relaxed/simple;
	bh=UXMNDHbiDhk109GoSYid5SjUhdkSIp/XyOCK4ccCeVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMjf92sC0x2oJf0y5VMh67VYCGXajI/7nbFGn/FmbzbKnE10Ga15RdkC2CPafRNSXW1rIPw6zY4y/Ggmy6MDXcdHZFTMC6HemxCR9cslAfUZYAiyE7WwjRlAf09c/Hjlwg59CoGWxY55B1x2q8PxwmXaOZiAj3mnwLMgsxMI4Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXUX1Khf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXUX1Khf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F9CC2BCB8;
	Mon,  4 May 2026 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904853;
	bh=UXMNDHbiDhk109GoSYid5SjUhdkSIp/XyOCK4ccCeVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXUX1KhflAx4tLWDShpvKJusNCvdOCDdqrqR5K7vsB7Ck7sjdEXMOfYJEUBBqoeU9
	 H+4YNvE8Bt0Djmz3gtXO6qfff9dHxrfr960Aeaqu3L+O04sF+x2pVY54veM3AuQY1f
	 4XrOinhJZ2fHDl1qzVILsVqwgo6xhLhnCbkuKpoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 172/215] seg6: fix seg6 lwtunnel output redirect for L2 reduced encap mode
Date: Mon,  4 May 2026 15:53:11 +0200
Message-ID: <20260504135136.470229228@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Andrea Mayer <andrea.mayer@uniroma2.it>

commit ade67d5f588832c7ba131aadd4215a94ce0a15c8 upstream.

When SEG6_IPTUN_MODE_L2ENCAP_RED (L2ENCAP_RED) was introduced, the
condition in seg6_build_state() that excludes L2 encap modes from
setting LWTUNNEL_STATE_OUTPUT_REDIRECT was not updated to account for
the new mode.
As a consequence, L2ENCAP_RED routes incorrectly trigger seg6_output()
on the output path, where the packet is silently dropped because
skb_mac_header_was_set() fails on L3 packets.

Extend the check to also exclude L2ENCAP_RED, consistent with L2ENCAP.

Fixes: 13f0296be8ec ("seg6: add support for SRv6 H.L2Encaps.Red behavior")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260418162838.31979-1-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_iptunnel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -715,7 +715,8 @@ static int seg6_build_state(struct net *
 	newts->type = LWTUNNEL_ENCAP_SEG6;
 	newts->flags |= LWTUNNEL_STATE_INPUT_REDIRECT;
 
-	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP)
+	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP &&
+	    tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP_RED)
 		newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
 
 	newts->headroom = seg6_lwt_headroom(tuninfo);


