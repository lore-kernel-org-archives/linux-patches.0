Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308ED1E871;
	Fri,  6 Dec 2024 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497311; cv=none; b=oxuvnuQng9DlamnP9jPuTEAga2i2a8wHBURCcPtUvAms2+aAHpdzL4enNm7RCQ7JjST88a6VymgVcvs/B244eH4euMIx5MwJU7sgURW/tEA7PZbZSLKaBK5XBMzbw/La1lj3QyHz0Lb9/BowcQluqvHFlO/Qr9as8ad6k1WRbT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497311; c=relaxed/simple;
	bh=Y7QvdWjnZsMbG4rXg0pJB1iugJiRZ+GVyl77nfAzcb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up1YUC6IOnvjfqRrwyT9SyCrLWQ4HreHYBN1FV2SfEmhAY6Ti/ffRVlzL+A1hiWFxxTNz6WY055ioFyKgTLnbRCVkQ9EpuVGIFcgdvCN2SYX3NUIwhruzWHSooF8N6r2P5zC0tnHfJwayXkPW0yama0iEHa0qu4+sCHR9jOy94A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlaqMMmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlaqMMmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F13BC4CED1;
	Fri,  6 Dec 2024 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497311;
	bh=Y7QvdWjnZsMbG4rXg0pJB1iugJiRZ+GVyl77nfAzcb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlaqMMmvNRQYu7oeK2IkKQHSuqj6nfXYxIAFpAhzrhxqgC0AppGqX0elsrF9x8LSM
	 p35eIFcKAIzEjNy47HkvUdNOh/Q4r0KIl9FDew94OXmKtLh+lsGSWp/lFyMEAYw9Nf
	 nls36MT5lo2eDNqkEIORC575P8HT4CPGwqxKkVbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/676] wireguard: selftests: load nf_conntrack if not present
Date: Fri,  6 Dec 2024 15:31:15 +0100
Message-ID: <20241206143703.332281587@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 0290abc9860917f1ee8b58309c2bbd740a39ee8e ]

Some distros may not load nf_conntrack by default, which will cause
subsequent nf_conntrack sets to fail. Load this module if it is not
already loaded.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
[ Jason: add [[ -e ... ]] check so this works in the qemu harness. ]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20241117212030.629159-4-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/netns.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 405ff262ca93d..55500f901fbc3 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -332,6 +332,7 @@ waitiface $netns1 vethc
 waitiface $netns2 veths
 
 n0 bash -c 'printf 1 > /proc/sys/net/ipv4/ip_forward'
+[[ -e /proc/sys/net/netfilter/nf_conntrack_udp_timeout ]] || modprobe nf_conntrack
 n0 bash -c 'printf 2 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout'
 n0 bash -c 'printf 2 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout_stream'
 n0 iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -d 10.0.0.0/24 -j SNAT --to 10.0.0.1
-- 
2.43.0



