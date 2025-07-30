Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D54293C6F;
	Wed, 30 Jul 2025 09:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868890; cv=none; b=lMftrh1S86HoErmwh5Tj3T6XHoLQ8421W46np+SZIRqqg19lbfUvMrPqQ1YbmuFftQwMGV2hjWtdGhKiZYujZMApINxW/99/H6YfFfRS0UWbg6prOBlGBS3gv0u9tKjW0oRCKwGvI8yaI29h9luj8qLCYOEVgm1IxWkbCPrTG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868890; c=relaxed/simple;
	bh=E7ur4lpl+H06uO3uEIumj56OwO+ruboDesYQWrqUJXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlB7MS9TX7Idvjh7pneAKpD9Inzh0qogZ8WtgxlKOZDZ5IQe/90cIjqkZHIQYiCFQ7AWuhvXR9pqYIqimRd6ucMPH1h/k5wfr2swzpQ3z9AhzFb9oTMHqHOuBBXJT5VQCKPrdk1oN9SwpTFKZwQjaHfv4NBpPvOe94s78QIW5lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYTobutC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYTobutC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5B6C4CEF6;
	Wed, 30 Jul 2025 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868890;
	bh=E7ur4lpl+H06uO3uEIumj56OwO+ruboDesYQWrqUJXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYTobutC6OKUsd4N5/Uj+SCOVtqBERvSWZDd+nUflCXS+7VHRP5kiKy6WCH+DBkmq
	 EQyJjXtkvgLhMBK07vrW9K+PnwmxqgURWSdFZzuo8UJpEtUEgkXfVitWI4yOgLxdLr
	 HFDrnyZ0+1pGf7evUuz6Udq6F7bbyXidxRGhwHrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 062/117] resource: fix false warning in __request_region()
Date: Wed, 30 Jul 2025 11:35:31 +0200
Message-ID: <20250730093235.961712525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 91a229bb7ba86b2592c3f18c54b7b2c5e6fe0f95 upstream.

A warning is raised when __request_region() detects a conflict with a
resource whose resource.desc is IORES_DESC_DEVICE_PRIVATE_MEMORY.

But this warning is only valid for iomem_resources.
The hmem device resource uses resource.desc as the numa node id, which can
cause spurious warnings.

This warning appeared on a machine with multiple cxl memory expanders.
One of the NUMA node id is 6, which is the same as the value of
IORES_DESC_DEVICE_PRIVATE_MEMORY.

In this environment it was just a spurious warning, but when I saw the
warning I suspected a real problem so it's better to fix it.

This change fixes this by restricting the warning to only iomem_resource.
This also adds a missing new line to the warning message.

Link: https://lkml.kernel.org/r/20250719112604.25500-1-akinobu.mita@gmail.com
Fixes: 7dab174e2e27 ("dax/hmem: Move hmem device registration to dax_hmem.ko")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/resource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1268,8 +1268,9 @@ static int __request_region_locked(struc
 		 * become unavailable to other users.  Conflicts are
 		 * not expected.  Warn to aid debugging if encountered.
 		 */
-		if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
-			pr_warn("Unaddressable device %s %pR conflicts with %pR",
+		if (parent == &iomem_resource &&
+		    conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
+			pr_warn("Unaddressable device %s %pR conflicts with %pR\n",
 				conflict->name, conflict, res);
 		}
 		if (conflict != parent) {


