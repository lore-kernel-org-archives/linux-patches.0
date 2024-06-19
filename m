Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334DA82495;
	Wed, 19 Jun 2024 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803350; cv=none; b=Y5505Ou64pMlqlcEka56WO+7z3skwsEz6Ng8YjVKbv0B4JMcRXZmyS7hmnZuNzPhc2GqSt55Y3/3bjAZSptP9DV+A9iZIVEj1NE6Izuekt27VqNtHR4McOsS+U4/qQWvnet4Hqx1QXSOGFCEDNe1D2x9FGt9tOqnK84nsBlbixI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803350; c=relaxed/simple;
	bh=9bjE166TNJ0DKM8bnZA8kBM2F4HephbWK68fBzRnyIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN7Hb7HVe72anepzgIxvZ1ofDfWVVPDy6m7yT3+jUuthp94u1BcXlf8qFjgMZAVaykzH5J7a4XYRp2Eodq/g3aFLK9qS6n03icmcXU3YiOYwokA1bQDpqjRpmKzcAOS8SX8jlPktENZTMTywi2r2NX8mPy9Wotsa5j68onYx/Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyodwWXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyodwWXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE56C2BBFC;
	Wed, 19 Jun 2024 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803350;
	bh=9bjE166TNJ0DKM8bnZA8kBM2F4HephbWK68fBzRnyIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyodwWXIRNx9JTXSjNnl7rQmQ0XwtEu1i8fKWM/WzAyt9hfRj93dkEP/n1DKuWs2u
	 q/i4pwbM1ez2RoccK9Om/SMk/3q0z8+7wdrICjxTB6RxSWjs9zJcO6Vd42+yCeOJK/
	 HmgXhaBfEagrPYNkp8WdOgX7E6JxuSPXoJ8Jjpg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 237/281] fs/proc: fix softlockup in __read_vmcore
Date: Wed, 19 Jun 2024 14:56:36 +0200
Message-ID: <20240619125619.081032433@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


