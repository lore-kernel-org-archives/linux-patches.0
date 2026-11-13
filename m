Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591131;
	b=sS00FgHOkOO2siQpKYpMnCi9Yr2ef/QIP06zsHEUGBWnoxo1jfNlwqTCg3OipdCxd3xy
	 agY3RV9HYG3MiugYeMR9SVapbxj1CNBgGOQkiCpcLDBgdb0Rw5BowEDP4mWfZ04cRBOoP
	 vpltlXOV1+S1gOTNNnMxx/vdr0i2IqJTuZE8LvSkVa3CB4YZa4FI3agu7MIf7SoHUtpw3
	 YV4uL9NFXc6yomBS8HdqEInmbJ+OljCHGwvPLmFtBhmp0GfM9kMs9THDOjD7HkwKyoY88
	 kZ1XOueM4XWZ9AMtuhbi5FscQd9snHOcgoEI98wb9bE+dSpr4n/aeCzg6JVCXK5lE7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QkAF+CNhbg2ifBMpe8iwhjeSYHPVwHlY+IDECRqq/Kk=;
	b=DaD810fg50xCA6QRtSnai+w9/lNKOMwLP54yb0ymeGUTa210cWHLkBYuu+9XhiXuq3Qw
	 42LH3mhNueoDzczoErAi6HWzA1HqP3Iv5hjnNl2bqLJmyooRVLvqpOtNlWxbiUpuJKsxa
	 yUrORDCMdfk3PlYr07OGBrFDAqAWWMxW31a8GuGys3nEKLDSEChmdfv4IVAl8gTUf0hKY
	 Nx2Z/9dYDqPjsd5a6+rZARx4G5PN0hLyKYh3ajT36s3hleWRuP4dCwh0K/tsN0XBLvb+g
	 aa1nCgcGTIViVf/fAZ7fugE7NhlYqACUf4LypuS9kQVCncBHGmARI/9BctKf620m45Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBFB3TwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3688606A88C;
	Fri, 13 Nov 2026 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBFB3TwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E71F000C4;
	Fri, 13 Nov 2026 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591131;
	bh=QkAF+CNhbg2ifBMpe8iwhjeSYHPVwHlY+IDECRqq/Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBFB3TwWa0Wza1Tt3Cc0czvbNhS7zXHXzjpVCRQEg8foYlIUt6UJBeB5/iSbnHjua
	 jpgDakCdBCUdQshEeTzxNoidKKwXJwn+9byxvL9pyoYx292y1E0xOnfe42u2QR60CZ
	 h3eEiQ9FJ4IQQSK7PimdYH6FdPekkKLA4qF+a2RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/670] mm/ksm: keep soft-dirty when merging a page
Date: Fri, 13 Nov 2026 10:47:22 -0500
Message-ID: <20261113153821.305848593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Samarth Narang <samarth.colleges@gmail.com>

[ Upstream commit 2efc6332f18bfd848f74f3d5ba45b31450601faa ]

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty bit of the PTE it replaces is lost.  A page written since
"clear_refs 4" then no longer shows as soft-dirty once it is merged, and a
soft-dirty based dumper treats it as unchanged.

Copy the soft-dirty bit from the original PTE to the new PTE.

Link: https://lore.kernel.org/20261021182157.1873726-1-samarth.colleges@gmail.com
Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 15f558f69093a..aba53b4a3b978 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1407,6 +1407,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another
-- 
2.53.0



