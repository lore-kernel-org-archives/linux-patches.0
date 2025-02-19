Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533FE1EB1B0;
	Wed, 19 Feb 2025 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954297; cv=none; b=FG1zNLQe0T519ehPgUzhXW35fB5oqcuY4NbT+3v9HMjFHYQeYj+txJSj7ONawE9Lxh+PZwczTfkSkBNZLNH9PEeqQK8vvIUHzi8b8MjdMPn/fe0So/WOCA+p0ADNhAZQwtwzRrdb5JuYsFvIC900bM2mUk07wq8KHhpg60km/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954297; c=relaxed/simple;
	bh=Gfut2vLvpWMdZpLWkIoeCweSMjjAt3C56mjK7NddSTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phsZlqBPXyCBV8ke/qkuQ4EZ8Q7n6Q8Yjf6hckbDIjNZtQ4c60Qfho3yRLQJzF9qvqsCDQs1YZiqjaw5G9FvzBboHdUelCunI1ynyO3ZHRU79pfNqb2KMMHaxsGV20UMbbMUWvsgfz3Z+2UxbMxjH9ayUkeHD/+EFhsbUOyCYxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdO+HcrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdO+HcrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AB8C4CEE7;
	Wed, 19 Feb 2025 08:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954296;
	bh=Gfut2vLvpWMdZpLWkIoeCweSMjjAt3C56mjK7NddSTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdO+HcrVa4/1kV6AAYtOpXzJdYke1m8Gwnb568F9fhi8/HGBpVGHwGzeATnrBfeod
	 rFExKrCDdymY5GXmI3rMLLnlffynAuVT2pCNb0SQ6yybO2fAWuQeXVFzzi7ZCs/9Q7
	 n1oIzUr8FTLAYHW3MQ7ydRD4KM7hlFbQcCJTuiaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.13 159/274] efi: Avoid cold plugged memory for placing the kernel
Date: Wed, 19 Feb 2025 09:26:53 +0100
Message-ID: <20250219082615.818368530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit ba69e0750b0362870294adab09339a0c39c3beaf upstream.

UEFI 2.11 introduced EFI_MEMORY_HOT_PLUGGABLE to annotate system memory
regions that are 'cold plugged' at boot, i.e., hot pluggable memory that
is available from early boot, and described as system RAM by the
firmware.

Existing loaders and EFI applications running in the boot context will
happily use this memory for allocating data structures that cannot be
freed or moved at runtime, and this prevents the memory from being
unplugged. Going forward, the new EFI_MEMORY_HOT_PLUGGABLE attribute
should be tested, and memory annotated as such should be avoided for
such allocations.

In the EFI stub, there are a couple of occurrences where, instead of the
high-level AllocatePages() UEFI boot service, a low-level code sequence
is used that traverses the EFI memory map and carves out the requested
number of pages from a free region. This is needed, e.g., for allocating
as low as possible, or for allocating pages at random.

While AllocatePages() should presumably avoid special purpose memory and
cold plugged regions, this manual approach needs to incorporate this
logic itself, in order to prevent the kernel itself from ending up in a
hot unpluggable region, preventing it from being unplugged.

So add the EFI_MEMORY_HOTPLUGGABLE macro definition, and check for it
where appropriate.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c                 |    6 ++++--
 drivers/firmware/efi/libstub/randomalloc.c |    3 +++
 drivers/firmware/efi/libstub/relocate.c    |    3 +++
 include/linux/efi.h                        |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -937,13 +937,15 @@ char * __init efi_md_typeattr_format(cha
 		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
 		     EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
 		     EFI_MEMORY_NV | EFI_MEMORY_SP | EFI_MEMORY_CPU_CRYPTO |
-		     EFI_MEMORY_RUNTIME | EFI_MEMORY_MORE_RELIABLE))
+		     EFI_MEMORY_MORE_RELIABLE | EFI_MEMORY_HOT_PLUGGABLE |
+		     EFI_MEMORY_RUNTIME))
 		snprintf(pos, size, "|attr=0x%016llx]",
 			 (unsigned long long)attr);
 	else
 		snprintf(pos, size,
-			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
 			 attr & EFI_MEMORY_RUNTIME		? "RUN" : "",
+			 attr & EFI_MEMORY_HOT_PLUGGABLE	? "HP"  : "",
 			 attr & EFI_MEMORY_MORE_RELIABLE	? "MR"  : "",
 			 attr & EFI_MEMORY_CPU_CRYPTO   	? "CC"  : "",
 			 attr & EFI_MEMORY_SP			? "SP"  : "",
--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -25,6 +25,9 @@ static unsigned long get_entry_num_slots
 	if (md->type != EFI_CONVENTIONAL_MEMORY)
 		return 0;
 
+	if (md->attribute & EFI_MEMORY_HOT_PLUGGABLE)
+		return 0;
+
 	if (efi_soft_reserve_enabled() &&
 	    (md->attribute & EFI_MEMORY_SP))
 		return 0;
--- a/drivers/firmware/efi/libstub/relocate.c
+++ b/drivers/firmware/efi/libstub/relocate.c
@@ -53,6 +53,9 @@ efi_status_t efi_low_alloc_above(unsigne
 		if (desc->type != EFI_CONVENTIONAL_MEMORY)
 			continue;
 
+		if (desc->attribute & EFI_MEMORY_HOT_PLUGGABLE)
+			continue;
+
 		if (efi_soft_reserve_enabled() &&
 		    (desc->attribute & EFI_MEMORY_SP))
 			continue;
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -128,6 +128,7 @@ typedef	struct {
 #define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */
 #define EFI_MEMORY_SP		((u64)0x0000000000040000ULL)	/* soft reserved */
 #define EFI_MEMORY_CPU_CRYPTO	((u64)0x0000000000080000ULL)	/* supports encryption */
+#define EFI_MEMORY_HOT_PLUGGABLE	BIT_ULL(20)	/* supports unplugging at runtime */
 #define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 


