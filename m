Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9003F446D5;
	Mon,  1 Apr 2024 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988067; cv=none; b=DMTak4Exzsv+UQO39nXDXPdIXtNuGFPViYK6YVCknbxGU9Hr8d8C4CNFcXp4BgxFichzPbqp9e3ujMVkJx+wAxFO2j/NjMmHKR8dGWMUfANVO8v4z5OsFiWum9o0QiJgTpHUOALezvrgEqRLrBe33sQclQvcSIdyoE5gQKIOKZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988067; c=relaxed/simple;
	bh=T4ikmw57N2je94o+gex2DstAI59TC99oF1YqHrM6/ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfQaQm6sO1wf6Ib1NOF2009b662dm65dHBG8ixvJC39uEM/0IjkkgFFGdkR1JObm/5qDu4Zu5wBlCCJGaAEYPDcr02TCKYXIVZVIVhZgxLboUmzaxWhnvNm77A3hVqNOvSzJRPL8vW4/1RPGvp613By5gymdaaZS+ypmQJToeSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQ2IZYeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQ2IZYeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0164CC43390;
	Mon,  1 Apr 2024 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988067;
	bh=T4ikmw57N2je94o+gex2DstAI59TC99oF1YqHrM6/ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQ2IZYeRyohFS0Lubp0VT/WmDGZjx6ykqXwN7vYdY3rwL7waLgro+EJ/15659BpiZ
	 lwLVyi0dqyeKRFx87iIz0RzIZo0JKiI6ck2K77Gnxpb6fNA9GIFmFy/gH2a1rct2ff
	 bq3Y8+iOfiu6m617aP0VcyxDTix/RsmhPrytU27U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 045/432] kasan/test: avoid gcc warning for intentional overflow
Date: Mon,  1 Apr 2024 17:40:32 +0200
Message-ID: <20240401152554.472911382@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e10aea105e9ed14b62a11844fec6aaa87c6935a3 ]

The out-of-bounds test allocates an object that is three bytes too short
in order to validate the bounds checking.  Starting with gcc-14, this
causes a compile-time warning as gcc has grown smart enough to understand
the sizeof() logic:

mm/kasan/kasan_test.c: In function 'kmalloc_oob_16':
mm/kasan/kasan_test.c:443:14: error: allocation of insufficient size '13' for type 'struct <anonymous>' with size '16' [-Werror=alloc-size]
  443 |         ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
      |              ^

Hide the actual computation behind a RELOC_HIDE() that ensures
the compiler misses the intentional bug.

Link: https://lkml.kernel.org/r/20240212111609.869266-1-arnd@kernel.org
Fixes: 3f15801cdc23 ("lib: add kasan test module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/kasan_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/kasan_test.c b/mm/kasan/kasan_test.c
index 34515a106ca57..23906e886b577 100644
--- a/mm/kasan/kasan_test.c
+++ b/mm/kasan/kasan_test.c
@@ -451,7 +451,8 @@ static void kmalloc_oob_16(struct kunit *test)
 	/* This test is specifically crafted for the generic mode. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
 
-	ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
+	/* RELOC_HIDE to prevent gcc from warning about short alloc */
+	ptr1 = RELOC_HIDE(kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL), 0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
 
 	ptr2 = kmalloc(sizeof(*ptr2), GFP_KERNEL);
-- 
2.43.0



