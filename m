Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590090;
	b=rrvawz4C/Ys3BqDxw+vuoTkzJR0SKYhqdVlxw9ZizGn01jWpc8te/nHkli8wcSNG+K19
	 e0YQYgdzM0+ZhO7xdgHBgAWKC8Wro1YkdNdXkDYJIgjQzwa3WZ1Np0tb4eJV0vdQWVyZU
	 0/JSAI0qEuHSDAu91OXdOrK4b9y8O9zr5OLcBFYX5a0u9xHZ0ttzJQMu+FN7cNZUqEo/m
	 d9YGIQLX+rDbf+DHPCfZ+7dk/WjKbHy70HRc/TXXtrpSgi+rOI9WhUwvffSscvd5rgx/U
	 0+/9Sa/Sazv1CviM1LMJSapJ4S9f7TOkvowhcCTnooOG5u86wnoR4CsItzHQOFg+8ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0Q3RjBaOx7CNLOI3Vtfi92b+JHM2vSaLhAGdRBAnvg=;
	b=nUgqSbskK20DaBShordnOFG1ZFv/kJf2bxsHfX5Q4pPdMhnauLMIZZIQap8H3YWUflXe
	 +dCwjWnGc6qNRLIv9z0t/wHnyAcIRvZ0ACKcYCb9gbsQGUz1MKQC/6SXPZ1WIwG6Bj0YM
	 C0NEtUhq4ly01PEreoHiJJ1XJxlSkHRw50gT4k3/LvfQTHJggZYDvsAeGZjf4KiTp3cND
	 mgkH62IfQWNZ69JtYsxivAyzCjmMVPmUKtfxaQKB0xWFVOHar/jF2R2B5sGYOS3kwTzHF
	 xto1Syl2EftVA09glxYG2rpIW0RyOLYbFwY+g1yyrviPGDOtUVyHuAXqD9+IYTkm/Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M15ZEesA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D8B606A8BF;
	Fri, 13 Nov 2026 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M15ZEesA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742551F000C4;
	Fri, 13 Nov 2026 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590090;
	bh=O0Q3RjBaOx7CNLOI3Vtfi92b+JHM2vSaLhAGdRBAnvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M15ZEesATL/8a3wAbFlKNF/kxNrmGM+kSljrJ6XmX1kBsgrwgqJT0LEwLue9FNe+M
	 aWgHEnSfYoPfxm0nT10B6m/8sc1jqsnYjn6dGmpXWvLPzHAg9NcBwrdoYWIWJyoBIA
	 brNHMQoxk0B471WIHCG+9q7ChO+DM8DA84AWhmgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/686] ax25: dont copy an uninitialised address to recvmsg()s caller
Date: Fri, 13 Nov 2026 10:44:10 -0500
Message-ID: <20261113153824.801903833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When the caller asks for the sender's address, ax25_recvmsg() parses
the AX.25 header behind the mac header of the frame and copies out the
source and the digipeaters, without checking whether ax25_addr_parse()
succeeded. ax25_addr_parse() fills neither src nor digi when the header
is shorter than 14 bytes.

That is always the case for a message that ax25_rx_fragment() put back
together: the new skb has no address header and no mac header, so
skb->data - mac - 1 is negative. ax25_recvmsg() then copies an
uninitialised src, sets sax25_ndigis from an uninitialised digi.ndigi,
and copies that many entries of digi.calls[] into fsa_digipeater[],
reading past digi and writing past the caller's sockaddr_storage on the
kernel stack. Any AX.25 peer can send segmented I frames (PID 0x08) to
a SOCK_SEQPACKET socket whose owner reads them with recvfrom() or
recvmsg() and an address.

Only use the parsed address when there is a mac header and
ax25_addr_parse() succeeds, and give an empty AX.25 address otherwise.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link, PID 0x55, paclen 64 on the sender): B connects to
A and sends 20 bytes, then 200 bytes that go as fragments; A reads both
with recvfrom() and an address. ax25 built with
-ftrivial-auto-var-init=pattern, as with CONFIG_INIT_STACK_ALL_PATTERN:

  before: 20 bytes from TESTB-1, then
          BUG: KASAN: stack-out-of-bounds in ax25_recvmsg
          stack-protector: Kernel stack is corrupted in: __sys_recvfrom
  after:  20 bytes from TESTB-1, then 200 bytes with an empty address,
          no KASAN report, five runs out of five

Built with the zero init used by most distribution kernels, the stack
held 0 there and the second address already came back empty.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit c87b940367ffe7952863d717797e156d3dbb57f0)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 4c5f82e2593c7..64a24543d7f42 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1803,25 +1803,36 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (msg->msg_name) {
 		ax25_digi digi;
 		ax25_address src;
-		const unsigned char *mac = skb_mac_header(skb);
+		const unsigned char *mac;
 		DECLARE_SOCKADDR(struct sockaddr_ax25 *, sax, msg->msg_name);
 
 		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
-		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
-				&digi, NULL, NULL);
 		sax->sax25_family = AF_AX25;
-		/* We set this correctly, even though we may not let the
-		   application know the digi calls further down (because it
-		   did NOT ask to know them).  This could get political... **/
-		sax->sax25_ndigis = digi.ndigi;
-		sax->sax25_call   = src;
-
-		if (sax->sax25_ndigis != 0) {
-			int ct;
-			struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)sax;
-
-			for (ct = 0; ct < digi.ndigi; ct++)
-				fsa->fsa_digipeater[ct] = digi.calls[ct];
+
+		/*
+		 * A frame put together from fragments by ax25_rx_fragment()
+		 * has no address header left, and no mac header: give no
+		 * address then. ax25_addr_parse() fills neither src nor digi
+		 * when it fails.
+		 */
+		mac = skb_mac_header_was_set(skb) ? skb_mac_header(skb) : NULL;
+		if (mac && ax25_addr_parse(mac + 1, skb->data - mac - 1, &src,
+					   NULL, &digi, NULL, NULL)) {
+			/*
+			 * We set this correctly, even though we may not let the
+			 * application know the digi calls further down (because
+			 * it did NOT ask to know them). This could get political...
+			 */
+			sax->sax25_ndigis = digi.ndigi;
+			sax->sax25_call   = src;
+
+			if (sax->sax25_ndigis != 0) {
+				int ct;
+				struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)sax;
+
+				for (ct = 0; ct < digi.ndigi; ct++)
+					fsa->fsa_digipeater[ct] = digi.calls[ct];
+			}
 		}
 		msg->msg_namelen = sizeof(struct full_sockaddr_ax25);
 	}
-- 
2.53.0



