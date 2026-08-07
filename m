Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D1F29D27A;
	Fri,  7 Aug 2026 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114247; cv=none; b=QgnebLQVSY9vYFPucP7YG/tkOPtqYDH5b/06gOool3dGhi7XNsg0/ZLXjgaVQpD87jqgh7WIwdnjiXWgal7seUFm3Jx2I9y4YqzvVm5YDcviTAEIKtj2KbwIhUo1BHcsfFC6DP1oyRvS7RPQCoaM0lMwZwfFsDVHGGZuy+069U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114247; c=relaxed/simple;
	bh=eAUrEg/aTgIjb6+9P5vURWMwmBAaBCoOnYe5oXmiBH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xoel0a3AlfejR+TESfxtEzb7SbiKcuB3i166Jwffrnx0upfnqTIcnR8toJ7fhE2LOIIaMD8v8QrrrXhNKjIR85D3blFB8aL+q3Ye/WWxfzAZD/Hhau56oYfNVMkQ6feFjZyUmwZQELmuzZXT6iuvxWujiAXUdjta++kvK7M7CZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJW0zsSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJW0zsSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FAB1F00A3D;
	Fri,  7 Aug 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114243;
	bh=84w8211+WNwV5jV68t0WYaaFiGQD0auZpQ0fz4oq47A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJW0zsSK958105SNTW36ydT3OryH/3zgsC/yZHAv0nBn5hBYcGK/sOaYX55oqJUj+
	 dbdJtbrtBWZJOf5RAHf2vqG54F8/GAmGj+u3r52RqF+Qq5IZJ1kxqFIQZNG1Ij5LXl
	 ME6dsIEdj+9sgfF1P+rmOUAVa1DmPhhd1JXqJYos=
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
Subject: [PATCH 6.12 195/337] selftests/mm: fix potential wild pointer access of getline due to missing init
Date: Fri,  7 Aug 2026 16:36:38 +0200
Message-ID: <20260807143422.782541168@linuxfoundation.org>
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

commit 9f1d75a4ce04095afdb63d8e540092ff8151dacf upstream.

This is another occurrence of using getline where the code assumes that
getline allocates memory to store the line, but the pointer passed to it
is uninitialized and potentially a non-null pointer.  This violates the
Open Group Spec[1] and caused a segfault in a similar situation in
selftest/clone3/clone3_set_tid.  Fix it by initializing the line pointer
to NULL.

The issue has been found by simply grepping through the selftest code
after running into the issue in clone3_set_tid.  Whether it segfaults in
its current state is unknown to me.  But it's good to be addressed due to
defensive reasons.

Link: https://lore.kernel.org/20260722130246.2135563-3-christian.gellermann@codasip.com
Link: https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html [1]
Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/mlock-random-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mlock-random-test.c
+++ b/tools/testing/selftests/mm/mlock-random-test.c
@@ -84,7 +84,7 @@ int get_proc_locked_vm_size(void)
 int get_proc_page_size(unsigned long addr)
 {
 	FILE *smaps;
-	char *line;
+	char *line = NULL;
 	unsigned long mmupage_size = 0;
 	size_t size;
 


