Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7704613B2A4;
	Wed, 17 Sep 2025 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113370; cv=none; b=CDcq4KeOZu3HkBX95gbVaJ2wemBGUsC6RLdNo+OfVESd0ISqY1Z35/mAH/lv4pLzbaAmQP21Pc6tB/qVyAOiCzipDW7DzmwtDiSyw/J92zcrXPXxnTAwW+wTn43Zm48CJ5BUt+GUYL2lnOiXIFWB9AZOat+IKpqgTUjIKz5eF8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113370; c=relaxed/simple;
	bh=02KDFAZNFvICtKJfz/wd3TkM0Mto4778RaA0BFPGZb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Czd3mwV+WSWxqvGj07kFzJRelqxIsC0ikgmiUlC1VDS5+b1vrA9D3soscNf5XE+rBEB70QgwbNZFoXPyyPjk4S31GoNzYQfY09RvRUg8icgOmOTyz5NEahQTUdXEPu/dztHmZJfPLrKoWZ6L0bU0FC0Bzm39w2kkvgmjLg56WgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAG8oVa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAG8oVa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B463EC4CEF0;
	Wed, 17 Sep 2025 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113370;
	bh=02KDFAZNFvICtKJfz/wd3TkM0Mto4778RaA0BFPGZb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAG8oVa/6A/NJCu/kl6UFo7m9LPfO/EP17v4Ne0ujtiW/oN4mOmx4YVkzVCH5tZns
	 vsJtyC4YGtN/xrVSOj/aN+wjIHOzewteiFesmE+SjVISZvZSfj9gj1/1sYi7dtQWdU
	 pVefZZyT/KU8u8JzYpKE2Jkxpw2R2EHN07i1MfwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	David Hildenbrand <david@redhat.com>,
	Jane Chu <jane.chu@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Borislav Betkov <bp@alien8.de>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Russ Anderson <russ.anderson@hpe.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 064/140] mm/memory-failure: fix redundant updates for already poisoned pages
Date: Wed, 17 Sep 2025 14:33:56 +0200
Message-ID: <20250917123345.866456002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Meyer <kyle.meyer@hpe.com>

commit 3be306cccdccede13e3cefd0c14e430cc2b7c9c7 upstream.

Duplicate memory errors can be reported by multiple sources.

Passing an already poisoned page to action_result() causes issues:

* The amount of hardware corrupted memory is incorrectly updated.
* Per NUMA node MF stats are incorrectly updated.
* Redundant "already poisoned" messages are printed.

Avoid those issues by:

* Skipping hardware corrupted memory updates for already poisoned pages.
* Skipping per NUMA node MF stats updates for already poisoned pages.
* Dropping redundant "already poisoned" messages.

Make MF_MSG_ALREADY_POISONED consistent with other action_page_types and
make calls to action_result() consistent for already poisoned normal pages
and huge pages.

Link: https://lkml.kernel.org/r/aLCiHMy12Ck3ouwC@hpe.com
Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Russ Anderson <russ.anderson@hpe.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -948,7 +948,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
+	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1341,9 +1341,10 @@ static int action_result(unsigned long p
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	num_poisoned_pages_inc(pfn);
-
-	update_per_node_mf_stats(pfn, result);
+	if (type != MF_MSG_ALREADY_POISONED) {
+		num_poisoned_pages_inc(pfn);
+		update_per_node_mf_stats(pfn, result);
+	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
@@ -2086,12 +2087,11 @@ retry:
 		*hugetlb = 0;
 		return 0;
 	} else if (res == -EHWPOISON) {
-		pr_err("%#lx: already hardware poisoned\n", pfn);
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
-			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		}
+		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		return res;
 	} else if (res == -EBUSY) {
 		if (!(flags & MF_NO_RETRY)) {
@@ -2273,7 +2273,6 @@ try_again:
 		goto unlock_mutex;
 
 	if (TestSetPageHWPoison(p)) {
-		pr_err("%#lx: already hardware poisoned\n", pfn);
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);


