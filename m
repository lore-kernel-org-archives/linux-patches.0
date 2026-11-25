Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623652;
	b=1lppXLaD5QOced/H7gQjfYdxpThA7OAtdMgcXB/KS0KEjX2AGt3xzGR2xJnE3lLVIs94
	 VWElrFI2Q0ztBYyTFNZAtL/e2T2Gi4Dbz/jZ5tCw8weJTHyJLnXXFfmGB9g2gEtgupGDG
	 xNI/YUAjQOJ3MC7uedgGouwhdLcbJZyaPnVIq8sQ9d1HhG47+6pF9I4lcqvVLwAtRYCfq
	 G/mU5hY9qqe7LhYF7JfTAkHv0r7UVkBjPBQWWAsSwWBPqcEAoIicpq6+4EuIjE6HDPCgn
	 vXiaqXO7I6Bx6rKgHA7H0Cz2hqRudo1sMXoi7dQ9+cRs0wA+NyXk5FQ1Rs2WVMN58dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzIxH1iS0003UstU7wsHNQj0O29Q1Eo/oL/ACvr8owY=;
	b=MhRvmIEbMV3/uTlnXn58dYURom2auW5HBAZNmdy2GFoQu/dEpFh04kTmZX8T5W7Z9dPc
	 2N4t3E6e2Y0CTHTLtJCYJH3/C5vdulyLyA7WveJc3NeUq0DY6KET86ptdjKRzdKGfR9te
	 3lJVpclNGFLzehw6wrkhzkldGnT5iPqb2uP6E+qhowPo2s2TRGVey3tHA24BprII/1wEf
	 t0OEfcRAgJXGQyCVpS8lTDayyLhjAqKdnI6RX2PZuyKgA+jZwWMzRrzi30JvnDxMMNSVH
	 0JZw5XLr1RviJufzhvOu+q53BlarZMrGBP2tWWjdl6Huk1A7lXSXgSTeve+VXneZYzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sg1CRXDu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4C3606A321;
	Wed, 25 Nov 2026 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sg1CRXDu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8641F000E0;
	Wed, 25 Nov 2026 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623651;
	bh=fzIxH1iS0003UstU7wsHNQj0O29Q1Eo/oL/ACvr8owY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sg1CRXDuVaWBZwPDzPtmZVTkR9nme+xfjKhDzpBKy1+IDFbd8BDKmATlAtcfWH4qS
	 R4NF6pj84WrmOgiFaTMEK0NQZoc/b1r4CLOsEQt4OLKolrWJrRJUtvCrdH3eoMsDm3
	 ECK/xqfexJKUa1yY0OwdQCe8ypFEgqVdKBJbySNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.18 884/990] comedi: ni_tio: Fix overflow of the clock period
Date: Wed, 25 Nov 2026 15:37:31 +0100
Message-ID: <20261125143842.721225379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


