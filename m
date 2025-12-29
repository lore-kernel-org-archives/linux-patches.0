Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840DD222560;
	Mon, 29 Dec 2025 16:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025081; cv=none; b=dsonaZKKB2Yt3Ets7PzYsBXEgF5jH49OEVZtnW4rktEKsy0SysgaepmXdxxGTK35QTuaxNurpyeOjv1NzalsdhVa2w437cR2ectFwB92uIjLl+IIp+xOieCPZOi2GIitVN53jMFcXHbJNcSzPrh6hgHFlxnQqvOABcDQAzOhYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025081; c=relaxed/simple;
	bh=l53hEBknxNENuxjGo8nUWYM6yuerbb7LmPOeXbXxINc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N78cjNOXFIeimVgqcqyNXj73Br+Fma/a78Hqq5JePEAkkuiKuzRc0EBaL7Vhu5YJppzZeNxFolTArLQ2b7nrsdQPFsL/bFl4SiJxqLJgbcbfqYKz4bqjtDmT0E0anqzCeSfP017m7DIr8VXuYQmOp0/bGoC5juBmqasnBot5vP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvvuPSfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvvuPSfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEA8C116C6;
	Mon, 29 Dec 2025 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025081;
	bh=l53hEBknxNENuxjGo8nUWYM6yuerbb7LmPOeXbXxINc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvvuPSfm5R81H8Bw33m8aU04mo6K1VrTuLIZR+YRbp1f3uiGIER+eh8qj6+xMeTI9
	 TGzhauz7DyD/hvy/Z7hCzmmVsvTM2g33I/bwVvUMawt5eHPF1DCBi0Xm3u9q7qy5OH
	 9Kmk4zB9peuW5j58hV4Viq8NISCzqd33lYBnkj0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Chen <yiche@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/430] selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel
Date: Mon, 29 Dec 2025 17:08:09 +0100
Message-ID: <20251229160727.564016027@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit fec7b0795548b43e2c3c46e3143c34ef6070341c ]

packetdrill --ip_version=ipv4 --mtu=1500 --tolerance_usecs=1000000 --non_fatal packet conntrack_syn_challenge_ack.pkt
conntrack v1.4.8 (conntrack-tools): 1 flow entries have been shown.
conntrack_syn_challenge_ack.pkt:32: error executing `conntrack -f $NFCT_IP_VERSION \
-L -p tcp --dport 8080 | grep UNREPLIED | grep -q SYN_SENT` command: non-zero status 1

Affected kernel had CONFIG_HZ=100; reset packet was still sitting in
backlog.

Reported-by: Yi Chen <yiche@redhat.com>
Fixes: a8a388c2aae4 ("selftests: netfilter: add packetdrill based conntrack tests")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
index 3442cd29bc932..cdb3910af95b4 100644
--- a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
@@ -26,7 +26,7 @@
 
 +0.01 > R 643160523:643160523(0) win 0
 
-+0.01 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep UNREPLIED | grep -q SYN_SENT`
++0.1 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep UNREPLIED | grep -q SYN_SENT`
 
 // Must go through.
 +0.01 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
-- 
2.51.0



