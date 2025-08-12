Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349C92F745E;
	Tue, 12 Aug 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021924; cv=none; b=Tp5bihN2kwuYEWDR236IoSDFaybiTSr5evwxm12H1+we+hL0Ye7q/CtRUSfjFIMb5ZtZy34GJkBybWGFJRSCar/OOc3Ykaqks38omO65XFMuJos/QlJkdCMvv08+QmhFbcBrOHdb0CLI6tEA+GI6p08lMQFeftpis+0/3x3/dGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021924; c=relaxed/simple;
	bh=B1LUs22AAF9ZXm49kRSDiFiv1eUx8eGuA03xx+75f4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UonDFQRdouOrKplxvtWumF/U8LtP0ssyg2k4QPH2cwxUQ7QUbCKroOqEHfp67a79JffNZ7lVo6FFETsTnjt7g0aSfPvW/RxoDmPhgRRlArz1YLQKVubnbZGV8uUnqjTThqSa90v/xErkptm9iZVbFUb7kJGzBfnze/CWkgAISGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdCVJzI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdCVJzI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2B6C4CEF0;
	Tue, 12 Aug 2025 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021924;
	bh=B1LUs22AAF9ZXm49kRSDiFiv1eUx8eGuA03xx+75f4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdCVJzI10BvaEFSq7ZuXWxRHhewPtUDGlqrDNEUQBVB/QUOw5UkxZt85xaP+WlBM3
	 j5DlvvkEHDoDtvDDOHKAhp/LUB83Qg4YUbGAd2c59WlVFLEQr4KRfDB5MLfGXr2aT0
	 Rt6fVlb912DzSbCIyKuSccUGVixP5P4PQq8rvx80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.6 232/262] perf/core: Exit early on perf_mmap() fail
Date: Tue, 12 Aug 2025 19:30:20 +0200
Message-ID: <20250812173003.036805141@linuxfoundation.org>
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

commit 07091aade394f690e7b655578140ef84d0e8d7b0 upstream.

When perf_mmap() fails to allocate a buffer, it still invokes the
event_mapped() callback of the related event. On X86 this might increase
the perf_rdpmc_allowed reference counter. But nothing undoes this as
perf_mmap_close() is never called in this case, which causes another
reference count leak.

Return early on failure to prevent that.

Fixes: 1e0fb9ec679c ("perf/core: Add pmu callbacks to track event mapping and unmapping")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6718,6 +6718,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.


