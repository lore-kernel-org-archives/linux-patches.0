Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048426;
	b=0SurPv4TyTgo/Q8CfKBZluE/uuGqCIOJd0BK5eSXFHEKu2G/xdRBcqKZZQZrCRDQviNl
	 U29wTjnpDqLNoesqag3Su6/bkBiX7HEsPUzBSk4JSNQGrBdLZ2aQpQryOvQ2sbBrIWu/L
	 8mFJW8AnGqrk16IpaoAsqzxCGCRrkPf5pwVYuSya6/9lfSvG6kkXpJ2C58x/XI75D4yA2
	 OegMLrJiPh1C6/r3DxiyhgUkZWwDIWLviea6JdApiHel5nmpMUsrRYYG1wXLVPm17uDg9
	 twRUZA91369bhWKA2hzL3/RC7HTQcJSnktA+F/uP4uhNrY7+3iv5X+35bgE8afA6UKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9peeLJvhkdUZgyNf1ehKTs080DyRzGKiOR1Rv9fkN8g=;
	b=nZERh+Cef3kcYVLk+IQpxc3Rx9nOAgXPtyAXlrQgTXf+I8ZG9sGmKb3tOjpEpEZhfaEY
	 6kBhH6h4TYU/8Gv+4E/71Lmc8vofF2VzysPTbhwMC/fK61ZoPEOZGLF7Dbt2sBLsBj9RX
	 PwPOryPrh0KYvq+DEgCiCWb0n4xtrr0sSsc7a3VDoDrreXPdg/QW4QvKNY98RtVj2OMyA
	 H8UqtqlNYKqMTbsHLkWt1JnAukUEflqFuzwbUFdsdRtmaLw+LVenomklv3PddvWgSolXH
	 r8jva4pWrBoyrC5mBL7UkiZV89wOZD8FP4ZfeJVolAHgvox2zN68SA10jXF9NWiu2HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yKdPU/h8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC19606A325;
	Thu, 19 Nov 2026 00:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yKdPU/h8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2241F000C4;
	Thu, 19 Nov 2026 00:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048425;
	bh=9peeLJvhkdUZgyNf1ehKTs080DyRzGKiOR1Rv9fkN8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKdPU/h8kSQWllELkW2l4xo8NeLuc5RzPY7YkC1Q6glFPuqA5Q70O1JSs+NepXqSY
	 egCiTdTe9w/aQXWNsyrYrmRYZv87mh2g2rHioWnvMhcagQZsylYhvlLm+R/g42z6AA
	 9EBhkFwtkYsyqj2a/W+SO63lsvO+Sgp9woss66bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1949/2857] mm/gup_test: safely calculate GUP batch size
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118150311.588109515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2a8082ae55d68..4ea1dfa371da2 100644
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



