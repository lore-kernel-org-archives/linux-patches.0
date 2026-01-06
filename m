Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A21366547;
	Tue,  6 Jan 2026 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722445; cv=none; b=dL8T6681j9HD2noENEg//K0YIIJQGtUDYDt9tE8j+QW9X7XUzkrBiPpMl1VwW6nSgwQZD02Olq4ghF9AITEmAjnU0Fliz+icCYWacvqtE/eMDqGiZyJv/P6j07AtKBnG+p2oIDyS1XCuMZRPlL3epcGW6Tz+0GrUYk5XvHLV+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722445; c=relaxed/simple;
	bh=faMirbnbp2OFdmYjAj6DwcLp1cwBawYPqeqNTUIDCDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcxdUuZjuh6T4lsbYz4/jVAkJou20sa5rRxTVzDLFUZ1pLN/Nw9jkqL3noazV/2AcE+rikq1Ut80XcjKcwncSEepVl3OpiY/zevVN+E4w2apkTTYdZQAM+ub6IZQwMPmELVEEv8uop3olNwsSRwraC4Pc7dKZDdRLg3K1sb3DkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBS/G5jW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBS/G5jW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C625C16AAE;
	Tue,  6 Jan 2026 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722445;
	bh=faMirbnbp2OFdmYjAj6DwcLp1cwBawYPqeqNTUIDCDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBS/G5jWY4LS5pGVFGBgbCPJNHPS8piKMUjQP0uNVbwdlnvte93YNxjB2TJCoKYDa
	 Tb8Euv5b4P7iPskxTZu+h36WOlzFjwf8PEjlPa1evkxXFMg+wzkJ9jUkow6ZN/apZT
	 E0WITYfkhVVFBdXv1y3DLApNxkPbfCTYFeTQOh3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Peter Xu <peterx@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 234/312] selftests/mm: fix thread state check in uffd-unit-tests
Date: Tue,  6 Jan 2026 18:05:08 +0100
Message-ID: <20260106170556.316818434@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wake Liu <wakel@google.com>

commit 632b874d59a36caf829ab5790dafb90f9b350fd6 upstream.

In the thread_state_get() function, the logic to find the thread's state
character was using `sizeof(header) - 1` to calculate the offset from the
"State:\t" string.

The `header` variable is a `const char *` pointer.  `sizeof()` on a
pointer returns the size of the pointer itself, not the length of the
string literal it points to.  This makes the code's behavior dependent on
the architecture's pointer size.

This bug was identified on a 32-bit ARM build (`gsi_tv_arm`) for Android,
running on an ARMv8-based device, compiled with Clang 19.0.1.

On this 32-bit architecture, `sizeof(char *)` is 4.  The expression
`sizeof(header) - 1` resulted in an incorrect offset of 3, causing the
test to read the wrong character from `/proc/[tid]/status` and fail.

On 64-bit architectures, `sizeof(char *)` is 8, so the expression
coincidentally evaluates to 7, which matches the length of "State:\t".
This is why the bug likely remained hidden on 64-bit builds.

To fix this and make the code portable and correct across all
architectures, this patch replaces `sizeof(header) - 1` with
`strlen(header)`.  The `strlen()` function correctly calculates the
string's length, ensuring the correct offset is always used.

Link: https://lkml.kernel.org/r/20251210091408.3781445-1-wakel@google.com
Fixes: f60b6634cd88 ("mm/selftests: add a test to verify mmap_changing race with -EAGAIN")
Signed-off-by: Wake Liu <wakel@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1317,7 +1317,7 @@ static thread_state thread_state_get(pid
 		p = strstr(tmp, header);
 		if (p) {
 			/* For example, "State:\tD (disk sleep)" */
-			c = *(p + sizeof(header) - 1);
+			c = *(p + strlen(header));
 			return c == 'D' ?
 			    THR_STATE_UNINTERRUPTIBLE : THR_STATE_UNKNOWN;
 		}


