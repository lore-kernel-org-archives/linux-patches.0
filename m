Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5D34405B;
	Tue, 16 Dec 2025 12:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887589; cv=none; b=sVAGA+Yt/kKcP3LsVv8lRpDAs3eybXxyZO/4oIe+CH4qeJvvUqRdWC4Lo69zrMXwQR4Puox3rzXAAr7UmO9jxwjvEIv+yBnUbr/O00E7omjE9waQbQwN12O0g/YXxI0iwz+SYSgUlxc/N3E4mfq1glRpdsQYW1N8TAHZA95a/8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887589; c=relaxed/simple;
	bh=yf1yNu/0BENn7bUS4ANMPW7OqOfS/VN2kDaL9509ydE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnUetuwKlS7n5AbGgpnI42GA0QxL4A6giN9LBIlwpOsIki+j9J75OL2xQhF3L+zB6Qc/Q7GYYc2BOH5OH6dz4uy3keZl/8BawQxnKekXcYh0p/B3FLQUmPYdUJ+CsnR/m3rVGQWhy5BA/tNZktDw3sjevHEFadLLIsJD0z02RFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcC1GCiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcC1GCiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66929C4CEF1;
	Tue, 16 Dec 2025 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887588;
	bh=yf1yNu/0BENn7bUS4ANMPW7OqOfS/VN2kDaL9509ydE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcC1GCiGjuOqgE11AAC8+rcTEkWznzpApsMbmj9cCSHmLVVsisGkK01u9Gy0hHuJg
	 JoC/O2gV23En0g9yVSVbXDNFC0s8Cjot2vl+675cfO1OMeI3A+jQ4hMD+PwMpTo1jI
	 ZsgM7lWXM5UwL8Rc2bRVfD4G2aMi5TDFtvJ+yJY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirisha G <shirisha@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/614] powerpc/kdump: Fix size calculation for hot-removed memory ranges
Date: Tue, 16 Dec 2025 12:10:11 +0100
Message-ID: <20251216111410.207356364@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 7afe2383eff05f76f4ce2cfda658b7889c89f101 ]

The elfcorehdr segment in the kdump image stores information about the
memory regions (called crash memory ranges) that the kdump kernel must
capture.

When a memory hot-remove event occurs, the kernel regenerates the
elfcorehdr for the currently loaded kdump image to remove the
hot-removed memory from the crash memory ranges.

Call chain:
remove_mem_range()
update_crash_elfcorehdr()
arch_crash_handle_hotplug_event()
crash_handle_hotplug_event()

While removing the hot-removed memory from the crash memory ranges in
remove_mem_range(), if the removed memory lies within an existing crash
range, that range is split into two. During this split, the size of the
second range was being calculated incorrectly.

This leads to dump capture failure with makedumpfile with below error:

$ makedumpfile -l -d 31 /proc/vmcore /tmp/vmcore

readpage_elf: Attempt to read non-existent page at 0xbbdab0000.
readmem: type_addr: 0, addr:c000000bbdab7f00, size:16
validate_mem_section: Can't read mem_section array.
readpage_elf: Attempt to read non-existent page at 0xbbdab0000.
readmem: type_addr: 0, addr:c000000bbdab7f00, size:8
get_mm_sparsemem: Can't get the address of mem_section.

The updated crash memory range in PT_LOAD entry is holding incorrect
data (checkout FileSiz and MemSiz):

readelf -a /proc/vmcore
<snip...>
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000b013d0000 0xc000000b80000000 0x0000000b80000000
                 0xffffffffc0000000 0xffffffffc0000000  RWE    0x0
<snip...>

Update the size calculation for the new crash memory range to fix this
issue.

Note: This problem will not occur if the kdump kernel is loaded or
reloaded after a memory hot-remove operation.

Fixes: 849599b702ef ("powerpc/crash: add crash memory hotplug support")
Reported-by: Shirisha G <shirisha@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251105033941.1752287-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/ranges.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/ranges.c b/arch/powerpc/kexec/ranges.c
index 3702b0bdab141..426bdca4667e7 100644
--- a/arch/powerpc/kexec/ranges.c
+++ b/arch/powerpc/kexec/ranges.c
@@ -697,8 +697,8 @@ int remove_mem_range(struct crash_mem **mem_ranges, u64 base, u64 size)
 		 * two half.
 		 */
 		else {
+			size = mem_rngs->ranges[i].end - end + 1;
 			mem_rngs->ranges[i].end = base - 1;
-			size = mem_rngs->ranges[i].end - end;
 			ret = add_mem_range(mem_ranges, end + 1, size);
 		}
 	}
-- 
2.51.0



