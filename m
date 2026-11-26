Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705632;
	b=zmfwVer7e+archJiwtdig4CTGnUDuo1a1yhMeRaH1P1P9M8HJLqMLbjBdJTVaEOap8LY
	 9thQNEM+ZapqF9Pc38oL09l5FPv99QQzj8Kx6WGdgRS2Cn4hNndvEUhqXtvYU9UgdzdK7
	 4igpr/Lh2F2xodgY9Ao7v26/f+Y677RVXXvY8s8O0g4C73RbOnyyyaIEg0mDFOkny3iLu
	 IBdr200/1iOD+HGG4tlg0vxv2kIwqWngE8Hc0NEKEgqbAc9Tmo926C3dJnrrkNNLPCvbx
	 NBDQWbCZArabnCKhPvw6m6dSZxipsmDZfZj01pmAXwiuNMqmtR8c+3g3MCq53QRevLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcH/FPXJdH9bHMaOKkNcMuNua/c9Ow/A7G32jSTJvrc=;
	b=R4ca55PXgjqPE+124CKm6xIR1ayq0wO7yPp+7bjDKjjqlO7ZY1Q/A1U0hQQ+TDPvt4co
	 rtxGezOV9rQCzvdjso2f7QQdths5zE6o6pR1DDcLPvwJePCRLK+7lXJKrOfZXJC6RQw2U
	 jUeUPfLB9Ef82Ha8W/y4zlH5J58lnpccS6qArt9oET74MB9aQO1KRoCY7EQ0x4sXbOLBf
	 sg//7pZKr2nazi4jOXn0Enc1QdPDGmyKPkCBmjXsGY0lbnf+bwOYQ0pxpircvoPFSYlKq
	 SwEZFpZto66gKWCA+lBK/ydi5Jb9ce2gNU6G0ZKFnLU8J0SJzvBRUyTvss9r4g8d/uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzF9KsWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099DB606A326;
	Thu, 26 Nov 2026 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzF9KsWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDEF1F000C6;
	Thu, 26 Nov 2026 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705631;
	bh=fcH/FPXJdH9bHMaOKkNcMuNua/c9Ow/A7G32jSTJvrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzF9KsWxBEXHuwX36MCXduiHaqTIefJA2R3rUbmY17U/0DWBp2Puen7wPJw6+CVVf
	 H2mdzQma2vrP2x3wTZ8g8f+bRuImBSz3JpoZc+HRWaKQwCtu/6pFd5C1kJC31pmKRR
	 h2qHMXKomb355MBVqcEWmbqG30NPqLDoCKoZPk/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 261/319] comedi: ni_tio: Fix overflow of the clock period
Date: Thu, 26 Nov 2026 15:40:29 +0100
Message-ID: <20261126144012.638075140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit ec214735bb113be747454812035b83010892e0d2 upstream.

ni_tio_set_clock_src() stores the period of the clock source, which the
user passes in nanoseconds, in picoseconds:

	counter->clock_period_ps = period_ns * 1000;

period_ns is an unsigned int, so that the product is computed in 32
bits, although clock_period_ps is a u64. It wraps for periods above
4294967 ns, that is for external clocks slower than 233 Hz.
INSN_CONFIG_GET_CLOCK_SRC then reports a wrong period, and
ni_tio_set_sync_mode() decides on a wrong one: 4294968 ns become 704 ps,
which is below the limit of 25 ns under which the alternate
synchronization mode for fast clocks is switched on.

The multiplication was done in 64 bits until the constant
pico_per_nano, a uint64_t, was replaced by a literal. Widen again.

Fixes: 3e90b1c7ebe9 ("staging: comedi: ni_tio: tidy up ni_tio_set_clock_src() and helpers")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20261027-llm-char-misc-comedi-v1-4-1899771ee15b@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/ni_tio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/drivers/ni_tio.c
+++ b/drivers/comedi/drivers/ni_tio.c
@@ -800,7 +800,7 @@ static int ni_tio_set_clock_src(struct n
 				GI_PRESCALE_X2(counter_dev->variant) |
 				GI_PRESCALE_X8(counter_dev->variant), bits);
 	}
-	counter->clock_period_ps = period_ns * 1000;
+	counter->clock_period_ps = (u64)period_ns * 1000;
 	ni_tio_set_sync_mode(counter);
 	return 0;
 }


