Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056994;
	b=pbiFUcNjBmVffl6s9aYnrDXcYy7vQyXXErafR5CRGFCWe7z/jjOzLTP2jzFrSMVT265d
	 lXrgZUAbdIIe4t8kJZ1GyKpzSMkIZGavqHqStIdn8H5HwbZ2A78eAz9SOTsR5C0e9p9Su
	 ydDwNSn/+/ixMr5W2+TuWWc5wSUfFYnhXx0EydIRY8uHQ8KljJDSQIfoVcI1bpfByxD01
	 D+Jk1uNfA1UtrTksoaaWkFIyuFkTthbNT2CU+5fgy0Kk/epHTvE2luDunecMZSthqFa23
	 p5s/UFajr1JrnTxzWRMotgiiAhTbF6GAsugwWymp0CpC68yNWOJ9DpA3tD4/rHDuRHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtTRFK/g911DcDpSif5F/PWkjKYqjf8si0bNSSBnTg0=;
	b=kuedS3d4EoybGp4JvfNLRVLBvJA9R2TIMoH9kGpus92tabNyjwM5iPL+ygf2bB1G1LvY
	 Zij5AZwetPxCE+IiZxFAFIQPdnpfavF78NB1kZnLpLtl2tpD17y7ryLceSsATLhGlk8lQ
	 19OEqYhMo7M22sL8SP4WN60wsx1haqJ/1z+uO+8aMq5WB5hY4hxAYSNj7x8RY3JiiI+r2
	 XNDXoN3TvpyOn0pccfCFX/eEZAE1zR+SgxjOtmlDfHlikVVs/sNRoxnfX5gpCEVSxHpXr
	 4LK9Z/IrG6tSSCzIZUgcH0/A9RxQQlkgpAOtzPVt4ntJNvIbSjOWs+nqDDafFTjuoww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9MfQCKa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B37606A325;
	Thu, 19 Nov 2026 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9MfQCKa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016C81F000C4;
	Thu, 19 Nov 2026 02:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056994;
	bh=dtTRFK/g911DcDpSif5F/PWkjKYqjf8si0bNSSBnTg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9MfQCKap4V0pdYN4ASOORfjorUEkg/OfPc4qWIX5swiGHr6UQUEsBqKutaBzkaT8
	 uBE3WcjQJAJ4UlIjsADvuIJR3eAVsD2Efm9dZELTtxBDQdomUQdCiQIQURbV7gnkqO
	 HxcwebctqI8QXQpkzWl7CzN4ALABnMYSsYMIbB98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Nguyen <jamien@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2186/2214] selftests: net: txtimestamp: fix out-of-bounds read in raw UDP checksum
Date: Wed, 18 Nov 2026 16:04:22 +0100
Message-ID: <20261118150137.792066724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Nguyen <jamien@nvidia.com>

[ Upstream commit 8daacee78b3d2798fcf92398b6dff364eab64466 ]

With -r (SOCK_RAW, IPPROTO_UDP) the test writes only the UDP header and
payload, and the kernel adds the IP header. get_udp_csum() still expects
the IP source and destination addresses to directly precede the UDP
header, and reads 2 * alen bytes before the start of the buffer: 8 bytes
for IPv4, 32 bytes for IPv6.

ASan reports a heap-buffer-overflow for both -4 -r and -6 -r. Without
ASan the read usually goes unnoticed, but it faults when the buffer is
the first chunk in the heap. That happens on Ubuntu 26.04, where the
kselftest runner wraps the test in uutils stdbuf, and txtimestamp.sh
fails with SIGSEGV on every run.

Even without a crash, -r packets were sent with a checksum computed
over unrelated heap memory, so their UDP checksum was invalid.

Build the pseudo-header from the destination address and checksum only
the UDP header and payload. -R and -P already write daddr as both the
source and destination address, so their checksums are unchanged. With
-r the kernel selects the source address, which equals daddr for the
loopback addresses used by txtimestamp.sh.

Fixes: b52354aa068e ("selftests: expand txtimestamp with ipv6 dgram + raw and pf_packet")
Signed-off-by: Jamie Nguyen <jamien@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261027162945.2122306-1-jamien@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/txtimestamp.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index fabb1d555ee5c..769905173b715 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -412,19 +412,25 @@ static uint16_t get_ip_csum(const uint16_t *start, int num_words,
 	return ~sum;
 }
 
-static uint16_t get_udp_csum(const struct udphdr *udph, int alen)
+static uint16_t get_udp_csum(const struct udphdr *udph, bool is_ipv4)
 {
-	unsigned long pseudo_sum, csum_len;
-	const void *csum_start = udph;
+	const void *addr = is_ipv4 ? (void *)&daddr.sin_addr : &daddr6.sin6_addr;
+	int alen = is_ipv4 ? sizeof(struct in_addr) : sizeof(struct in6_addr);
+	uint16_t addr16[sizeof(struct in6_addr) / sizeof(uint16_t)];
+	unsigned long pseudo_sum;
+	int i;
 
 	pseudo_sum = htons(IPPROTO_UDP);
 	pseudo_sum += udph->len;
 
-	/* checksum ip(v6) addresses + udp header + payload */
-	csum_start -= alen * 2;
-	csum_len = ntohs(udph->len) + alen * 2;
+	/* pseudo-header source and destination: both are daddr */
+	memcpy(addr16, addr, alen);
+	for (i = 0; i < alen / 2; i++)
+		pseudo_sum += 2 * addr16[i];
 
-	return get_ip_csum(csum_start, csum_len >> 1, pseudo_sum);
+	/* checksum udp header + payload */
+	return get_ip_csum((const uint16_t *)udph, ntohs(udph->len) >> 1,
+			   pseudo_sum);
 }
 
 static int fill_header_ipv4(void *p)
@@ -473,8 +479,7 @@ static void fill_header_udp(void *p, bool is_ipv4)
 	udph->len    = ntohs(sizeof(*udph) + cfg_payload_len);
 	udph->check  = 0;
 
-	udph->check  = get_udp_csum(udph, is_ipv4 ? sizeof(struct in_addr) :
-						    sizeof(struct in6_addr));
+	udph->check  = get_udp_csum(udph, is_ipv4);
 }
 
 static void do_test(int family, unsigned int report_opt)
-- 
2.53.0



