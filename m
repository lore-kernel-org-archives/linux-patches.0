Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF813DE454;
	Mon,  4 May 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903565; cv=none; b=sHL+mjjbcrdlrwdUt7OHNkI4GwDPtOz8g30hbs1SWtPeDSXsdxCRxBXBqoSwDZ7bJv/eHX1zO+y6Jd5KUgUKVlD9Kl1LLls3bwDMAWsVfbg2yFwiHKBVmxkI/37xocwRQgbmYfWdPJ3Zy0+ZJ6K8aJMcv1NhIVDjSP6uQZ+A1Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903565; c=relaxed/simple;
	bh=O4gkvfw1bLmZ7hXrVMbKSw155gsfrBL2R1WMkUedQXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj72UZPoZvLwBLIyCtupt3YdJFdMu1pYJl9LT1hnaUJjWXecs1wt02rQwO3t+QGbglGoxDP1/Z5O9aCAhP1Ocq3bWnDVWQASFyADaOqrIYVm83ikV/FzriTk6r06Cmzc2VUAmC2eX4Jgbl4IglBVsLylJqA4Svuc0e4Eow0/KB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW5WrQkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW5WrQkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE264C2BCB8;
	Mon,  4 May 2026 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903565;
	bh=O4gkvfw1bLmZ7hXrVMbKSw155gsfrBL2R1WMkUedQXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW5WrQkbONoBtg6GyXW5nmVNes3OgdUT97hQhAH1cKMxlKSCJF/YZRFSmMgx8sAtm
	 SK/WdmKdtUUcMJdQc5myuVkkKzhC4CwTmVqJCltYSnhCCMKjwquGfWs0xWH+naTh8m
	 /hJfljzEV1+RPTrzvlBfhAuv5atPyILCH5QuLh1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 284/307] seg6: fix seg6 lwtunnel output redirect for L2 reduced encap mode
Date: Mon,  4 May 2026 15:52:49 +0200
Message-ID: <20260504135153.478482438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


