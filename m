Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D25268FE5;
	Tue,  8 Apr 2025 11:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113060; cv=none; b=CUyuOxbLK6s0x21SX1C+DxKgxztBezXnDjf2t3a8VpScfP/FZwwZa8cp+qVIiDeZ4W5a4vgxxXUqvFx9vn5a9qtF8/eTZDKlQWj9Z49toKSQQXks5k2/2PT3uG7Q3p2EZvKbyuAwlLM3mUUISkaEDQPBfqaMfHZkTgflDbkpX0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113060; c=relaxed/simple;
	bh=OtlbReXhe57uQrEkFplNuFJBYj/oZPVA8XSpvkyuOPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB2ZFPyYO2+dPNdHXb30bMWVBGSJWgy8iBK2SkS9PoW5eUyjXFCJYI8RC61UtytZbfkJly6p1kPymN4ErcCA5J2rMQsiNlYb/E4lHvsYPgBwHES1fQyPZtORM6kEH9qLnD6MNjy0U6jEKUdDfGiip19IYjpW9HVFMaey3n33TtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS6+Sd1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS6+Sd1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF98CC4CEE5;
	Tue,  8 Apr 2025 11:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113060;
	bh=OtlbReXhe57uQrEkFplNuFJBYj/oZPVA8XSpvkyuOPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS6+Sd1jnFDrGnwqI2b1HRosPJUBra5KsHYrwykWYyUmMnmtlK6hhcD8iKIVPBVPu
	 ae/dYyw4l2zJ/vr1O9Av4ywBe2e6RPgovnPBEyZHgWtbRJvIJhKVSk0clZezmxJ+Kh
	 iErA/+qOgvpEMHD2/zVZKGvDKEw7yPUxgkPkz88k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/268] x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
Date: Tue,  8 Apr 2025 12:46:53 +0200
Message-ID: <20250408104828.568447865@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 33ea120582a638b2f2e380a50686c2b1d7cce795 ]

The CPA_ARRAY test always uses len[1] as numpages argument to
change_page_attr_set() although the addresses array is different each
iteration of the test loop.

Replace len[1] with len[i] to have numpages matching the addresses array.

Fixes: ecc729f1f471 ("x86/mm/cpa: Add ARRAY and PAGES_ARRAY selftests")
Signed-off-by: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250126074733.1384926-2-rppt@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/cpa-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/cpa-test.c b/arch/x86/mm/pat/cpa-test.c
index 3d2f7f0a6ed14..ad3c1feec990d 100644
--- a/arch/x86/mm/pat/cpa-test.c
+++ b/arch/x86/mm/pat/cpa-test.c
@@ -183,7 +183,7 @@ static int pageattr_test(void)
 			break;
 
 		case 1:
-			err = change_page_attr_set(addrs, len[1], PAGE_CPA_TEST, 1);
+			err = change_page_attr_set(addrs, len[i], PAGE_CPA_TEST, 1);
 			break;
 
 		case 2:
-- 
2.39.5



