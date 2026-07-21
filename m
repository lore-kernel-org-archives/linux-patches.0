Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C96366816;
	Tue, 21 Jul 2026 20:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667208; cv=none; b=fLDYWEaI2tbFH0C8IJiatDInZOzvh2AEOWMMogxs86RijsPfXsvIvNVPuiKzFkagVyD1to1UgTQIkPVC0lg78AE0rVXrRRv9hQA1j++F6fXbjjPKziz5QLrxuSfRCsG4cIeVrNM0bhbqXnv75lYn1SuuCBuEupViq4Q6CC0CnAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667208; c=relaxed/simple;
	bh=n2y/rNoTqbnIr5AD/ge9Atg0d1XmD2IVXn3BKNj/U9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPU0qS62cvglkyuvS7EugT9ZPZUNnet92IMYE9jzvR5mMBgotTbQSzGE+ZeFmihTUWJeVUy2jsPWeMCIk/ZfGY6qDfE1x/pNrtI/wHVSl1duBMPXBiGMUBEA0UTzXWwDZW/J9N5pIyTbnEzpXbUR7CzVDOnnSSK4GVshiNJ16Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/ZZyppX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/ZZyppX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC481F000E9;
	Tue, 21 Jul 2026 20:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667207;
	bh=/tY3qLYkLTC1cUzWMDsEm9uTvEAeUK0B1yMNp3iD18A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/ZZyppXIj+9j56Bfn9F7F3qL6eIqtGvjMO4c8PqsPFYyJFeAz73V5Gj82gyWeOlX
	 /uvUQioL8mcHFJtQ+hv9qOSEq19l7Joj346Iveo5t6LZ35icAuwG2J+kuw+FLiGiFa
	 uW/Sza+SdyR4Kc4iMOmMTmI/28eQJXwc+WQOJ2og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0975/1266] mm/damon/core: make charge_addr_from aware of end-address exclusivity
Date: Tue, 21 Jul 2026 17:23:32 +0200
Message-ID: <20260721152503.659478664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: SeongJae Park <sj@kernel.org>

commit 5a2d162e22bf33eb89d53e802d0fc1ec422e19b6 upstream.

DAMON region end address is exclusive one, but charge_addr_from is
assigned assuming the end address is inclusive.  As a result, DAMOS action
to next up to min_region_sz memory can be skipped.  This is quite
negligible user impact.  But, the bug is a bug that can be very simply
fixed.  Fix the wrong assignment to respect the exclusiveness of the
address.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260428042942.118230-1-sj@kernel.org
Link: https://lore.kernel.org/20260428032324.115663-1-sj@kernel.org [1]
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1003,7 +1003,7 @@ static void damos_apply_scheme(struct da
 		quota->charged_sz += sz;
 		if (quota->esz && quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-			quota->charge_addr_from = r->ar.end + 1;
+			quota->charge_addr_from = r->ar.end;
 		}
 	}
 	if (s->action != DAMOS_STAT)


