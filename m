Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620490;
	b=r9brO5ozSdgmtR1hzdPyk+7NgqOCwYvM0YcbbWSEkI4ZD8jskw00aJTWWdAsRHOHF38C
	 UOkgb69OyMHvMONJM8Lt+oTkoko3yY2YS5GQaXB45kaItBzcOr/uqQPcfj7K/GrSJaZaK
	 NV2iMafrUdOEUI3iEfvmdv29xI5Nh0pbo5Ps1n6opxn6CGzGJjATtxLoCy75olLSHpkZy
	 7k1RkG+BjMtoeja7bNQlk+4wYpO6SkyOydG9K/GWGfmnC6rrdYoF0l4ZK+qEZTBr/4rWP
	 I77gm+cUXu9YXJmNlWEKYgOmePD8AyStBhvFbCBdJ33mv5lA+mxxpfxKOzIdX46F/rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qlrq58GwV82g5cemfg2T3dteuxJCuXky3rpNz7Rcu/U=;
	b=GeDJmFPUDvhevvz2EhBcCmgXae+cLLqUpJwB1M8zMFpGbQZy2BJT5yc3VEHSj3wgdkLK
	 MjwaIxBggbRDhApYJTTJh8UiJvsYBMmoj4rsD59I4wcjXuHb8OUuFkAmHdsCrTBf49nCe
	 Kf4XvrTpqTAWyJEuFcWtMgy5Cboxm7slbvdFJfxF1oF06ZR1dAmELLrc9Rjzxum3cS3Vv
	 3bW2G+btaZT9AQthNWX0EvTi2rY3AeMlsubNs8K34oKKNIQpo4GgEc/dvPDip1IzL0FgO
	 EX9RdMZfL0qLek9AY7Kxip52Cw8wVzbSLmFZLCbAHgEfLx4023XzUpgjfg2k+pqtlIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmIdsB1Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C22606A323;
	Wed, 25 Nov 2026 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmIdsB1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D721F000D1;
	Wed, 25 Nov 2026 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620490;
	bh=Qlrq58GwV82g5cemfg2T3dteuxJCuXky3rpNz7Rcu/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmIdsB1QcvpCVjJjVnL+1kVZRncKcKC95L31Dl9HrNWUUqQQOoWbHITMJo4W28CVN
	 AagaVz6OfvL2VtzG5WpqnhnE25wdvkkEjyfAwFSDJwVJ1QxwYIt4dOYTVhoOMGxTCT
	 rBTp21KFVHGnVyQ+rGIv7oAbtKlFXvgY40X9Q8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 7.3 0890/1005] comedi: ni_tio: Fix overflow of the clock period
Date: Wed, 25 Nov 2026 15:37:08 +0100
Message-ID: <20261125143842.545682850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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


