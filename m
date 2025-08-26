Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECCF3570C3;
	Tue, 26 Aug 2025 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217543; cv=none; b=eYapIUQuuHelGeFOB2xNaKAG0TV0e7UMoAaikpIZVDpX8XUk7ufWrf+FY9Cfj1zwMawx/vVnbvEIH0zjtXqybQ8uAsFlONFDXZnuuL5pfXXg5Q08Kg3zDWc7NpYhPo5vmDAAWhnUewLeHZ1UB3+qm2IN2KoYeOgTaM5+Gt2S4As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217543; c=relaxed/simple;
	bh=Zz22X1dCoNMir2G1018J6kgmm72/SFJ4HWd9H0pMNDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJjDV9QHFVCXVIBuX9amhWa5QR2wrM4hrGWrA0FvWNxKcpwCTlslFtg09v72MD3bhusXQEgbeOhJYg0ngQrg6OVVhDvJ6Cr/R+NmJsvA+8xNGA311Z3ncU+eDMOVF/lLHZN77Crx4EOEiovIkMgPA5PSkemHMl20ndFHkhL95j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6B+uq66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6B+uq66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85350C4CEF1;
	Tue, 26 Aug 2025 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217542;
	bh=Zz22X1dCoNMir2G1018J6kgmm72/SFJ4HWd9H0pMNDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6B+uq66Nupet0FuqO2Sy8P9+Wn7dS22wqCGnGb5Qcc2NSohKvpgMJoL2Zb0kAdg8
	 kjnax2GqpiNqTD7GkA2eAvoneGyPJAcB5BzkvQovbdHj5aPjVjzKR0HmtvTbm9s59U
	 QZEiLC+sACAZtfMDKsaug7KqU/s5pxzvYMAIBU8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.10 183/523] perf/core: Dont leak AUX buffer refcount on allocation failure
Date: Tue, 26 Aug 2025 13:06:33 +0200
Message-ID: <20250826110928.968930080@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6290,9 +6290,7 @@ static int perf_mmap(struct file *file,
 			goto unlock;
 		}
 
-		atomic_set(&rb->aux_mmap_count, 1);
 		user_extra = nr_pages;
-
 		goto accounting;
 	}
 
@@ -6394,8 +6392,10 @@ accounting:
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
@@ -6405,6 +6405,7 @@ unlock:
 
 		atomic_inc(&event->mmap_count);
 	} else if (rb) {
+		/* AUX allocation failed */
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:


