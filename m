Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061111;
	b=ZswJui2YPEyf3tXttAgucdjJmIEnFtVqDThc/NA0Ouor2AZDcNjDoiMqXfXoE2YX/cu5
	 p2ahaC575q/Ogn0UonnkZ7zNx8iL8A4HTimx7BjcNCuIasZDUdo+WqxITxPBrzp/QdS8u
	 LD1cOI44KHy5jbDM9kR+PCBVlnBflbWNPTeb+d4uNEzUxpG21yJtercqVltRjo+PY9RHI
	 7EYQwzFe5luq4ZGfGrxQzdymA5EDgRBDjUBhbw3pK285zqov+KTy5mBfDrnrujOUK5hu4
	 6FNavCa3bgRfe+uVHL3osOvJQ9Z2CAMlIY3XHY+24Ke3nPXnLrBAnNB438EJ8Obrmjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VaSi8RMzc2qZGlONdg1b5nL32O4b1yEX5mlSa6b8CqE=;
	b=DMJkZr7x5bwkZVuCjGRTjpO+NN2WflxZOfusIn68E48Hl8589VEQSupDhYqUFUA651zI
	 9ksxnGB+WHHXlpma0HZQCKTD1PV5AkQFGyYoDnxnv305nLx+hABjBl4ecQ+aP2I3lnIyr
	 AtsGq3/ZPzO5C4h/FF75ysRySR/szUAPYtExNdWUnm4Ya3Yrr59yUH2ruMBalb4hbiMeX
	 c2rT9b76x/RHu1WYMDAIsTAskw6Zxn7FzLHI5GTwwNDEHmz0nT/oYze6qfxeefE5jIQy2
	 CIU3yBFewLSoqR3XbMWqx2o+IhvjS0xVG0NoPlDPRHD7Uoe8CzceoUtQgsK3ac4KcXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NgpxAEMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A30606A320;
	Thu, 19 Nov 2026 04:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NgpxAEMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9203A1F000C4;
	Thu, 19 Nov 2026 04:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061111;
	bh=VaSi8RMzc2qZGlONdg1b5nL32O4b1yEX5mlSa6b8CqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgpxAEMh/lEN37WAGG/bwVeGiU/erBcxARIQVPqXFyZsRiejlCas4vvylDd4j0LA4
	 +EPdornOU9Thsys75KuJUUFgLEC4j/0oOhNmd7lr5cxtHbbNlNaY9rAwatQWmFxtw+
	 P1CjRPJIb4yy9uSGJQHyZBf/x0IT/STC70/LHOeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Ricci <io@r-ricci.it>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1419/1848] x86/hibernate: Ignore page-zero RAM in E820 checksum
Date: Wed, 18 Nov 2026 15:57:37 +0100
Message-ID: <20261118150018.886296565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 29671cabfc09afb1ee2426b21173cdde276a95ac ]

The legacy kexec_load path reconstructs the E820 map exported through
sysfs.  kexec-tools leaves the first 1 KiB unavailable for the real-mode
transition, so a kernel entered through kexec_load can see conventional
RAM starting at 0x400.  A subsequent firmware boot reports the same RAM
range starting at zero.

The hibernation E820 checksum compares those byte representations and
rejects the image, even though the maps agree from page one onwards.
A QEMU guest showed this transition:

  firmware:     RAM [0-0x9fbff]
  kexec_load:   gap [0-0x3ff], RAM [0x400-0x9fbff]
  firmware:     RAM [0-0x9fbff]

The checksum covers e820_table_firmware, which trim_bios_range() leaves
alone.  The nosave regions come from e820_table instead, where
trim_bios_range() has already turned conventional RAM in page zero into
reserved memory, so page zero never occurs in the image, whatever the
firmware map says about it.

Canonicalise only the conventional-RAM portion below PAGE_SIZE before
calculating the checksum.  Preserve RESERVED, ACPI, NVS, UNUSABLE, PMEM
and all other E820 types so that changes to exceptional mappings remain
detectable.

This is deliberately narrower than Marco Scardovi's June proposal to
checksum only RAM and its opt-in relaxed_memmap successor.  Rafael
noted that ignoring non-RAM changes could hide moved ACPI or UEFI
regions still used by the resumed kernel.  This patch preserves every
non-RAM entry and ignores only RAM within page zero, which common setup
already reserves and excludes from the image.

Bump RESTORE_MAGIC, since the checksum semantics change, so that an
image written by a kernel without this change is refused by the magic
check instead of being compared under different rules.

In the same guest, with the page-zero difference kept, hibernation and
resume now work after both a direct boot and a kexec_load boot.  An
image written by an unpatched kernel is refused at resume with
"Unrecognized hibernate image header format!", and the firmware-booted
kernel carries on.

Fixes: 62a03defeabd ("PM / hibernate: Verify the consistent of e820 memory map by md5 digest")
Reported-by: Roberto Ricci <io@r-ricci.it>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://lore.kernel.org/all/Z-hYWc9LtBU1Yhtg@desktop0a/
Link: https://lists.openwall.net/linux-kernel/2025/04/04/1372
Link: https://lore.kernel.org/all/CAJZ5v0jmOj0WBtMTvbnaD+2b0bTFowA=JWrqRzaaCYpHpai1Nw@mail.gmail.com/
Link: https://lore.kernel.org/all/20260623165724.10753-1-scardracs@disroot.org/
Link: https://patch.msgid.link/20260926052117.3613637-1-matthias.goergens@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/power/hibernate.c | 51 +++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
index e94e0050a583a..7391da986d938 100644
--- a/arch/x86/power/hibernate.c
+++ b/arch/x86/power/hibernate.c
@@ -62,6 +62,25 @@ struct restore_data_record {
 	unsigned long e820_checksum;
 };
 
+static bool trim_e820_page_zero_ram(struct e820_entry *entry)
+{
+	u64 lowmem_size;
+
+	/*
+	 * Page zero is BIOS-owned and registered as nosave.  Boot loaders may
+	 * therefore omit part of its conventional RAM entry without changing
+	 * any memory available to the image.  Preserve all other E820 types.
+	 */
+	if (entry->type != E820_TYPE_RAM || entry->addr >= PAGE_SIZE)
+		return true;
+
+	lowmem_size = min_t(u64, entry->size, PAGE_SIZE - entry->addr);
+	entry->addr += lowmem_size;
+	entry->size -= lowmem_size;
+
+	return entry->size;
+}
+
 /**
  * compute_e820_crc32 - calculate crc32 of a given e820 table
  *
@@ -69,18 +88,38 @@ struct restore_data_record {
  *
  * Return: the resulting checksum
  */
-static inline u32 compute_e820_crc32(struct e820_table *table)
+static u32 compute_e820_crc32(struct e820_table *table)
 {
-	int size = offsetof(struct e820_table, entries) +
-		sizeof(struct e820_entry) * table->nr_entries;
+	struct e820_entry entry;
+	u32 crc = ~0;
+	u32 nr_entries = 0;
+	u32 i;
+
+	for (i = 0; i < table->nr_entries; i++) {
+		entry = table->entries[i];
+		if (trim_e820_page_zero_ram(&entry))
+			nr_entries++;
+	}
+
+	crc = crc32_le(crc, (unsigned char const *)&nr_entries,
+		       sizeof(nr_entries));
+
+	for (i = 0; i < table->nr_entries; i++) {
+		entry = table->entries[i];
+		if (!trim_e820_page_zero_ram(&entry))
+			continue;
+
+		crc = crc32_le(crc, (unsigned char const *)&entry,
+			       sizeof(entry));
+	}
 
-	return ~crc32_le(~0, (unsigned char const *)table, size);
+	return ~crc;
 }
 
 #ifdef CONFIG_X86_64
-#define RESTORE_MAGIC	0x23456789ABCDEF02UL
+#define RESTORE_MAGIC	0x23456789ABCDEF03UL
 #else
-#define RESTORE_MAGIC	0x12345679UL
+#define RESTORE_MAGIC	0x1234567AUL
 #endif
 
 /**
-- 
2.53.0



