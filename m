Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060612;
	b=KuhlVdyQkpXgbWvFkuicroUIOldFgyf+QAd7NL/bG/HgMeNzif1r/c5IT1+XsQ3OJX0g
	 7TH1pMNsA/H5ncjIblsyrtszZYhJATzHj7N4IhTfEcsetP0KjLnBaLa4nOnCMA2DrZKFk
	 H/AOJUHMlgIusJmUx7Da+tN2GkY86eZoGtIpHL2tnU1jptNytfi3LdBk6Y/iw/62L3XKw
	 gBYMMyUq43lqVmwxMy4HjxxD4RxZ6f1m/QwVPBwAtWFkgSb7g2WVQZ6wgqluVx+SwX9U4
	 3YU4Or+8v7RkovLRCkryUw3McCK847eDTs/rLSUe3IDbjLn41CfMZZ2kXClnGsqZ8KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fS2LtH+KoPeR+/UKEJp/3CZTJhIpBOI8t6EoruS3IuA=;
	b=R6Li4vY2Ymfpwxwe56Fa2JvnT0oxZsiTE3aNMgB38CGjKv2Gr5rPKPahS6uNyk2cmgWB
	 ilMbuJZWhe2lvFjevhYDE+Jcu0TIwQxAfAtDfe6EVaLSMipACnxiAxSfBuMfrXPLSIcyQ
	 cBuLY83GOGIJJJxpBt3Sr59eym3eP7ZREFbjugxdIiCE5jfeG2FiM0rZPNDIFMUxIEs1U
	 nJlj+36eTf3D4QPFAIcd1mrdShbO6BIyNv4vxyrx+pZ1lxtArLzwVh5ACHtAsAMkmOEDh
	 3gsYx3vxgePYVBZ15P8o+dGSKz/Af5TjeznKIHhV0hUuMfXNTAtRkesm5wvQhGyVFHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fD5pRHQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0938F606A320;
	Thu, 19 Nov 2026 03:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fD5pRHQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152651F000C4;
	Thu, 19 Nov 2026 03:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060611;
	bh=fS2LtH+KoPeR+/UKEJp/3CZTJhIpBOI8t6EoruS3IuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fD5pRHQ0TaogjqXuS6mc8N3l6Z1IKeHFTFx+tW7+qm1OCqXA847x9Fn8oVhXutlSY
	 L0q5fL43KgVd3/qbd14dwU5Z8oBTP+tcFjsOak4r9lwq2QfTWe2aQMGIYeTeNEd4od
	 r1v74iyEtUlsORgxwq+ReYGH2gv7u/5e58+WHRsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1261/1848] mm/gup_test: safely calculate GUP batch size
Date: Wed, 18 Nov 2026 15:54:59 +0100
Message-ID: <20261118150012.508623168@linuxfoundation.org>
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
index 340fc9bb6d0f9..cdf30cfcba139 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -76,7 +76,8 @@ static int __gup_test_ioctl(unsigned int cmd,
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -99,11 +100,9 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		/* Filter out most gup flags: only allow a tiny subset here: */
 		gup->flags &= FOLL_WRITE;
-- 
2.53.0



