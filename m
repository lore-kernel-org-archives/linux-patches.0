Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055218;
	b=z1vd/U6xYQ0Q1Sw6YlJPxsPUTTvCp0TTtN7LFCljdUAoef7g5dyaRGLWwrrCOX0qRLbk
	 P3xv6K8+8gH3LABDpSDoqAmcnawW12S8khQnAsjMki1DTCUrvLy8dWRS6pnw6pzEoOIC2
	 4w+bdQft0d3mkv3lNve3fq4SXjyNCfr08M+nav5u6al/C/RlqQWoCRoU59MLNT0BquAc0
	 DwZsRKqTw7rj4oGzmQ9ZnpdEFo88eORueg4FLNHVKqX6oQBe327OuKTA7LZqRLtEUAIBp
	 6xnFqAZ+nlvlApCt0PKmxBvvdKdNik60LnRDlftC7Jw8hxzPeu72MKAwBq4FYTLQjRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MkD3hxaTrO8loRtCdzGhJGqTCCrjVy7qYqC9+Iy6GYo=;
	b=N4zIRU2d4gM4ctO2IOUJLOKOSgMBWPhnnQPEYaquj616L34vsUfdXPR7GnLzTjDnrdoZ
	 BXjsmN7ZPugg6VftlS2ffu/dhqrQQ39yL2DjCjuvZBd9k+fBE7WxMULYo8Otxp14l6Etk
	 4t//9yMv6iiRUS+/UK1Ujy6L9H0EIsmexy85OQPFnlBHh/SN8rAo1hv/DtBPEepLBVWf1
	 Q744ub9fZhNc4hMlnK35DKow3eJ2DNaOAW/oGxH2GwZNArjSNiOM7fCvEHf7CN9dVd9Vz
	 71URL6/t51zMt8itwBQDUZISpT21E3VrZxM0KRv/Scn9hB7I7Nes2iVdXnTo2MrvN8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opoLi92D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB603606A32A;
	Thu, 19 Nov 2026 02:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opoLi92D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3169A1F000C4;
	Thu, 19 Nov 2026 02:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055218;
	bh=MkD3hxaTrO8loRtCdzGhJGqTCCrjVy7qYqC9+Iy6GYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opoLi92DEtIvyfTslGIm8Lw5UD9TMlE2IAM+v6VUpK2EOTTv/Leqp5w2rAkg48DOK
	 ZI/QTEOqlXInFp/OlwW0WWqlgRnKpAaiXgsRMS03oOAVgGCsWCDk8y2Ugtqh3y328A
	 IfrPR9I94hcwoRDdE+ZHyaBfwEuJdk8flQhnwJUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1512/2214] mm/gup_test: safely calculate GUP batch size
Date: Wed, 18 Nov 2026 15:53:08 +0100
Message-ID: <20261118150112.499841878@linuxfoundation.org>
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

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 44817a536aaa5bfac0d316242e93e489d0a69d5f ]

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.
If it wraps, the next > end check is bypassed and a large value
of nr is passed to the GUP call, even though the pages array was
allocated according to gup->size. This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages. The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and
the pages remaining in the address range. Reject zero sized and non
page aligned gup->size values and zero nr_pages_per_call value.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260915102524.125758-1-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 15074dc772468..081440cee3245 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -107,7 +107,8 @@ static int __gup_test_ioctl(unsigned int cmd,
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -130,11 +131,9 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
-- 
2.53.0



