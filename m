Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF962386C1E;
	Fri,  7 Aug 2026 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114251; cv=none; b=MbKTn/oHAwqtPo0ic6RXd2pJcDqfo+JHt+oJLGsXX5N6wHvez0/LQc/JhLXUMivDJE+SnU7gZeC5lSAAj95DLtM0NAoPh45h6PyPzcTJ1QtrbAGOwqaSrqzx68zNT2XEEglzGSjVI0HeJcsrTxPll4pYwsb9wPi0XXd3IqaqpNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114251; c=relaxed/simple;
	bh=1PiI0zF2R3goKL9zFw3BDj+91vXAg/6AaYXOYIv7w/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkr4aafeQKZy1XKn5tbp/4MnPjJJjCfdRLmVF2b6nC8UgTuHcYzVYtWYMU/A6L+RLjgbq0be6t1FO6IbjuCmjBADU2BFRYtQS6ecfqPWOR8LNR48SG/FnYJd2on11MEScX9/yg2vA3rGhqteXpft3xGFRC9DzRAr5+SxkQb/fFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLBeRTSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLBeRTSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D021F00A3A;
	Fri,  7 Aug 2026 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114246;
	bh=N8mTqSlK3Qp0eGMBGcRGPown+lNMXLl3AUIe8ui7jvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLBeRTSCa5tTVdpivAfSFxspNIgnsmZKApeiteNe4caUgennX0VhkzSY0QjO3e0xf
	 F9WU9XF+P4cM5IoDrKbfOFfOSC/1vrABJ4q+od6fCPG1Mnab8NrLvXeVmmGoasgaYF
	 eoZO7sBas6AYzvuVt6M4rpm5aBdBX9rXmyPMa5NA=
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
Subject: [PATCH 6.12 196/337] selftests/clone3: fix wild pointer access of getline due to missing init
Date: Fri,  7 Aug 2026 16:36:39 +0200
Message-ID: <20260807143422.803851643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -141,7 +141,7 @@ int main(int argc, char *argv[])
 {
 	FILE *f;
 	char buf;
-	char *line;
+	char *line = NULL;
 	int status;
 	int ret = -1;
 	size_t len = 0;


