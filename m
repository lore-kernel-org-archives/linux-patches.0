Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F8B1ADC83;
	Mon,  4 May 2026 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903822; cv=none; b=Z3xakvYQpaYiORAlMmHb91ygmKv1b2bVOKHtjmaBwuL/hleBA+ryv2JBmSAxpgMfgMC0dYTX60g2xfurCL4/xHI8dk39tZkeTA7z3l8prp0aTZnNM02nFr3vAh/hqv/94sjkye6GIEmjZQ8P/RpULEt4ZKv9juRReNMkbZ7O9Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903822; c=relaxed/simple;
	bh=2HHmbxcW8v0HWcA1NeN3G1Z8jdN8Ew6d+sxtjeoDmSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/ar45C4KD0aT/qygSYEUPthVBP9BKVf7Zwtvx5m9J8sSY89f8OCaDOKBe6jprw9QqawfnMv3hGgiSfxKep4xXbdGAZgDAqCL1qla2UKZIgYxdLPVE5fTTJylY5wt4L8+a6f0VQvcNFEuApeJ2cDrV4K8O7OnvXFjQ80cMwQyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrCgLEo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrCgLEo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09864C2BCB8;
	Mon,  4 May 2026 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903822;
	bh=2HHmbxcW8v0HWcA1NeN3G1Z8jdN8Ew6d+sxtjeoDmSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrCgLEo5oSTxnqvtUQvvZaCQkZGmECjQnE0kNuG+tYeIjGCgQcHC/d4ZZZF0BrmUX
	 1gbB8Lm2Q6J/NZc7aLEHshOmssgLYjTsx/rdkoCz657MTCVmo2cCLd5Wo4OQkMeEHU
	 5JkuEXqxl88zvY2oEfUVVz/QCDw+F6GS+sJiZGBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 075/275] mm/hugetlb: fix early boot crash on parameters without = separator
Date: Mon,  4 May 2026 15:50:15 +0200
Message-ID: <20260504135145.714071924@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit c45b354911d01565156e38d7f6bc07edb51fc34c upstream.

If hugepages, hugepagesz, or default_hugepagesz are specified on the
kernel command line without the '=' separator, early parameter parsing
passes NULL to hugetlb_add_param(), which dereferences it in strlen() and
can crash the system during early boot.

Reject NULL values in hugetlb_add_param() and return -EINVAL instead.

Link: https://lore.kernel.org/20260409105437.108686-4-thorsten.blum@linux.dev
Fixes: 5b47c02967ab ("mm/hugetlb: convert cmdline parameters from setup to early")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4787,6 +4787,9 @@ static __init int hugetlb_add_param(char
 	size_t len;
 	char *p;
 
+	if (!s)
+		return -EINVAL;
+
 	if (hugetlb_param_index >= HUGE_MAX_CMDLINE_ARGS)
 		return -EINVAL;
 


