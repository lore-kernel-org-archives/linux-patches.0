Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022261;
	b=g6Qhff0rsau9gV++rHWMawHZQFUfRyqa8IabWCSrfXUkIBOdZp1jmB2O2StouHBUpNmx
	 kAnZ6V0OVDqPkl62OuSu66DIzPJqhUpWBhFDqS4JkTt+MMFEiF57VtR/NncjW8V0S3ov5
	 7cesWPeD1Fs1NjuTP5WPkN3j23F+tu+ygPbdBmP6uRjURQpCIZOQ/p8IHmGC10N7Fhexm
	 JMRmggCKumnNSFVVO8gERu6woCEvGlCXl9sgrL54EiAIQY5EcnbqIIH7qYaRy5/wf53bJ
	 Xsd8zEchlrQ+dXx+jYBTIb8DollKNURXj5mlKMspqProvu5pIHaCOgtF0LotJKRf1ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HqzGmmusXBP9WQWmq46c7iDaIT/rOJSJBJm8HhcFIGk=;
	b=lVOet/93bcmsJ0kSqYwcWJ6sGwDI5DHVgHpm15hs3j7FgCIep4broEOaIFJxyhuIkWpY
	 NQdalm5pM+ms7C0Q1JpKiWQ6xc+H4ipOnvlYc6F+9V25uDnCviloCEfmBjCl/PhimkuEI
	 dncmnrax2e4LQ95p3XfkG9YLTSLfhRv9zhsMnaegVGCTgOWQIqSMViTF1uNeyz5wUwmmB
	 8w6J0L4kKk0FWg/oUdlp5D70fhf6Ync02dO7ofiS7Gjqjy+IX4g/uurbFjUoWybhJpTdm
	 ZfJh3S/dTVDUw9tH5rva9EFe9bpzhFghY2J/h/MElgXBd1IT6Yy0J51qD2/4+mE0VXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fA5bSpha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5658B606A320;
	Wed, 18 Nov 2026 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fA5bSpha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08EB1F000C4;
	Wed, 18 Nov 2026 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022261;
	bh=HqzGmmusXBP9WQWmq46c7iDaIT/rOJSJBJm8HhcFIGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA5bSphaqEdrdLUta+ZMYlgZMRTdgHgx8LMJWY71OHWpQWh6M9bgPI0iO45c8GZpB
	 7/WqEjtVcjJtFFLJxZRpb2ak0ztJV+9auYmzVt9yP3FViPAtEJaiefkAyAIb5Ey7ZT
	 iBFHd2a6oNCr56sMNnLVvO3088blZcLvunxbSMnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Nguyen <jamien@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2599/2651] selftests: net: txtimestamp: fix out-of-bounds read in raw UDP checksum
Date: Wed, 18 Nov 2026 16:03:59 +0100
Message-ID: <20261118150417.837938552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 170be192f5c7c..f7bdf30b78d9f 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -418,19 +418,25 @@ static uint16_t get_ip_csum(const uint16_t *start, int num_words,
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
@@ -479,8 +485,7 @@ static void fill_header_udp(void *p, bool is_ipv4)
 	udph->len    = ntohs(sizeof(*udph) + cfg_payload_len);
 	udph->check  = 0;
 
-	udph->check  = get_udp_csum(udph, is_ipv4 ? sizeof(struct in_addr) :
-						    sizeof(struct in6_addr));
+	udph->check  = get_udp_csum(udph, is_ipv4);
 }
 
 static void do_test(int family, unsigned int report_opt)
-- 
2.53.0



