Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C563B2F745E;
	Tue, 12 Aug 2025 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021920; cv=none; b=deeHPluRKv092vVeNhfFDUWmIdiHF1k2vVsQfFyAcgzhBw+7X/rGqzXGv3JpEgtLUgtWxTby7cIvFBCO8qQxQoc9TaCfXDNrlHOwwn3EHE9h5UptgOQklRW7kUXctvyH8aEbm383f3TKpo7gv2yK8222HvVgHKg/Qe24DssfFjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021920; c=relaxed/simple;
	bh=R8/RXqzNzc/FSAPYd19zIw59XP2o5ZDptC9q8nE1B64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSCllZQ8aV20g3LRIMvoSERLLDy1ePYg1lfJwDRoN6f12MhfMiDXzggjpM1Tau+5XX5a3sl9oxFwVsSt5A0nLtNpizDSh6q4tB/e8Y7/H4hmULyVUaAuuPkqP1jwoF1rXiPAYhKkPYcj/HReInKTAlacNHMIjGth61bl8qkLf8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDWzX7Dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDWzX7Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F5C4CEF0;
	Tue, 12 Aug 2025 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021920;
	bh=R8/RXqzNzc/FSAPYd19zIw59XP2o5ZDptC9q8nE1B64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDWzX7DqVELh0t+ZaQxbuvKhmLbxDH0UKoNhZBQoxF0MXXSeJkfoYBsRkMa8ZgkDe
	 er8ysBW4klPZ3ngSyzS2HhnhBzmAh58YdQh3tSYc58ACjcddb3z/wIp0rrOlnY1U6s
	 6VORrXNCQ+lPbOGK8A6+L/8DNz/f3AP41kuFQO+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.6 231/262] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 12 Aug 2025 19:30:19 +0200
Message-ID: <20250812173002.996107717@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6595,9 +6595,7 @@ static int perf_mmap(struct file *file,
 			goto unlock;
 		}
 
-		atomic_set(&rb->aux_mmap_count, 1);
 		user_extra = nr_pages;
-
 		goto accounting;
 	}
 
@@ -6699,8 +6697,10 @@ accounting:
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
@@ -6710,6 +6710,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:


