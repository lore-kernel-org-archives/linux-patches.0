Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29BD2FFFA4;
	Tue, 11 Nov 2025 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825448; cv=none; b=Nxto8qdV7qyg3UVsJyvIZ1JPqKL4d8XHgbXshsNCmMYIVWJkr+aiigjkOqtr+3dV3E9dl/lMPUrSBfLgEZeO26Wxh+yrdonh2uoX2BRW6OlZAjX3AyZNWC6kfguuKLwyScOAl9nxlBFBZQ88z0FVxrj+nTIZFu8dWxJ0n+gotM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825448; c=relaxed/simple;
	bh=3/Mh0/ux34dFGZLycF2JavitfsrhmNWCnAxcrtEZf/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swQ0rhdlAxE2mbS4l7gHPBF6Lg8m7xyfT9Q+WpVbri7y38qMBOozQa4LnerdpP1Mt08rk+ZtOq+34TjjCcyp4aRdkBtxpNIFXx/NKGbSnOE6uCB4AU5hGrApJQHHR3q1F9Za1BIbpXCkZtiL2a/c7NgOg/ggeLYP6EjS84wKyes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyVeomO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyVeomO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C430C116B1;
	Tue, 11 Nov 2025 01:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825447;
	bh=3/Mh0/ux34dFGZLycF2JavitfsrhmNWCnAxcrtEZf/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyVeomO1nI+ed3bqvB9IY0+owLYhvsvgvNR/MiCjZ1foNL8c2tbLYGqgOer/ELf/F
	 eRlHT+JgB433WBVYIB+SOsywUmaHtC3ayB9J5Yodmc+N6NYfUMy3b7xa4SqX2tQbc4
	 8XYiDkpVWegUEAYFPCFwGQ035yk/P9iaITnsw0DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Anubhav Singh <anubhavsinggh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 762/849] selftests/net: use destination options instead of hop-by-hop
Date: Tue, 11 Nov 2025 09:45:32 +0900
Message-ID: <20251111004554.855904900@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 209ec60052f5b..48755b8475a4b 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -734,11 +734,11 @@ static void send_ipv6_exthdr(int fd, struct sockaddr_ll *daddr, char *ext_data1,
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



