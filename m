Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A33A37325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D09C433D2;
	Wed,  7 Jun 2023 20:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170824;
	bh=EGkwwfJzNJGsuitcSuVeSs5mdMRq3VFlFP0xF+q3g38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEP3F5t/XvN5uZIKwBwwymvbB/YKHzhIUbo/nI+2D0oEaULMVSc+Q53lXzhtbj2aq
	 GtVay/eskRVrgA0iq6F4YahBzFKav3Rw92cuSVJp41iZAHTtzjue/mdilDnIILBrM9
	 UJioIkGQtBYiVwvT61j2INv3ACFKixNNLHP1OJKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <andrea.righi@canonical.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Subject: [PATCH 6.1 221/225] arm64: efi: Use SMBIOS processor version to key off Ampere quirk
Date: Wed,  7 Jun 2023 22:16:54 +0200
Message-ID: <20230607200921.600971596@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

commit eb684408f3ea4856639675d6465f0024e498e4b1 upstream.

Instead of using the SMBIOS type 1 record 'family' field, which is often
modified by OEMs, use the type 4 'processor ID' and 'processor version'
fields, which are set to a small set of probe-able values on all known
Ampere EFI systems in the field.

Fixes: 550b33cfd4452968 ("arm64: efi: Force the use of ...")
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |   39 ++++++++++++++++++++++------
 drivers/firmware/efi/libstub/efistub.h    |   41 +++++++++++++++++++++++++++---
 drivers/firmware/efi/libstub/smbios.c     |   13 ++++++++-
 3 files changed, 80 insertions(+), 13 deletions(-)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -17,20 +17,43 @@
 
 static bool system_needs_vamap(void)
 {
-	const u8 *type1_family = efi_get_smbios_string(1, family);
+	const struct efi_smbios_type4_record *record;
+	const u32 __aligned(1) *socid;
+	const u8 *version;
 
 	/*
 	 * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
-	 * SetVirtualAddressMap() has not been called prior.
+	 * SetVirtualAddressMap() has not been called prior. Most Altra systems
+	 * can be identified by the SMCCC soc ID, which is conveniently exposed
+	 * via the type 4 SMBIOS records. Otherwise, test the processor version
+	 * field. eMAG systems all appear to have the processor version field
+	 * set to "eMAG".
 	 */
-	if (!type1_family || (
-	    strcmp(type1_family, "eMAG") &&
-	    strcmp(type1_family, "Altra") &&
-	    strcmp(type1_family, "Altra Max")))
+	record = (struct efi_smbios_type4_record *)efi_get_smbios_record(4);
+	if (!record)
 		return false;
 
-	efi_warn("Working around broken SetVirtualAddressMap()\n");
-	return true;
+	socid = (u32 *)record->processor_id;
+	switch (*socid & 0xffff000f) {
+		static char const altra[] = "Ampere(TM) Altra(TM) Processor";
+		static char const emag[] = "eMAG";
+
+	default:
+		version = efi_get_smbios_string(&record->header, 4,
+						processor_version);
+		if (!version || (strncmp(version, altra, sizeof(altra) - 1) &&
+				 strncmp(version, emag, sizeof(emag) - 1)))
+			break;
+
+		fallthrough;
+
+	case 0x0a160001:	// Altra
+	case 0x0a160002:	// Altra Max
+		efi_warn("Working around broken SetVirtualAddressMap()\n");
+		return true;
+	}
+
+	return false;
 }
 
 efi_status_t check_platform_features(void)
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -983,6 +983,8 @@ struct efi_smbios_record {
 	u16	handle;
 };
 
+const struct efi_smbios_record *efi_get_smbios_record(u8 type);
+
 struct efi_smbios_type1_record {
 	struct efi_smbios_record	header;
 
@@ -996,13 +998,46 @@ struct efi_smbios_type1_record {
 	u8				family;
 };
 
-#define efi_get_smbios_string(__type, __name) ({			\
+struct efi_smbios_type4_record {
+	struct efi_smbios_record	header;
+
+	u8				socket;
+	u8				processor_type;
+	u8				processor_family;
+	u8				processor_manufacturer;
+	u8				processor_id[8];
+	u8				processor_version;
+	u8				voltage;
+	u16				external_clock;
+	u16				max_speed;
+	u16				current_speed;
+	u8				status;
+	u8				processor_upgrade;
+	u16				l1_cache_handle;
+	u16				l2_cache_handle;
+	u16				l3_cache_handle;
+	u8				serial_number;
+	u8				asset_tag;
+	u8				part_number;
+	u8				core_count;
+	u8				enabled_core_count;
+	u8				thread_count;
+	u16				processor_characteristics;
+	u16				processor_family2;
+	u16				core_count2;
+	u16				enabled_core_count2;
+	u16				thread_count2;
+	u16				thread_enabled;
+};
+
+#define efi_get_smbios_string(__record, __type, __name) ({		\
 	int size = sizeof(struct efi_smbios_type ## __type ## _record);	\
 	int off = offsetof(struct efi_smbios_type ## __type ## _record,	\
 			   __name);					\
-	__efi_get_smbios_string(__type, off, size);			\
+	__efi_get_smbios_string((__record), __type, off, size);		\
 })
 
-const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize);
+const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
+				  u8 type, int offset, int recsize);
 
 #endif
--- a/drivers/firmware/efi/libstub/smbios.c
+++ b/drivers/firmware/efi/libstub/smbios.c
@@ -22,19 +22,28 @@ struct efi_smbios_protocol {
 	u8 minor_version;
 };
 
-const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize)
+const struct efi_smbios_record *efi_get_smbios_record(u8 type)
 {
 	struct efi_smbios_record *record;
 	efi_smbios_protocol_t *smbios;
 	efi_status_t status;
 	u16 handle = 0xfffe;
-	const u8 *strtable;
 
 	status = efi_bs_call(locate_protocol, &EFI_SMBIOS_PROTOCOL_GUID, NULL,
 			     (void **)&smbios) ?:
 		 efi_call_proto(smbios, get_next, &handle, &type, &record, NULL);
 	if (status != EFI_SUCCESS)
 		return NULL;
+	return record;
+}
+
+const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
+				  u8 type, int offset, int recsize)
+{
+	const u8 *strtable;
+
+	if (!record)
+		return NULL;
 
 	strtable = (u8 *)record + record->length;
 	for (int i = 1; i < ((u8 *)record)[offset]; i++) {


