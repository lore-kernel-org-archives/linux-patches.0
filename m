Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4844C13AA40;
	Wed, 19 Jun 2024 13:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802459; cv=none; b=TpgWe6qs1OSYGaC9ZB/f+MpgBqrgtOprqZNwQyHBIf3aO90OwKjiHBbArt7xrYsFH6Q5h7a16gzGKMUPdX6OTm1pp5+4Pj6SJ328K+Mnv5mSJUr0gng9nmVExMt48xinG0R3Kf8lBeeeh4P4nni58iBsTuPV43FkBe8W95vVdIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802459; c=relaxed/simple;
	bh=fYL5dtM1TilbZDPva09dLvPoZI/ZsyX7TXVWkkVzrog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE6UQb4L3oHRT3MHim/pwvhp5e2ACDzKH80Pw4d9m0DugXO1rlZa8yaxUxz0YijRE5Iz7iO/oJ3CV+DhIAO8YaYKKKqR+npLyaPG6sBxf6S+YFzeADa+vunlZ5kjlW5TnNZoYeT0cI8Q59JO8/am/E2C/wsTZ8czd2ACf4o7DT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWdIYD5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWdIYD5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13DEC2BBFC;
	Wed, 19 Jun 2024 13:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802459;
	bh=fYL5dtM1TilbZDPva09dLvPoZI/ZsyX7TXVWkkVzrog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWdIYD5dcQZ6Ga4EbVcDXoyzuVBWoNnyG2xRvX8cW6H4h4PncyNoUTOvrjLiJvegb
	 MKEyqbigREJEMTdlNI4YoqxEmzI6BC49VTyuyJH+VSv3kD6TrilntP5RTvmM8Mm34m
	 Cyb5AL7/h6r95kG9y6cYwrNhyzJ56/b26PLXmL3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 203/267] fs/proc: fix softlockup in __read_vmcore
Date: Wed, 19 Jun 2024 14:55:54 +0200
Message-ID: <20240619125614.122154898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit 5cbcb62dddf5346077feb82b7b0c9254222d3445 upstream.

While taking a kernel core dump with makedumpfile on a larger system,
softlockup messages often appear.

While softlockup warnings can be harmless, they can also interfere with
things like RCU freeing memory, which can be problematic when the kdump
kexec image is configured with as little memory as possible.

Avoid the softlockup, and give things like work items and RCU a chance to
do their thing during __read_vmcore by adding a cond_resched.

Link: https://lkml.kernel.org/r/20240507091858.36ff767f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -383,6 +383,8 @@ static ssize_t __read_vmcore(struct iov_
 		/* leave now if filled buffer already */
 		if (!iov_iter_count(iter))
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {


