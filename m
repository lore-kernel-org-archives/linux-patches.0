Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF1A4F218;
	Thu, 12 Dec 2024 17:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024028; cv=none; b=G9QYOIYKoMqCYqUpmxn27HpBpLnWfWoBY4ywuKe9Yp9z5rX2TSDPcca11tiZIo1SHifo8UBHKoA8ZN6QycY7sclfyFzqBF12GFheYUH3x6E8BK3O/Um6mn7mdORCNXEnPvixeZDM6LRwNG9zmiaQ2vJXKTuIeO2EZIIuWOpKYgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024028; c=relaxed/simple;
	bh=p5AybDFq6SO27z7homJIvaCMimggntxJdNL/CfGazqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mH3/4CQJBtVLU4EwphHhFzXWNUK+7Ywi3gisoyFgI/+nehM6eTEA+tQ5VAtl96OC1Ir82ZqFbDDen0T5mjj9Qse+9muzF6iSxHtAxuJkm0wh4TbxyHqMhd4dqVsz6u6cMyd2jXJaCJ4ZqSKOiKSVBFAysr3OJAAfcecg24CUUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvCb6KjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvCb6KjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2126DC4CED3;
	Thu, 12 Dec 2024 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024026;
	bh=p5AybDFq6SO27z7homJIvaCMimggntxJdNL/CfGazqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvCb6KjVi3TD8OLEJAVA1tBf5Fcna4g/bigETYWh1jnj6HaB75y99/FH9lhG7VYY4
	 PbTwkoLaS7MxQaVHMi/76mvryfV//CxmZlIv+0vjfh5h22PVnzKJWY7s1UfYMQxChh
	 ApSCs8hzjo0ZrYwOwIWbt1wIcOdFIkS76TOe/8G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/459] wireguard: selftests: load nf_conntrack if not present
Date: Thu, 12 Dec 2024 15:58:20 +0100
Message-ID: <20241212144259.916233570@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 93e44410f170e..4732c23e35ee5 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -320,6 +320,7 @@ waitiface $netns1 vethc
 waitiface $netns2 veths
 
 n0 bash -c 'printf 1 > /proc/sys/net/ipv4/ip_forward'
+[[ -e /proc/sys/net/netfilter/nf_conntrack_udp_timeout ]] || modprobe nf_conntrack
 n0 bash -c 'printf 2 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout'
 n0 bash -c 'printf 2 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout_stream'
 n0 iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -d 10.0.0.0/24 -j SNAT --to 10.0.0.1
-- 
2.43.0



