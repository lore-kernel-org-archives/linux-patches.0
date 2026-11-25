Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625766;
	b=gQqqKJY3rOrEul7NU9AX9dJieA7NV0U2QJHExOrFd7iM4kYbIA+KRlA3eZ/24zOJsi2r
	 xggwb173HmQ4HsF47WUa1vmVaXCzdyAl7EE3j0p/F1vswJlEZb9RMLW5CFR2Qz4BE6B5O
	 XKnBvGnCaWwNwUTKbwwwEb71MtZ3TK2KBE43Ogfe2ZsBInUQVK/JbUIk+sxr+Uiy9wU59
	 FEMW0kr4izVqmS1h1bwt5drDUZBaGh/tr+gDXI4Pf+Xhk5ZRTlNE0l5Ol4Mlq+B63Xk8w
	 NGrNP0sZeTmtnq9Di0xG52N3x1uIRumsNdOUcZHQG3aTjZCAXL4ulO6jYVDcZHtFbVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTS5SAKKhTCUGRvouHMQj6x5xQ1sIdOWhI2Ijn5kWlc=;
	b=eyJ7WMXWIF8Z2F2Ds5R7vNHapM7WlAAyXm7z+tL6xa9hOjFZjR2+Q9l4U3CfklADnopY
	 dTk1KnSwjYo13hLR1RkzFvF7m+uUJ7VOfmkGP+qRhsQb5YQAnrDyiqCx52IXVSM9iU8CY
	 6ewJHiJPUo0oVXiNFBV+4LpZku6B2hcSEyOi+Dzxmplmhl3N/Y1j8mz3DAqyGUoAaddIX
	 b/cQuK4YVPQLsDURrkRq/1iNwMcvn+w/hp/wWlLdOdADPnm8NRaMeY1QDfrSQe3wCBkp3
	 UYgK6+7o6PWJ1Doxzs7FeiFz65CDQccI3slHJZ5Fo9jIpN6U9WIbT4exAKC7grZT/3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4GCmfEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BEB606A321;
	Wed, 25 Nov 2026 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4GCmfEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564CE1F000C0;
	Wed, 25 Nov 2026 16:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625765;
	bh=ZTS5SAKKhTCUGRvouHMQj6x5xQ1sIdOWhI2Ijn5kWlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4GCmfEQ0DnNXDXu7xWoS1fVIeMnKJ4kvolXPciO5JZXiIFh+3z5+OGNFMhvbCPEf
	 z5gkY34ZQa+KnCK2Hqxgh+UYe/s/OTWxDf/i0yA+LKX7raMLAQiYRVQastdHOxRN/a
	 uKSUDVpOMMjIOV9e5iLuMBdI6Vsn37UAgnKSIXvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.12 626/816] timekeeping: Read getboottime64() offsets under the sequence counter
Date: Wed, 25 Nov 2026 15:36:14 +0100
Message-ID: <20261125143903.674431043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit 385b5ec1f31dd39297578eed42be74b07ae74017 upstream.

getboottime64() computes the wall-clock boot timestamp from offs_real
minus offs_boot without checking tk_core.seq. A concurrent timekeeping
update can leave the reader with an inconsistent pair of offsets or,
on 32-bit systems, a torn 64-bit offset, producing an incorrect boot
timestamp.

Read both offsets under tk_core.seq and retry if an update overlaps
the sample. Convert the resulting local value to a timespec64 afterward.

Fixes: 7c3f1a573237 ("Introduce boot based time")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030054227.35453-2-dennylin0707@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2296,7 +2296,13 @@ void update_wall_time(void)
 void getboottime64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);
+	unsigned int seq;
+	ktime_t t;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		t = ktime_sub(tk->offs_real, tk->offs_boot);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	*ts = ktime_to_timespec64(t);
 }


