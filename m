Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21AB30F93B;
	Fri, 21 Nov 2025 13:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731407; cv=none; b=GfWI+OIOG//IySpyLFRFjD4NLcwtGAbkpyMkh5NHT83G4Fjt6DAX19X4kvXp18KuXQ69QTYLJ+sGIJ8cRNmnb/OW5XcgqObfCJfzDVDhYJYhQtC3FR7+gKlucKeVAEl5T+c8pvB3T24R9gMxEmxYnrsANIYASVvIqkvvtYC5qP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731407; c=relaxed/simple;
	bh=iZc/zKU05dwFMYdUNhpQUN/AWRoiPAC+rg3+DLbnz2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjHKhNYCla8DrfqvwidTRlKz3cdQ5X5TGliGh3qsez0etwhDmaOeRFp0LQ59RgVKXomLfG9cGXcT9Yt/mF345rXIUc2BNsx2DWDXOP4MX+xqruUWV62SQzJU+kP9Nol7EtodRf3x0ngLtTG1jG/aHwlwOfz0OABSDRIurIrPSGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LThU1my2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LThU1my2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2632BC116C6;
	Fri, 21 Nov 2025 13:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731407;
	bh=iZc/zKU05dwFMYdUNhpQUN/AWRoiPAC+rg3+DLbnz2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LThU1my2u5MszpNnCLjTkPWdkB5mkiy5wGo7Rv15Hj71ZQhMQhaMKJfGIRdzXZYxV
	 /SmMZdZWv3eyELYZARmZSJjlwt0Vaz1RmyArrapP4guqmvzUVAwA2uA4All+M+X+v9
	 xDkK5jELlSeV3e1yeJSs7XtQkDKb9KsABKWj4s+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Baoquan He <bhe@redhat.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 198/247] crash: fix crashkernel resource shrink
Date: Fri, 21 Nov 2025 14:12:25 +0100
Message-ID: <20251121130201.830397782@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

commit 00fbff75c5acb4755f06f08bd1071879c63940c5 upstream.

When crashkernel is configured with a high reservation, shrinking its
value below the low crashkernel reservation causes two issues:

1. Invalid crashkernel resource objects
2. Kernel crash if crashkernel shrinking is done twice

For example, with crashkernel=200M,high, the kernel reserves 200MB of high
memory and some default low memory (say 256MB).  The reservation appears
as:

cat /proc/iomem | grep -i crash
af000000-beffffff : Crash kernel
433000000-43f7fffff : Crash kernel

If crashkernel is then shrunk to 50MB (echo 52428800 >
/sys/kernel/kexec_crash_size), /proc/iomem still shows 256MB reserved:
af000000-beffffff : Crash kernel

Instead, it should show 50MB:
af000000-b21fffff : Crash kernel

Further shrinking crashkernel to 40MB causes a kernel crash with the
following trace (x86):

BUG: kernel NULL pointer dereference, address: 0000000000000038
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
<snip...>
Call Trace: <TASK>
? __die_body.cold+0x19/0x27
? page_fault_oops+0x15a/0x2f0
? search_module_extables+0x19/0x60
? search_bpf_extables+0x5f/0x80
? exc_page_fault+0x7e/0x180
? asm_exc_page_fault+0x26/0x30
? __release_resource+0xd/0xb0
release_resource+0x26/0x40
__crash_shrink_memory+0xe5/0x110
crash_shrink_memory+0x12a/0x190
kexec_crash_size_store+0x41/0x80
kernfs_fop_write_iter+0x141/0x1f0
vfs_write+0x294/0x460
ksys_write+0x6d/0xf0
<snip...>

This happens because __crash_shrink_memory()/kernel/crash_core.c
incorrectly updates the crashk_res resource object even when
crashk_low_res should be updated.

Fix this by ensuring the correct crashkernel resource object is updated
when shrinking crashkernel memory.

Link: https://lkml.kernel.org/r/20251101193741.289252-1-sourabhjain@linux.ibm.com
Fixes: 16c6006af4d4 ("kexec: enable kexec_crash_size to support two crash kernel regions")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/crash_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -367,7 +367,7 @@ static int __crash_shrink_memory(struct
 		old_res->start = 0;
 		old_res->end   = 0;
 	} else {
-		crashk_res.end = ram_res->start - 1;
+		old_res->end = ram_res->start - 1;
 	}
 
 	crash_free_reserved_phys_range(ram_res->start, ram_res->end);


