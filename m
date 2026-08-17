Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B542AF87;
	Mon, 17 Aug 2026 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977436; cv=none; b=ZV0xBd1j2Xp6QbV2vghEPPhvmJfWB+2nsttdpc0FEfv3pCAqq51oFl5BblZfEsS/GU6ewVP5oFxC0+fKZDmADlgveGM+SejCmphd0jy4gv6ZXEea9DTjst5hFal7W5xYMs9gSA30ZBycODiAVJr3mtlxDiycWsldKWUyi+oAl2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977436; c=relaxed/simple;
	bh=KmOEbR3+BECSaby0be4s9/ki9k/qrMEykwmeS+pnYTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igVMpAz84q9gUJ1LuDyX9lZOj6HhOUHMNhO+A8xb0hx+0pNVh2WtBDXpztROJOTFRS761vRwAfBeIPnbphYW7CgFdLkCWIaYnvXz4K6gKTmqynY+OU4BXmzT0kADRKYvNvbbunxhn9KykcrSV8iPPz9SQkoUmEISX4FAYl81vrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9OdZ3Ce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9OdZ3Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247221F000E9;
	Mon, 17 Aug 2026 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977434;
	bh=oUO0dS8+Su5+pk+kKd6UsfovKrhJXsTkG33KxFoBwvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9OdZ3CeA+4/gaWfSzvzZZ0doE97LqtGy7aoxTwZkBkXuljWPfFV1kqdcULPmW0Fn
	 ros2Gq5VpaGoiIfdFA2WYjoRaSdXxes1bL1Bvz3E3zKg1g8K/meWwozQtiVMEsVihv
	 Qb2yQQHjhSFScLkiCkUgllRDhkm9oQ+XPvgFEhL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Gellermann <christian.gellermann@codasip.com>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 329/456] selftests/clone3: fix wild pointer access of getline due to missing init
Date: Mon, 17 Aug 2026 15:31:59 +0200
Message-ID: <20260817132552.512212911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Gellermann <christian.gellermann@codasip.com>

commit 8f6f9fd93cd7a5dd607ad5cd910476dd68fff3ed upstream.

Patch series "selftests: Add missing initalization of pointer passed to
getline", v2.


This patch (of 2):

Clone3_set_tid uses getline(&line, ...) in a loop to read the child's
process status.  The code expects that getline allocates the buffer for
the line on the first loop iteration.  According to the Open Group
Spec[1], char *line has to be null pointer for this:

> ssize_t getline(char **restrict lineptr, ...);
> If *lineptr is a null pointer or if the object pointed to by *lineptr
> is of insufficient size, an object shall be allocated as if by
malloc()
> or the object shall be reallocated as if by realloc()[...].

However, char *line is only declared, leading to an undefined value that
is potentially non-null.  In an example run with Musl v1.2.6, the realloc
call[2] of getdelim, which implements getline, triggers a segfault:

./run_kselftest.sh --test clone3:clone3_set_tid
[ 1366.165898] kselftest: Running tests in clone3
...
[ 1367.799244] clone3_set_tid[811]: unhandled signal 11 code 0x1 at
0x0000000000000000 in libc.so[68184,3fbf69f000+4c000]
[ 1367.802808] CPU: 0 UID: 0 PID: 811 Comm: clone3_set_tid Not tainted
..
[ 1367.804188]  epc: 0x0000003fbf6b0184
[ 1367.804188]  ra : 0x0000003fbf6d4664
[ 1367.804188]  sp : 0x0000003fce5f2e40
[ 1367.805314]  gp : 0x0000002aaab0dfb8
[ 1367.805314]  tp : 0x0000003fbf6f14a8
[ 1367.805314]  t0 : 0x0000003fbf63d000
...

Looking at the realloc implementation, Musl mallocs for a null pointer
memory.  But for a non-null pointer, it assumes it's passed a valid
pointer to the heap and tries to access its meta-data.  This leads to the
segfault we see:

void *realloc(void *p, size_t n)
{
        if (!p) return malloc(n);
        if (size_overflows(n)) return 0;

        struct meta *g = get_meta(p);
        ...
}

Fix this by properly initializing the line pointer to NULL.

Link: https://lore.kernel.org/20260722130246.2135563-1-christian.gellermann@codasip.com
Link: https://lore.kernel.org/20260722130246.2135563-2-christian.gellermann@codasip.com
Link: https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html [1]
Link: https://git.musl-libc.org/cgit/musl/tree/src/stdio/getdelim.c#n38 [2]
Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/clone3/clone3_set_tid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/clone3/clone3_set_tid.c
+++ b/tools/testing/selftests/clone3/clone3_set_tid.c
@@ -146,7 +146,7 @@ int main(int argc, char *argv[])
 {
 	FILE *f;
 	char buf;
-	char *line;
+	char *line = NULL;
 	int status;
 	int ret = -1;
 	size_t len = 0;


