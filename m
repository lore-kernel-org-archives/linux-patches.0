Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20E275AFF;
	Fri, 21 Nov 2025 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733075; cv=none; b=DcUANWeVvZjO0qBxNRMxkWXTKGqTp1ktNLW0ejTOZrRbiJlbo3S7R00OfH+/mrJDdUiHoqLmStTT2fJQzuWZMbB5c3uAAJlq8/eFvNihzslA73692nHort7vNNsMaPFnfCpIcKJpBDby85Ci4uHJKkywCnmk5CNZPFOlgH9T6+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733075; c=relaxed/simple;
	bh=N9+o8/sWCR5usArrgI9dIj5eMYrHxhl0YluIIMnRhFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myU6DulGp4M6KRA0kqWBh41rJM6j2JyClV3z+AOf1FCNP/M2Ux6o9sYeoVjR+lxKdGuV6TYT6yZf/AdyPcTadprcGEujLqZjtxtDry5R06XHPIsLIAwDlkmK0FW+QHgIM/yBbsOJuX26kWNuLJvy2kGJAMbHAdz2iobdFMwWEAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0S4YG6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0S4YG6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A95C116C6;
	Fri, 21 Nov 2025 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733075;
	bh=N9+o8/sWCR5usArrgI9dIj5eMYrHxhl0YluIIMnRhFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0S4YG6tUy2TWwx4Ii7suDozcknaS+S3SbY55vr3G1QUjyCAtbwvgoq+wHiSvZOPQ
	 kCOEMepNATh5nyX6sb6Lle0eSE+Fea26g7oZ0nGdlF8HTpXhB7ld5Drcnjm6frO8Qn
	 hNQ3lN5WhH5cvzW6AY4ErAkSOZiEA9VnZ/ORbMFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Anubhav Singh <anubhavsinggh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 341/529] selftests/net: use destination options instead of hop-by-hop
Date: Fri, 21 Nov 2025 14:10:40 +0100
Message-ID: <20251121130243.164337460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9c6f5b4033c37..8dd6857e52cb5 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -623,11 +623,11 @@ static void send_ipv6_exthdr(int fd, struct sockaddr_ll *daddr, char *ext_data1,
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



