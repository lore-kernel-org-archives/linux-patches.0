Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B99342511;
	Tue, 16 Dec 2025 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884373; cv=none; b=YHA1DTNUV2ty2a554ONK/S4jSi+F0/sR/ZOYVNHpxxcLU+uTTzpGUHI9wo9EU3wZW3WDVdU+C7tU7xbGHsMUxROU+u9wi/lV9R/mEiKRt78IYhADsxAAUbQlk3gsCyDMKEsD6D2yaylNuc0qYg8OVWJzxEMWWk4YVmSZhTCSNpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884373; c=relaxed/simple;
	bh=A1bDk/qeD5meMJpC0KYtVayuDN9VME5SR3Hw6XIqhq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqgoCBOLFiwA3HGzfWpVCTWwynMaIC4bOEoNdCFT5WohclZ9FkBW1BHO/Quv9HTXeIbO49GkeNxFDBiUXId4tN7Ce4PlbVDtc6d/7WDyislCfNUpH28VncYufl03cqZB80cMK0beuXtUa+knBDTTQx8eD8JlrudLScr0qSbJdNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYJdASob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYJdASob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0B3C4CEF5;
	Tue, 16 Dec 2025 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884372;
	bh=A1bDk/qeD5meMJpC0KYtVayuDN9VME5SR3Hw6XIqhq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYJdASobGojDZ5Hzq8NVMUvxrxVBes34+mpkY1wnGXrxxC93ZxQdrARjyfJDFK9jz
	 QW8feV/N9puJgZb8XjNagFnlKePHEcXmnD0mMo5S+75QaqgEveFOYvO7IRQ6EvmAse
	 aLME6H3c609jOgymtIVwRnNN9GPMvZIvxAMo9cSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirisha G <shirisha@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/354] powerpc/kdump: Fix size calculation for hot-removed memory ranges
Date: Tue, 16 Dec 2025 12:11:47 +0100
Message-ID: <20251216111325.990359074@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



