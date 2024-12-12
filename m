Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012C92236EA;
	Thu, 12 Dec 2024 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019524; cv=none; b=eckQ/iCZqklSiqlMzuwelB/NA9DNPrlCfG/3hnIsyNWiVNAu1KdfB+4IQ5fRAMdOvjEiS9vHCWj1H48oDSyEvH7253LrsXZUNvFW7PTb5+mjlTXCDGXy3iZ5yqiiabr/rXVJMV45UepY0XCBmpcnQ3RyqrWL74o6dbWSZsVZsQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019524; c=relaxed/simple;
	bh=yppY8/k2SvDK2u4RkVGeALp/cWqVjGVPi/nKXcg2oFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2o4QFm/IXDd8RghGJc+f0abHJyt9UtzEayFDB7wOiYlA4cyiILonJztiQrblOUNsOktyb5LV0lGl3xc/ThKzYZurVCs5IMJmpDueV/7QUQ/e6OIDT+B/VdnzDDFXtWNjKf23OmWLNyrq8ZvoFv/QsyyhtpaL5h6F9P/Is8WXjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9Xk/xWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9Xk/xWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A17AC4CECE;
	Thu, 12 Dec 2024 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019523;
	bh=yppY8/k2SvDK2u4RkVGeALp/cWqVjGVPi/nKXcg2oFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9Xk/xWcnrFbqqvO0I0Xs3JKblz4CI0YWZzvab0+TPz+A9sZ8TS5O2dqB4Ge5ZxX3
	 VMnmOV+6GAcp3Dp7zNXVZWyZ5oLNgTb9HYIR8NzU8sZbFudRqqpYWmug+TT1XEwnvu
	 QMTxDrJdz3Y1mCP+4DPxKUEdMQUoSleaAqZOey6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/772] wireguard: selftests: load nf_conntrack if not present
Date: Thu, 12 Dec 2024 15:52:24 +0100
Message-ID: <20241212144358.160147743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



