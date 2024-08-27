Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0011C3F19;
	Tue, 27 Aug 2024 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770946; cv=none; b=gTs/6pCZVxv2/4R8Bl47K+CpDDSzybqjEr9N1WarwlsQw0zSogsPBpYD0pub5mkfkL4FTTWo9K7+1wF15J46YRdN5MGPSl4vmC/TSwkXPRBIonrKJfNeFGQlbqstZfIODTSvkbdub/Jrc9tqRaNbH2ScR/w5i479crGZV2uXnxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770946; c=relaxed/simple;
	bh=jgmayVLEXSWSdFnfIPGak9M21IutYzQCpguVtAgYdWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFlHXoIwvxAAtfnJ18WL05D8F87/MWJ/oV56iloUjF0YlDDNQNG1nGpvUFXP4dVgc2YcCa3YeFy2gm0012ik5zOKxvwIzRDaOKUxr8EiSHnFmNdTArN/m7ZHn3Fr2We9mZ1wbwXBGitC+L3VVXLBL0lI0Kp+HXE+fnBU9MAPoKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfxBPdXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfxBPdXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C318C61066;
	Tue, 27 Aug 2024 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770946;
	bh=jgmayVLEXSWSdFnfIPGak9M21IutYzQCpguVtAgYdWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfxBPdXf6WNfzst+tuSxkLRoapt3l/+C1jP9+EOMTKH8jJzX9TcN6mkTh+muS/p6t
	 wVtLx6Casv3QcSOJPb/f3J+GeQiZCICPDoGmv+DYbqhPDBhuKtUN6N8ohgZyLd3ys5
	 pWepR/7Em7yL+mENYATHWUwTlTu3q67Esc+Pf/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 041/273] mseal: fix is_madv_discard()
Date: Tue, 27 Aug 2024 16:36:05 +0200
Message-ID: <20240827143834.961134042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pedro.falcato@gmail.com>

commit e46bc2e7eb90a370bc27fa2fd98cb8251e7da1ec upstream.

is_madv_discard did its check wrong. MADV_ flags are not bitwise,
they're normal sequential numbers. So, for instance:
	behavior & (/* ... */ | MADV_REMOVE)

tagged both MADV_REMOVE and MADV_RANDOM (bit 0 set) as discard
operations.

As a result the kernel could erroneously block certain madvises (e.g
MADV_RANDOM or MADV_HUGEPAGE) on sealed VMAs due to them sharing bits
with blocked MADV operations (e.g REMOVE or WIPEONFORK).

This is obviously incorrect, so use a switch statement instead.

Link: https://lkml.kernel.org/r/20240807173336.2523757-1-pedro.falcato@gmail.com
Link: https://lkml.kernel.org/r/20240807173336.2523757-2-pedro.falcato@gmail.com
Fixes: 8be7258aad44 ("mseal: add mseal syscall")
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Tested-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mseal.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index bf783bba8ed0..15bba28acc00 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -40,9 +40,17 @@ static bool can_modify_vma(struct vm_area_struct *vma)
 
 static bool is_madv_discard(int behavior)
 {
-	return	behavior &
-		(MADV_FREE | MADV_DONTNEED | MADV_DONTNEED_LOCKED |
-		 MADV_REMOVE | MADV_DONTFORK | MADV_WIPEONFORK);
+	switch (behavior) {
+	case MADV_FREE:
+	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
+	case MADV_REMOVE:
+	case MADV_DONTFORK:
+	case MADV_WIPEONFORK:
+		return true;
+	}
+
+	return false;
 }
 
 static bool is_ro_anon(struct vm_area_struct *vma)
-- 
2.46.0



