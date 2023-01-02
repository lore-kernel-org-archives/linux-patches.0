Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A59328EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6DCC433D2;
	Mon,  2 Jan 2023 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658917;
	bh=RBkTt8QNg2ZO1olscYqpcA9tJe+hT/P+gMH3HMG0A9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6iqw53ZGPrI0FR5vElybz2jykCSeG5Br7Sc1hmLuD0fT4OwCokYbCsVF8STm+Mvw
	 LUJ22rPYnWM77Of5AihHtjy8m6s8PlQsrK3wMKjM9744m58Vban8g2kC3NpgSuusrs
	 nLWxoV7/WzFNCTasMocjZO3IYUf+8pVHpBAblXl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Huang, Ying" <ying.huang@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michal Hocko <mhocko@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Feng Tang <feng.tang@intel.com>,
	Michal Hocko <mhocko@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andi Kleen <ak@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 49/74] mm/mempolicy: fix memory leak in set_mempolicy_home_node system call
Date: Mon,  2 Jan 2023 12:22:22 +0100
Message-Id: <20230102110554.172194568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 38ce7c9bdfc228c14d7621ba36d3eebedd9d4f76 upstream.

When encountering any vma in the range with policy other than MPOL_BIND or
MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put on
the policy just allocated with mpol_dup().

This allows arbitrary users to leak kernel memory.

Link: https://lkml.kernel.org/r/20221215194621.202816-1-mathieu.desnoyers@efficios.com
Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1525,6 +1525,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		 * the home node for vmas we already updated before.
 		 */
 		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
+			mpol_put(new);
 			err = -EOPNOTSUPP;
 			break;
 		}


