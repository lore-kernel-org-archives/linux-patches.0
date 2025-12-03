Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D68B313E03;
	Wed,  3 Dec 2025 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777998; cv=none; b=b6yCYiCfOEBvN/62QjdltWUvgQflBPaCIrFMR+pn0ubrDiOVUznAc9JMFZJ++5YpRuztQdb+nxuvFGPEWiN7paW1dTHzM+lMeudHAxF03oqySoBkNwvOFUKSdRZYo2mCLzmlwQ3U9UEwireOzsuTfHw5xMeiq6W3EhVcAAufX1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777998; c=relaxed/simple;
	bh=XONGgOhfbwFMAJXbFP7rLNOYi3O8jFtJHyi7QAkR2+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Grjzov5BNcKg0S8QI+v1r/9lkV7orFZM4rLusy36AO5BBtjyuz2SkaJSGXrkvgWYqbMkWXNR8z5owuVDy/lh8EylcbywesO5ww6sZTSoAdyS3sq/9HtQJ+BXZpGc0J4EYcgdL+goa+CpVwYUAGsk+hkPtASaaMSwPYWKDhXxjS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/gzXW/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/gzXW/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48815C116B1;
	Wed,  3 Dec 2025 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777997;
	bh=XONGgOhfbwFMAJXbFP7rLNOYi3O8jFtJHyi7QAkR2+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/gzXW/7t8HXbwojqoB1+jzB0Mcb/QkbB9NTPEHYRL9GtAUhk+a44uhX2t+dC7vVg
	 3WFSemxBpoujhpJmPlO4LkJf3zN5IhbwuJN6wgcFGAqMkbdcxLgfwYZQqcq4Y28xu0
	 yR4c1mFlJ+Tz4Rr9tZY4XA5KQ3uYuh9qiXBi3AHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Anubhav Singh <anubhavsinggh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/392] selftests/net: use destination options instead of hop-by-hop
Date: Wed,  3 Dec 2025 16:26:02 +0100
Message-ID: <20251203152421.872685755@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anubhav Singh <anubhavsinggh@google.com>

[ Upstream commit f8e8486702abb05b8c734093aab1606af0eac068 ]

The GRO self-test, gro.c, currently constructs IPv6 packets containing a
Hop-by-Hop Options header (IPPROTO_HOPOPTS) to ensure the GRO path
correctly handles IPv6 extension headers.

However, network elements may be configured to drop packets with the
Hop-by-Hop Options header (HBH). This causes the self-test to fail
in environments where such network elements are present.

To improve the robustness and reliability of this test in diverse
network environments, switch from using IPPROTO_HOPOPTS to
IPPROTO_DSTOPTS (Destination Options).

The Destination Options header is less likely to be dropped by
intermediate routers and still serves the core purpose of the test:
validating GRO's handling of an IPv6 extension header. This change
ensures the test can execute successfully without being incorrectly
failed by network policies outside the kernel's control.

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Anubhav Singh <anubhavsinggh@google.com>
Link: https://patch.msgid.link/20251030060436.1556664-1-anubhavsinggh@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
index a6cf29c2c9318..e220b6f12336e 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -622,11 +622,11 @@ static void send_ipv6_exthdr(int fd, struct sockaddr_ll *daddr, char *ext_data1,
 	static char exthdr_pck[sizeof(buf) + MIN_EXTHDR_SIZE];
 
 	create_packet(buf, 0, 0, PAYLOAD_LEN, 0);
-	add_ipv6_exthdr(buf, exthdr_pck, IPPROTO_HOPOPTS, ext_data1);
+	add_ipv6_exthdr(buf, exthdr_pck, IPPROTO_DSTOPTS, ext_data1);
 	write_packet(fd, exthdr_pck, total_hdr_len + PAYLOAD_LEN + MIN_EXTHDR_SIZE, daddr);
 
 	create_packet(buf, PAYLOAD_LEN * 1, 0, PAYLOAD_LEN, 0);
-	add_ipv6_exthdr(buf, exthdr_pck, IPPROTO_HOPOPTS, ext_data2);
+	add_ipv6_exthdr(buf, exthdr_pck, IPPROTO_DSTOPTS, ext_data2);
 	write_packet(fd, exthdr_pck, total_hdr_len + PAYLOAD_LEN + MIN_EXTHDR_SIZE, daddr);
 }
 
-- 
2.51.0



