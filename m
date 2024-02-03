Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A778A1759F;
	Sat,  3 Feb 2024 04:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933969; cv=none; b=MargBrPRz0tWGzDhDTEyUfSUf8dbMUaPu1U9q3qlNps1GQXWjl27mIdm+dlhdt8TzFWls4VgFBgGSYgeixOl7vTO7mXvccFw37XPwrCfxCvz9u2SvMc/bmA+b6muvHpZzN/YK6epNt0w3JZGrpx1xj1+1kPRXBIL5vl/wGkr7io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933969; c=relaxed/simple;
	bh=+q86SVd6suYZe/E8qq6liH1usMgc+OHmvHq2P35mCx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwzHv/PJMDi+0MiNtYGnSH9QoK+NS2Hq6FuS8sFlGTyKTZA5wNjIvv+Z/sUeVzIzZteioTOsL4C4vW31hVfyrSuLdiyFR233Qn1/a87ZnldyYV0DUq5/s2hGKT3uDSPo07stbyGO0ofeXgSSJzthbIfIdTn2wBUaNuP7t5P38Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3CNdGAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3CNdGAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F44C433F1;
	Sat,  3 Feb 2024 04:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933969;
	bh=+q86SVd6suYZe/E8qq6liH1usMgc+OHmvHq2P35mCx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3CNdGAP2gW0Y3quR3TM+pbXhDQWXDMyTvaXNFpj2sWR8QQ/nJwJjY30VbUzP8xK6
	 4K1zxH0BtLtCHRGAZd95Z7LvPYHYp6kVtMEAFX/59ScxMRifd8YO6uK30Haec5vkF0
	 ydhDHeGOB0WE3sldcLg16fH+D6lqKwFb7I673UXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 306/353] selftests: net: give more time for GRO aggregation
Date: Fri,  2 Feb 2024 20:07:04 -0800
Message-ID: <20240203035413.516883090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 89abe628375301fedb68770644df845d49018d8b ]

The gro.sh test-case relay on the gro_flush_timeout to ensure
that all the segments belonging to any given batch are properly
aggregated.

The other end, the sender is a user-space program transmitting
each packet with a separate write syscall. A busy host and/or
stracing the sender program can make the relevant segments reach
the GRO engine after the flush timeout triggers.

Give the GRO flush timeout more slack, to avoid sporadic self-tests
failures.

Fixes: 9af771d2ec04 ("selftests/net: allow GRO coalesce test on veth")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/bffec2beab3a5672dd13ecabe4fad81d2155b367.1706206101.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/setup_veth.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/setup_veth.sh b/tools/testing/selftests/net/setup_veth.sh
index 1003ddf7b3b2..227fd1076f21 100644
--- a/tools/testing/selftests/net/setup_veth.sh
+++ b/tools/testing/selftests/net/setup_veth.sh
@@ -8,7 +8,7 @@ setup_veth_ns() {
 	local -r ns_mac="$4"
 
 	[[ -e /var/run/netns/"${ns_name}" ]] || ip netns add "${ns_name}"
-	echo 100000 > "/sys/class/net/${ns_dev}/gro_flush_timeout"
+	echo 1000000 > "/sys/class/net/${ns_dev}/gro_flush_timeout"
 	ip link set dev "${ns_dev}" netns "${ns_name}" mtu 65535
 	ip -netns "${ns_name}" link set dev "${ns_dev}" up
 
-- 
2.43.0



