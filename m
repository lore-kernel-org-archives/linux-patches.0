Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060614;
	b=nJCD3fbY6oPQ2Dm8cEgah761IDwMasURXQVaXflLW/WA48O5cpUJNhPkbtdgmtkVyApr
	 XE3jVbkx1i/zzZWY5dJAmuXolh7HeuSgXppat1+bRJRfH8HIVOQnjDRbRCwCCwAcR/P3B
	 OhQFnTxRouHYdSSc16/cd1s0ZfQuli/CJHCh6vLJmTYkvkPHGqzowrT8e8ZbtSX/XUlif
	 ARqrhLOcQ8Sv89keQ/lLfKLeV2ou5erLkq0glAzGq3lwA7eBB2g9G2aKt5br815puA4d9
	 e5U1Nm3I0d3G6TJkXQCHZ2F04vzWADBMAqiOOgcWQwaHrxXQaw5f3dh3wws2C0g56Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAY+gwhaxhKRi7UiyqwL0MmvI6WfNCZO3ppapolx05I=;
	b=bagIDagKtcEYNCgQpONUv46KuFltpwaHBHCOia7Km7NOXSkzyaSfVPSLtvV9xiz6Q9vA
	 OlXTpaB9wR/uoJ8PcqVWRUKDXcZn3FrCVi1yWfOfpA+F6fDxszYS2QJunRERqvE/jt5CH
	 ZfpLZJbo2mbkEcvH4InEd15upFL+hBaSpXgKenubturSYDvwJNzJCzLHi2hzjkPA66PrJ
	 4Gocm7XV0WzbEamxPCfA79/M1jKhJOiZDLAMZ9BYVi3LE3FqlGklp5y73xtjzSxAqSSZL
	 aHQF+yUH/W4Y48lgULfJi95kXR1OcS58Nw2Nbz/Ik1sYlNgSyx6gmrckgyDCxDknzhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bsd5VqwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E54C606A320;
	Thu, 19 Nov 2026 03:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bsd5VqwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B803C1F000C4;
	Thu, 19 Nov 2026 03:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060614;
	bh=qAY+gwhaxhKRi7UiyqwL0MmvI6WfNCZO3ppapolx05I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bsd5VqwGDA+5nE6lfGfc0sk9+3KEhxft0MfxKRvDmTQgaZgNuwBzqfBtadD37mim0
	 PZTYEJR1Ws7G22sk4ttb48o6f61MyUuxCr5cZfOE9b1peSBSi3KxmDn0E3FTr1Ikn0
	 oPHX4KIkpz0FwJHto5iQB6QhOXSvtWcuyzvbvjpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1262/1848] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:55:00 +0100
Message-ID: <20261118150012.540663335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 65a79b9b693d8c7bd7e5e4865c02cce922a7cc50 ]

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less than the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260901083452.115365-3-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index cdf30cfcba139..b1e6746749a50 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -144,7 +144,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0



