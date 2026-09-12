Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8426E235358;
	Sat, 12 Sep 2026 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199625; cv=none; b=cSWAowomAVRHb94CCcmxWYrI+QPWFTWgoQ/X86NtgXJFhTtYUjfpHIqIHDMTEjmRG4AC00wx5lb2y7zOBkTwT00dDojmPyTvI2n+BN/Bfs0Jym8/T0QjENgZnzBvCU90tVzW5Zq/jpPsHy76QYUJodsboS/ZGEHPDN1DRHno4A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199625; c=relaxed/simple;
	bh=f2Bb6B6JW5ZwNTdNicED5pSgpKvTQuxO3FgdvSsF8Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umOssrjGipm/cUNtZma9Nx+Pj81d8o+2rOrGcsM6gTwHko+slHSp6DexaIby4tZH0xOfDs6JcKma4qi5jqw9JQb4WigMdzCsRhszyAJvVF43hOKXi4rx5PiQcHoVwxrkm8Ig2bFm++gNN2/9AcN638Z7Yir3Q1roAxxdD4QONpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+IfjIq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+IfjIq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882C31F000FF;
	Sat, 12 Sep 2026 07:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199624;
	bh=A9VCBNKB1s2zzzXLq1YvFbGR6uXrON6M9f1MKuOdGD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+IfjIq7Ap/wja+hCMA44lfk5ncwxTrs8XdhVr8uwjvodQUGCgRXb35V/RdcBq9w2
	 8PHP5fZZsQjHPi67KhD3h/y555v6NutHoN4xqiSXGY1hQ2TlHY0K7pXsdZw62NOiIK
	 IhazXgZuK02UEP/95e3m7lcn9ok+TW1zVvDou8fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0622/1815] bitmap: Properly initialise destination bitmap for scatter & gather test
Date: Sat, 12 Sep 2026 08:39:32 +0200
Message-ID: <20260912065703.482749618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit 36f78b0dfa7df4892ba067ccf00d95a4513b4935 ]

Erhard reports failure of bitmap tests on powerpc:

  test_bitmap: loaded.
  test_bitmap: [lib/test_bitmap.c:397] bitmaps contents differ: expected "1,3-4,9", got "1,3-4,9,65-71,73-79,81-87,89-95,97-99"
  test_bitmap: parselist('0-2047:128/256'):    912
  test_bitmap: scnprintf("%*pbl", '0-32767'):    5977
  test_bitmap: test_bitmap_read_perf:        1191082
  test_bitmap: test_bitmap_write_perf:        1270153
  test_bitmap: failed 1 out of 208655 tests

It happens mainly when CONFIG_INIT_STACK_ALL_PATTERN is set.

Commit 6b5a4b687367 ("bitmap: Add test for out-of-boundary
modifications for scatter & gather") extended the test to
out-of-boundary bits, but those bits were left uninitialised.

Properly initialise the entire result bitmap before the test.

[Yury: minor commit message tweaks]

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/ca3547ae-8b79-43a2-a758-23ec980bfd9a@mailbox.org
Fixes: 6b5a4b687367 ("bitmap: Add test for out-of-boundary modifications for scatter & gather")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 69813c10e6c0b..448c3eb48a4a8 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -392,6 +392,7 @@ static void __init test_bitmap_sg(void)
 
 	/* Scatter/gather relationship */
 	bitmap_zero(bmap_tmp, 100);
+	bitmap_zero(bmap_res, 100);
 	bitmap_gather(bmap_tmp, bmap_scatter, sg_mask, nbits);
 	bitmap_scatter(bmap_res, bmap_tmp, sg_mask, nbits);
 	expect_eq_bitmap(bmap_scatter, bmap_res, 100);
-- 
2.53.0



