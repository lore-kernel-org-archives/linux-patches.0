Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42419332919;
	Sat, 30 May 2026 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160213; cv=none; b=mEyJMruYptgK3NprFKz+fs2Bp/zxGzC/iGmb5r+2+cfi4XNAM/zddqil2tdXEV0T/ZO2V6kiazp2pqkcHNdnJ2vL4y7wJGdMR48PJsGEhosKYKaDkm7aumexvIFbPALtr1Yvcyb66QvtwEJhbg+WslNVbWDRUXbof9q4Tw+OpOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160213; c=relaxed/simple;
	bh=6wB9XwudaZq/kqu/RB7mHQ3MM2fuCthnZHh9tya4J18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqp4GU3T9TXuotx66ihXAhGZV6+WWzJLOrIUB71R2sKQlm0u3HHdeX21mPzFIaXxlQputrOLyQbcjOsytSXu7MG9WFEw+VRnwESlh+8wiFgGayY9qTaGxcMRBeMmXQIXMhQQi41z89caCY9sPmMUufXJ+q85FLmRI6ROcT+ncJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdOGJgSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdOGJgSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728191F00893;
	Sat, 30 May 2026 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160212;
	bh=qvcoGOPCL9iEreoVI3vKf8zTHnMaCC2kWFRyXKr/5Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdOGJgSXFpS88FMItqpEY0Vfn/kKxFgnEMI0rp8g8kxuOvIAuBmuHjHoOdO/NIdLq
	 6nu/tKq0sBIe6J7aXU22KEES2rA20JOMnnmSZh9v0vv2+oAS+gnb6hUAeEspOyI+aM
	 GSWH6la+zqb5qCL4Zv0pN+W5dqA5HrpQNoEijHPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 269/969] seg6: fix seg6 lwtunnel output redirect for L2 reduced encap mode
Date: Sat, 30 May 2026 17:56:33 +0200
Message-ID: <20260530160307.901943695@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -712,7 +712,8 @@ static int seg6_build_state(struct net *
 	newts->type = LWTUNNEL_ENCAP_SEG6;
 	newts->flags |= LWTUNNEL_STATE_INPUT_REDIRECT;
 
-	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP)
+	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP &&
+	    tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP_RED)
 		newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
 
 	newts->headroom = seg6_lwt_headroom(tuninfo);


