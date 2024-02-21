Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B57E1E4B2;
	Wed, 21 Feb 2024 13:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522952; cv=none; b=fAdiaLj+IigS2putKNIFRRIneMn0204fzqWMzSej/x45i3CosRgsEYMfiS2RgWoubNv+jQfHbpapdvr3hYxJLAYSTeEdey4Oe32IsPYkeoYaBM5c1Zd6eVDU03Nb7LzOtjrmD6qmNR71Sq1MsXsudYOAQtd+cJHWYkMUhj0DFus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522952; c=relaxed/simple;
	bh=SITxeQpW+GRQKi0folSu5aNmliCxa8Xx/+63UP394dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsHiAonsjwlhunZktLi3N+81E3bzNjJ1Su2dNUMAg3bdloW276fHBuDWDNiF0YU/5BBQfG+4E5J4TL2cBXUknRa77XmnXU7bcAxMa6HtuEnCUeJ6a+o0PFgq7tIaF0/jMmTs704BXwAfyFdidGVi6TSVrjLzf1u8TluP4CSR8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0U0Uzcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0U0Uzcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BECDC433C7;
	Wed, 21 Feb 2024 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522952;
	bh=SITxeQpW+GRQKi0folSu5aNmliCxa8Xx/+63UP394dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0U0Uzcb/hI3C++wWYle79jbHlRrYLXu94j9p2tujSn3GDxXXefHrL8qonOh3aUb7
	 prenjhQeAn5GjK103c7czHIsCZiM+wZx4RsXR0LwJ592kAoJknXiedp5cdtvuPmjIE
	 Jw1nM6owLJul97jCWMFSwGjCUVNYETK4A+KPs2WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/476] selftests: net: give more time for GRO aggregation
Date: Wed, 21 Feb 2024 14:05:23 +0100
Message-ID: <20240221130018.029546241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



