Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DC8A93C;
	Tue, 13 Feb 2024 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845892; cv=none; b=Pbv+cQFxrKFwZS+zn4Dk+HiWXjUwJZmGGxeSUYSLYa4ZAHApCHTHBZv76ZDm44H/joR5wV4uYuqwi+yAvSIKUXo21A2zAdNcfjTeHr1GmWC7RX4Sommi5RgTR5yX+/PhE9lMI7jPM4dyTpJrgomDh6mz2pTMqybgR0E65ntlj50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845892; c=relaxed/simple;
	bh=zqNL3VcTfYYSVw4NtGg0liUcVbf+XzF44vUU3ivJ4yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryG75QdTu+7Y0bHJQgGMxZVvmHwu7Z4tUSY5Eb2Ovn74aCyfvKGCcFAlnInzX0+1qjTtTIUK+18PRmNfqUvVyC9mZLxaFVNVkMD6YxvV+i8ssl7C2nK5GSP1jIfqsizRIjucT7+PuFrO7iqmi9pdP7MXZRWLILDSuO2S7wb/Q54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mejbHFkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mejbHFkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D23C433F1;
	Tue, 13 Feb 2024 17:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845891;
	bh=zqNL3VcTfYYSVw4NtGg0liUcVbf+XzF44vUU3ivJ4yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mejbHFkvzLjAWlMmvX22fuV0U7BshpU5xasHKMWdsakzISIPelflXsmbeuSBIUjcn
	 FLsdOTaOhUlvwSJmlBHtmsfVzL6lh4FWOQ7gC1A+u3FnRZ6HBWQt7Sj6T5TfJ1+rPi
	 N0m95WE3931qUZswPePTBOQrh2UjpmM+xlpc3WYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 058/124] selftests: cmsg_ipv6: repeat the exact packet
Date: Tue, 13 Feb 2024 18:21:20 +0100
Message-ID: <20240213171855.433479447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4b00d0c513da58b68df015968721b11396fe4ab3 ]

cmsg_ipv6 test requests tcpdump to capture 4 packets,
and sends until tcpdump quits. Only the first packet
is "real", however, and the rest are basic UDP packets.
So if tcpdump doesn't start in time it will miss
the real packet and only capture the UDP ones.

This makes the test fail on slow machine (no KVM or with
debug enabled) 100% of the time, while it passes in fast
environments.

Repeat the "real" / expected packet.

Fixes: 9657ad09e1fa ("selftests: net: test IPV6_TCLASS")
Fixes: 05ae83d5a4a2 ("selftests: net: test IPV6_HOPLIMIT")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index 330d0b1ceced..c921750ca118 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -91,7 +91,7 @@ for ovr in setsock cmsg both diff; do
 	check_result $? 0 "TCLASS $prot $ovr - pass"
 
 	while [ -d /proc/$BG ]; do
-	    $NSEXE ./cmsg_sender -6 -p u $TGT6 1234
+	    $NSEXE ./cmsg_sender -6 -p $p $m $((TOS2)) $TGT6 1234
 	done
 
 	tcpdump -r $TMPF -v 2>&1 | grep "class $TOS2" >> /dev/null
@@ -128,7 +128,7 @@ for ovr in setsock cmsg both diff; do
 	check_result $? 0 "HOPLIMIT $prot $ovr - pass"
 
 	while [ -d /proc/$BG ]; do
-	    $NSEXE ./cmsg_sender -6 -p u $TGT6 1234
+	    $NSEXE ./cmsg_sender -6 -p $p $m $LIM $TGT6 1234
 	done
 
 	tcpdump -r $TMPF -v 2>&1 | grep "hlim $LIM[^0-9]" >> /dev/null
-- 
2.43.0



