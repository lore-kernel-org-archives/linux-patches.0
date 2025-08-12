Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179F8221FAC;
	Tue, 12 Aug 2025 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021234; cv=none; b=Kc+BErdA55j2hlYmeZkGg8bzwodzwJ7Ugqb8qKxPlZ/1PAp219/0y54OGz9J+IvoeObw/Iqmfklh4iKCDp85xk/5RawCRThShTwgUUEqSIMpSFVjdybarMk0YDnfKTqFSm8Jxb30aGURo4oeH3RD67+WICt+5oTCwcaWwkoQxrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021234; c=relaxed/simple;
	bh=jMabyCC+3J+0Rm2epn1ZzXtK1Soj5Nu+RGJlmvwyPtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouCYcNainAFsrnaMHt3AKz5aEJD/qlvnt4y4WPmZEi7eUVx+aBI7zlr5zbkfOZPDDxcimAGg8mBOBoBvDKOT8yDqaSMhAhpTKFiy1xq+FeSoby0U6h5mH+WrkQ4y2/CEoNv2dWiO4lQn2xjk24GmJedgNGnCHClyG/UCGdyx93E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b99fRsdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b99fRsdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF39C4CEF0;
	Tue, 12 Aug 2025 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021234;
	bh=jMabyCC+3J+0Rm2epn1ZzXtK1Soj5Nu+RGJlmvwyPtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b99fRsdwvN3qaxlGXpP0Vr8BrMjHikioaA8BXOfSNSsEmoWwzPtM0IH+6FHolYfZm
	 6WatBkInzxVnEqyFi8Wg9MD+tlLafCtjJeAAA4yabkd05huiGhWTn+sZexzIvI3CYs
	 kDEL7UbbmWTZ5Fdh/k9j5sx4V8FfkyZg0XlYWpUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.1 233/253] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 12 Aug 2025 19:30:21 +0200
Message-ID: <20250812172958.743385730@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5468c0fbccbb9d156522c50832244a8b722374fb upstream.

Failure of the AUX buffer allocation leaks the reference count.

Set the reference count to 1 only when the allocation succeeds.

Fixes: 45bfb2e50471 ("perf/core: Add AUX area to ring buffer for raw data streams")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6381,9 +6381,7 @@ static int perf_mmap(struct file *file,
 			goto unlock;
 		}
 
-		atomic_set(&rb->aux_mmap_count, 1);
 		user_extra = nr_pages;
-
 		goto accounting;
 	}
 
@@ -6485,8 +6483,10 @@ accounting:
 	} else {
 		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
 				   event->attr.aux_watermark, flags);
-		if (!ret)
+		if (!ret) {
+			atomic_set(&rb->aux_mmap_count, 1);
 			rb->aux_mmap_locked = extra;
+		}
 	}
 
 unlock:
@@ -6496,6 +6496,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:


