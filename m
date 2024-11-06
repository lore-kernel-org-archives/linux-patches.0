Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A651E1322;
	Wed,  6 Nov 2024 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897592; cv=none; b=DyjMzGbZ1KzvLLWEw8Ogf3rxYmO3MLshhrgu7yl3H1JCGCOTwIlzBmByURVAl/9tKD5Zp2EUpIAqMQ3u3V+35y5CYVbqM4YjP0rCBIJO9+hmDjMkPQ0CSJJRK9zab8S2YZppFv5h3vQpWzc1ijd47DK8zETK+GeqfeVBqLOsdA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897592; c=relaxed/simple;
	bh=I6CHDy2ARDx+FHmWLyoMnN6BQcfZkoaCmjRpzmlR12M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cfgKiIpiPgefujxkfZIbV49Dtqr+vwVnx3A4tJQI6vxClIE2RmsGoCy5M1YM0GReYJhCGMqwgVVW7rFKy9IeUvZV5/J6bMKDOuvs7wZEWTXh9ag40D0CwUJUcEhdYzsHvy43AStqgiFXsgW9IHS3jrGloMp+23+ZubhDYENYjlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9oc66HI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9oc66HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE451C4CECD;
	Wed,  6 Nov 2024 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897592;
	bh=I6CHDy2ARDx+FHmWLyoMnN6BQcfZkoaCmjRpzmlR12M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9oc66HItWzVDxDDawAflsMniKMDRsqg7ocmDezWypvtt893FQzqKhlG7entBp8jf
	 S+MLy4e7NfqsZKswXHGBh1c3q3Iqeb309SQfZNAA6lkqh1v3OBzW39tQWPkdD54HFe
	 qEqNmlkkV3FzFYhNt9rYVCKJMgKTCaaVvrG0gc8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wladislav Wiebe <wladislav.kw@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Herton R. Krzesinski" <herton@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 104/151] tools/mm: -Werror fixes in page-types/slabinfo
Date: Wed,  6 Nov 2024 13:04:52 +0100
Message-ID: <20241106120311.736887947@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wladislav Wiebe <wladislav.kw@gmail.com>

commit ece5897e5a10fcd56a317e32f2dc7219f366a5a8 upstream.

Commit e6d2c436ff693 ("tools/mm: allow users to provide additional
cflags/ldflags") passes now CFLAGS to Makefile.  With this, build systems
with default -Werror enabled found:

slabinfo.c:1300:25: error: ignoring return value of 'chdir'
declared with attribute 'warn_unused_result' [-Werror=unused-result]
                         chdir("..");
                         ^~~~~~~~~~~
page-types.c:397:35: error: format '%lu' expects argument of type
'long unsigned int', but argument 2 has type 'uint64_t'
{aka 'long long unsigned int'} [-Werror=format=]
                         printf("%lu\t", mapcnt0);
                                 ~~^     ~~~~~~~
..

Fix page-types by using PRIu64 for uint64_t prints and check in slabinfo
for return code on chdir("..").

Link: https://lkml.kernel.org/r/c1ceb507-94bc-461c-934d-c19b77edd825@gmail.com
Fixes: e6d2c436ff69 ("tools/mm: allow users to provide additional cflags/ldflags")
Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Herton R. Krzesinski <herton@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/mm/page-types.c |    9 +++++----
 tools/mm/slabinfo.c   |    4 +++-
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -22,6 +22,7 @@
 #include <time.h>
 #include <setjmp.h>
 #include <signal.h>
+#include <inttypes.h>
 #include <sys/types.h>
 #include <sys/errno.h>
 #include <sys/fcntl.h>
@@ -392,9 +393,9 @@ static void show_page_range(unsigned lon
 		if (opt_file)
 			printf("%lx\t", voff);
 		if (opt_list_cgroup)
-			printf("@%llu\t", (unsigned long long)cgroup0);
+			printf("@%" PRIu64 "\t", cgroup0);
 		if (opt_list_mapcnt)
-			printf("%lu\t", mapcnt0);
+			printf("%" PRIu64 "\t", mapcnt0);
 		printf("%lx\t%lx\t%s\n",
 				index, count, page_flag_name(flags0));
 	}
@@ -420,9 +421,9 @@ static void show_page(unsigned long voff
 	if (opt_file)
 		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
-		printf("@%llu\t", (unsigned long long)cgroup);
+		printf("@%" PRIu64 "\t", cgroup)
 	if (opt_list_mapcnt)
-		printf("%lu\t", mapcnt);
+		printf("%" PRIu64 "\t", mapcnt);
 
 	printf("%lx\t%s\n", offset, page_flag_name(flags));
 }
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -1297,7 +1297,9 @@ static void read_slab_dir(void)
 			slab->cpu_partial_free = get_obj("cpu_partial_free");
 			slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
 			slab->deactivate_bypass = get_obj("deactivate_bypass");
-			chdir("..");
+			if (chdir(".."))
+				fatal("Unable to chdir from slab ../%s\n",
+				      slab->name);
 			if (slab->name[0] == ':')
 				alias_targets++;
 			slab++;


