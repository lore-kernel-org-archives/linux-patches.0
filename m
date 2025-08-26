Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0840734320F;
	Tue, 26 Aug 2025 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216001; cv=none; b=TA+MT7o5y+T4Dkx1vQgKXpsH9DO8RYCwRERCW0D3KeVcHSs1WKa+dplzOBreUymyE9e9bMTeEMwKK/2UKuqdQiS4G7fcjoIWC8hK9VqjBahkBW2mx+p1ym01LHd2YsC2m4TcYlJRZPSRxHIS8CFTHnFO9o8ZQ9V71m9ETyrdyCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216001; c=relaxed/simple;
	bh=47xnqZlebzd1oD3/pJpCaXJ9JKDGBr5T/XMKYtuFs6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmPScN3PpKZaB8pUY3lCZuVHHU7rBeQNfR96aH1omxstroofEz63oSZeHerW/IsYA/E2dUcKesnZ2C785TA4/AH1GdevGbiHxZXUbzxguGX1A56zoDWpGnRdbbtH2MJnG9VZtbkIV7WDMj5aUmZBF3WTnZ8MxEGNKo+oealtea0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkapVUv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkapVUv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E74C116D0;
	Tue, 26 Aug 2025 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216000;
	bh=47xnqZlebzd1oD3/pJpCaXJ9JKDGBr5T/XMKYtuFs6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkapVUv1Sojl3ARQ3BlEyoMSqGA8uQW3glJAXImuBKlaWIh2XQKGnHlqanvB6hNCX
	 MoyNdZ7gz7Jq4kKNoCMYbADoRMNDh1DjeHRBm/0h6vwhDFcqyBHQEn9diQeCwOEWiB
	 h+dKBTS1rNjOhqUz1iYtsUyJNDje/9ALra+9TLBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.15 246/644] perf/core: Exit early on perf_mmap() fail
Date: Tue, 26 Aug 2025 13:05:37 +0200
Message-ID: <20250826110952.487730091@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6600,6 +6600,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.


