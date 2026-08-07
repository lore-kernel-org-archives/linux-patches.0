Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDDE46C4B0;
	Fri,  7 Aug 2026 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117428; cv=none; b=OgScJvhiQyyWgSxyZDPy7L5FyjTmCTs+PvN+txwTlLPwg3D554QeVCS9rwWiFNqRYGk3gfEvceg7JTIhoN4PDJ/tXG86xniRad8DkkpVs55KowLDvheJhtQebZKX3nfggazdtWXr0fSbHBC/lMQtn3zUitzgRjYGHTke2z0VF+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117428; c=relaxed/simple;
	bh=4MLe8JCZBpzTG0CistmqqIcMRLjP2WQwXUaBJWMa3Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ff0JfEVpoaautXvI3b0dfJpoQiuL4VwqTTIteXoSuKfW1JvscyFiOXK536ARAEhQN21IIBXea72OawAmsrZ5u/jX2jyhFTJZwcZOmc7tX3zesPmVZeACSeIIZLjz1HB86LWQe9WEqXJXqZMOG2L4WpyUnUGqMVbWCZ5CEvf+mhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9wi4z18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9wi4z18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F071F000E9;
	Fri,  7 Aug 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117427;
	bh=faypeFiFO2lqvz7JwWNBlniXq10R0dBULxlpS72kqOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9wi4z18h179zv9OIWs/n1h/Akza69vspzVvFBApliLuEPou38FaF5f/RX0IDnU/0
	 BB8ptVZsxCXf+LJx9XIVpK3GLAJUFii/b2dBCZEhMFwBkKxUTQJmyzW+V7xRxeNWwn
	 UuPt17MKStInLakc+dsUM4WAKz/lPZS8ftzYyKOU=
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
Subject: [PATCH 7.1 316/438] selftests/mm: fix potential wild pointer access of getline due to missing init
Date: Fri,  7 Aug 2026 16:38:32 +0200
Message-ID: <20260807143434.706040452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


