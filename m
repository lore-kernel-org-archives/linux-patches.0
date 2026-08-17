Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2835E3ABD99;
	Mon, 17 Aug 2026 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980015; cv=none; b=ZKa7lZfPu8OFLW/g7cuZlBVYJi7i5hi3hmMRnjFCMLvXND9jqabtpbkEbv2XExbnscLgsUtepLcPigMWyTUgHTQvaKSA9KH/DmUdN1AdI8AjVE0S8/YHKVtAr6IaYGbTJiwdb+n/mqmSEZyZkE2vjfU6vrfbIcGgzl88AaHC9Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980015; c=relaxed/simple;
	bh=+0zpuoAbMXQK7eDbum2MTRzuGthysqn0alpctc9NwwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPIWPO1SoCK1eE3d36VRTQ08O3U3TRAidJlrpYejf/rcbgDeS7KNef2sOu0loMPN5IR+jwU4imOLhh/as34IqrvDYZzuvpKbEj8CAMQay823z3VMEN4/87Z6orSecKU591D1NP6yrAI/vGptcNA8P06esH6Pet5kTN/aKha3KRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/D5xHUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/D5xHUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BE61F000E9;
	Mon, 17 Aug 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980014;
	bh=SdvDoSGwDYI71zTdUYi+mEaAEeCkuHe7qwj5RyYiI0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/D5xHUS1YeoUuEuv9xz53Uqy/67fZlTcbiESxjg/z9tR5nLA9rrt4EBVMnva+aEV
	 Z3RNZ5cnFdFRxRAX+y79rikyY6uwHil+CT1xWKm16hDiIirLY3ULeRCYUAiem8yFKw
	 l+R4XiZCJ0jHALUnV29yIVe2gTh8YAWlvcmegtPw=
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
Subject: [PATCH 6.1 426/609] selftests/clone3: fix wild pointer access of getline due to missing init
Date: Mon, 17 Aug 2026 15:32:02 +0200
Message-ID: <20260817132558.355770441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


