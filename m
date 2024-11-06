Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E24207F;
	Wed,  6 Nov 2024 12:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896241; cv=none; b=T81jtw5xHriD8CYUZ4cDLs9xAC9vXWqZ6HhoBliscPWoS3dhGi7EH/79lEzoBfwi+uQByNzpygEg813mtzLqae3jMrJCAHBK0XEZl8rPImXAitmlKTh+9u74u8Q7Uu20qgxNh8yCK6gI/Y0LaHa8m3hAKrtnJVQBejmRHKbs98A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896241; c=relaxed/simple;
	bh=WOsv19W2XO6zGYmPFcTOuxO7/Q7Z0RTXJJtMAXzXHiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+W2S2Tng3emJ3nrPRJhUq2HW9JVVaYjhFkEEkeRBJYjF82m/G+fGeS5lZpwtVcg52fFqgeFiZAZXBt34ot5l5dMii8BAMGzE59M6+xJ0HiX+4A3ruCeY8wo+0waweLcpER2YhkTQEePwS0Q21LfCEGOAqWWgZYKZfF2PBZQPyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6CaedTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6CaedTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14606C4CED4;
	Wed,  6 Nov 2024 12:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896241;
	bh=WOsv19W2XO6zGYmPFcTOuxO7/Q7Z0RTXJJtMAXzXHiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6CaedTshrODrRU8EkWZRDxY71cg9bUcyK5OXghMcSLkQ0gfT72FWC6B98qcaW3Nc
	 h/bst7MKIlLWG/fOCG57G7gsoc0Jyim28inoQkM42vkL6EZoQlSXLYLNo0pSj1RqH7
	 SdUZujny+XTurW3iozXLS5oYOfBkfEpxPHFHarQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wladislav Wiebe <wladislav.kw@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Herton R. Krzesinski" <herton@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 137/245] tools/mm: -Werror fixes in page-types/slabinfo
Date: Wed,  6 Nov 2024 13:03:10 +0100
Message-ID: <20241106120322.601400444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


