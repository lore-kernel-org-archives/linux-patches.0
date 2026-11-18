Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055221;
	b=1C72tBBOUz0d/75TTm3LwkMaxg4E4ZGh+eF7DzBUGRGcAOlHO82k15zpbgScJ0xYJ7tD
	 DBNyrQIkXh4R1IXP/R0r7kYJa/sIIdH7azKDxQpRYsKsq+/6udPiWy7ROX/R0PFubi8iN
	 X14RaN8nVonAT1wgM6uVZuhVgoo/Ti+vZWEuJ2R2TAInejPKwHen1mrt06NTOsj9Kr44j
	 AUWPgivRe5VF1SI0GPcOs+Db8RMnr1wBhI6Gwzpiii7Eb9a4aYqZ1/xu6lmDVegEI55bC
	 vUL/k7JcZFQAiyz/IhNHFQs0kfRDTUEDwpeexmTaEEv1ylra661covDl1wCtW556wQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=reNuJPcFewJdGwgtXtbmWtO5gPPoNKrkKx6NZeH6T30=;
	b=d/DeqMIy6/geICudP8HtBigSMq3dyQmQmLHs817LEZuJ55Cfgles17TrpBSr+083JBMu
	 6PznbpAfr4MVi6ChWJ/Biukb5U14LD488fTAbG82aFqmSuWLDxWjOrjmf6EUwTBkPeC8F
	 ZqpKtrZIXIwPKGa7Ddo+FtR+D9SigRWBLxq/l7YTjwOtQd7vqIdc3s/eTYgmfhVBh8eb2
	 HG9RzE92z9xXIQzxul2GvuREZeUxI21YFP9/DxCGplqra6GF1R8LUUFiLgP1LCi2kSmzB
	 BOB3kQFItIUoiEneXQOhHe6Frm7LYmGh0WOdHMYX/ipYzPClGvl8FGBIkACJfONXL5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1n8haPPR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C6606A325;
	Thu, 19 Nov 2026 02:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1n8haPPR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDC01F000C4;
	Thu, 19 Nov 2026 02:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055221;
	bh=reNuJPcFewJdGwgtXtbmWtO5gPPoNKrkKx6NZeH6T30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1n8haPPROc5rTUqjF8ktMTMgIMbfBNccBzlaX3ukAxh5ZdfdMNJQpRGVhZ6Kmrsj1
	 NLQFWlPJc21o01j8FPCMFwH+4Iac5c/UnfA+z0w8PYLpl1+LV7YtnOSFOMI0qcSlTM
	 AdIC7HLv8a/rjJusrimTeX+YZKPj7rldnRZ20Y6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1513/2214] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150112.537402466@linuxfoundation.org>
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
index 081440cee3245..5c52e0d6f032a 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -180,7 +180,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0



