Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626073;
	b=Vs71LKPqRdRtr5HoCvlchyyWi/GGAF4sIeNvwPk6MSRK1SgSkVOv8IVYPcfEDxtpihoN
	 Z9z1l7+NIG1JDz5VOboG9/mc7IElKM6RkaaxLSNBsmuUYeqQWRoaqovV+fDN6y3AUxVq8
	 A45/z/5MvvLe8u25ddj9jqZsgVR677jOXnGaoWmvsNdxzhf5XwImMgp8qwev/ym2WbZVX
	 wsYcba7+4n4WWxeJyH+5aCNHF/L2WbKag5WSIs+EkK0Q7FmKzJpl8qxuXSXjKq2neLI+n
	 AL7FuQWgQZkIQkOTJ3C70wTl+MWj8EwGqmEWEVetkp88VPBi3uPAKKfEjegRc42vmpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mZJJEF0U0v+FrNTlfH+9iCHROkqGvxoWzJxNO0//vvM=;
	b=GrRWVKxRiyUWyHbaPaawMb/QEOSk2T9LrTnZHDxD9J5Wp+bnM3g4SBt4D4uQauS7Vt8R
	 sL1cbntY80Dkpd3t3lze57tyqHmo1lXyF+g/xisgHeCrLy7aIe8AThoIRw7ZfMXzikTn4
	 p9xfHiTKSuwK+K8XzZdjLPwp4HZw7JyuuowzjORLMzHWlVCeVUhGqx6XoF6lVByYCboUb
	 Eo9KQCieh1Vag7cqSjK86KWaCgh29jOgjZUihDT6Puq0CsEo2FmPVGka8+tMRi7mSSE2q
	 PJKmyL2OJvmBW//uICK0MB1nNNHimie+VkOQ+Cbly5YnmoC7wYxCUqME31Pdjyltw4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dywq2rzx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BEC606A321;
	Wed, 25 Nov 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dywq2rzx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28891F000C4;
	Wed, 25 Nov 2026 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626073;
	bh=mZJJEF0U0v+FrNTlfH+9iCHROkqGvxoWzJxNO0//vvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dywq2rzx3kkrJTHPw3i8R5IYlhrzoeTEKLbJg2gGN8sCw/QJfjUwGo6Y9sfDxNUPJ
	 +JVZVaBJ+U9no/T/VH7GVsfBSs/XrvGmzT4uj/A/rmcT+QxTqczSjLzogj3W5TATmP
	 Q3IQwFxR96w7q7zTDAGW7vzl29TSkrQ8x26pZ42g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 723/816] comedi: ni_tio: Fix overflow of the clock period
Date: Wed, 25 Nov 2026 15:37:51 +0100
Message-ID: <20261125143905.913381181@linuxfoundation.org>
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


