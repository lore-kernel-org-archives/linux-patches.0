Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978913161B0;
	Wed, 17 Sep 2025 12:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113642; cv=none; b=fHAZz44kKmtex4+MxJh7h2K/WFLtrneyDxLNsmISbMbJvnfSk0E+r1HbRudpvhuDPVc47wWDsOyIp2CQ/XhZJ90Q4H0bEomuPtwuQh0Ja8DA1arXaLsA0muwtqQcCSRjqZhlP7jokXgaUk8TwO3uPxy46AKy2cVxeMrfRYk39qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113642; c=relaxed/simple;
	bh=Xq1RV43DgJHJwDcMJgJPw4FV9ZNvwvGUW6hEIelSMRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyCGZQN9DdYrhEt8/gRVVA2DQEMwCKaCqocE064sovOucAPm091fuwY3ym2dcKFsiYa/itS9WngYCwD/Ug2pmO12SNgL3RRMA2GkoWM3Ez9e85rDegQKW845ts2zz2FGLLdfkMOD4q0N7Eak5A/tt8uQwH0WwwJshakB1irK74Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5xB/pKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5xB/pKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EDCC4CEF0;
	Wed, 17 Sep 2025 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113642;
	bh=Xq1RV43DgJHJwDcMJgJPw4FV9ZNvwvGUW6hEIelSMRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5xB/pKDw0RrkZtMhuDnYI/YnfzfO4pwfCuLKrr44OA2GgJ7Z+OKYHZvHD59C75Z/
	 TFbziLTMpedpBUXtllvE7SFTiJRWi551avQR+Vn5o5LAHdwmHOwgHzfbjGgrKHHKO7
	 QNHaXItOQcbjTW5TZ4OT7L49Quc/FGpXETtnCQg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 001/101] kunit: kasan_test: disable fortify string checker on kasan_strings() test
Date: Wed, 17 Sep 2025 14:33:44 +0200
Message-ID: <20250917123336.899670303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

commit 7a19afee6fb39df63ddea7ce78976d8c521178c6 upstream.

Similar to commit 09c6304e38e4 ("kasan: test: fix compatibility with
FORTIFY_SOURCE") the kernel is panicing in kasan_string().

This is due to the `src` and `ptr` not being hidden from the optimizer
which would disable the runtime fortify string checker.

Call trace:
  __fortify_panic+0x10/0x20 (P)
  kasan_strings+0x980/0x9b0
  kunit_try_run_case+0x68/0x190
  kunit_generic_run_threadfn_adapter+0x34/0x68
  kthread+0x1c4/0x228
  ret_from_fork+0x10/0x20
 Code: d503233f a9bf7bfd 910003fd 9424b243 (d4210000)
 ---[ end trace 0000000000000000 ]---
 note: kunit_try_catch[128] exited with irqs disabled
 note: kunit_try_catch[128] exited with preempt_count 1
     # kasan_strings: try faulted: last
** replaying previous printk message **
     # kasan_strings: try faulted: last line seen mm/kasan/kasan_test_c.c:1600
     # kasan_strings: internal error occurred preventing test case from running: -4

Link: https://lkml.kernel.org/r/20250801120236.2962642-1-yeoreum.yun@arm.com
Fixes: 73228c7ecc5e ("KASAN: port KASAN Tests to KUnit")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/kasan_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/kasan_test.c
+++ b/mm/kasan/kasan_test.c
@@ -1053,6 +1053,7 @@ static void kasan_strings(struct kunit *
 
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	OPTIMIZER_HIDE_VAR(ptr);
 
 	kfree(ptr);
 


