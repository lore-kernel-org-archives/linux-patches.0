Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3572F32
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lv6AIW6lF2JPB7SbfoQQs9rQTnaHfUU5yFYPqYrcs0g=; b=HB5MVsriEhP2gANf9CHGU8lepI
	Ejew55wdz3HG+p9zeFY3/L/5GdnF3y29cQ2x/7NmQlylhHIDANxC6ny1Z/mIL8KXWlnAxARzO+JBm
	/CtTwB6SHmff1+imOWBr9qU+iQnDUCRniRMTq+qkWSB0pyZdlmxDa3mxr3pu7fchPnz4SEMW/kfEp
	HyfTfBZIzIYaRsNGfHHJ1VrGCVVHLaLTBzy45KmdTXE1n2zDGZUfLQoB6BlLu+nuysyqQK4qh+0W6
	9suAmYmlW8gAdwXtOuEKSTx8XKWDmQRbMOJ8P6k+XvFu6ejnNJaPqgdO3fnn3ms4z2UkxpKxTsP29
	dRZDqnkQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamQR-00Gj2p-VE; Fri, 10 Mar 2023 23:45:27 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hca@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	sudipm.mukherjee@gmail.com
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/6] s390: simplify sysctl registration
Date: Fri, 10 Mar 2023 15:45:19 -0800
Message-Id: <20230310234525.3986352-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

s390 is the last architecture and one of the last users of
register_sysctl_table(). It was last becuase it had one use case
with dynamic memory allocation and it just required a bit more
thought.

This is all being done to help reduce code and avoid usage of API
calls for sysctl registration that can incur recusion. The recursion
only happens when you have subdirectories with entries and s390 does
not have any of that so either way recursion is avoided. Long term
though we can do away with just removing register_sysctl_table()
and then using ARRAY_SIZE() and save us tons of memory all over the
place by not having to add an extra empty entry all over.

Hopefully that commit log suffices for the dynamic allocation
conversion, but I would really like someone to test it as I haven't
tested a single patch, I'm super guiltly to accept I've just waited for
patches to finish compile testing and that's not over yet.

Anyway the changes other than the dynamic allocation one are pretty
trivial. That one could use some good review.

With all this out of the way we have just one stupid last user of
register_sysctl_table(): drivers/parport/procfs.c

That one is also dynamic. Hopefully the maintainer will be motivated
to do that conversion with all the examples out there now and this
having a complex one.

For more information refer to the new docs:

https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     
 
Luis Chamberlain (6):
  s390: simplify one-level sysctl registration for topology_ctl_table
  s390: simplify one-level syctl registration for s390dbf_table
  s390: simplify one-level sysctl registration for appldata_table
  s390: simplify one level sysctl registration for cmm_table
  s390: simplify one-level sysctl registration for page_table_sysctl
  s390: simplify dynamic sysctl registration for appldata_register_ops

 arch/s390/appldata/appldata_base.c | 30 ++++++++----------------------
 arch/s390/kernel/debug.c           | 12 +-----------
 arch/s390/kernel/topology.c        | 12 +-----------
 arch/s390/mm/cmm.c                 | 12 +-----------
 arch/s390/mm/pgalloc.c             | 12 +-----------
 5 files changed, 12 insertions(+), 66 deletions(-)

-- 
2.39.1

