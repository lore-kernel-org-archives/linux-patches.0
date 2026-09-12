Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D522931FB;
	Sat, 12 Sep 2026 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200150; cv=none; b=U7d2+TatuZ+DMvsm+8xQLKK6fSa57PtDr4CRJqVdV9KpxLRjrPjwN0gUWYc+BSrlCwGo3aS1VgJ83ZgzAul8rbas/BJSnN+IddhgxIobFy3dwgaqdwni91LzpKotMVnYONBwb4nWdkbSuK2Zs6oCi2CQZZuxrzSwuGaCWq5Szvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200150; c=relaxed/simple;
	bh=NWvbtfYBJfotnMqB8aQIGCjKne2UHXL1fHHOTk+Hct0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHoRpTaiavJDGKZ83M5ElHITgeRodBdapXZLX48HqT4CcLjG4ydU60gQiCPcqfUjt7OLuH1YsLxwgP+jhDVsjPsyRKaz6CNPHWS+YmueLpufwJ+KIOGPwonF1Iaz68Yvo+HWP+De1ZFICyNJ8oD6RcNtMI3K6zaSeLBpy715EYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kD07Ftzg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kD07Ftzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC881F000FF;
	Sat, 12 Sep 2026 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200149;
	bh=z7HH/uQByvxCXOGWaKhy2rJdh7EbAHfywTBL8LuNmi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kD07FtzgETlKjCsnuA2l9cVd40z+WRTBwQwhIDwxz+bwD5QtXvT6kv4IwjefPaKUc
	 DM1cb1NpuS39JyrU+Y+lwOCC5/d8OR0k/lanAyEVbTPG8Tt4g18Og2VIKwCUuOy6dz
	 7dM4pn1ZWVIHzS4zdjtYDRu0zdwhr+eo9QhOFM6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0689/1815] gpu: nova-core: build SetRegistry entries dynamically
Date: Sat, 12 Sep 2026 08:40:39 +0200
Message-ID: <20260912065705.066138214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit d85845b64c0020b2812243a22fa79d57cc1c1e38 ]

The GSP SetRegistry command currently stores its registry entries in a
fixed-size array. That makes every additional runtime-dependent registry
object require reshaping the command data structure at the same time as the
feature that needs the new entry.

Keep the existing registry contents unchanged, but store them in a KVec so
SetRegistry can be constructed dynamically. The constructor now returns a
Result to propagate allocation failures while the command payload layout is
still computed from the final entry list.

Cc: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Link: https://patch.msgid.link/20260701062622.3499033-7-zhiw@nvidia.com
[acourbot: remove orphan comment.]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Stable-dep-of: 93b9511a3bba ("gpu: nova-core: fix packed registry table size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/boot.rs     |  2 +-
 drivers/gpu/nova-core/gsp/commands.rs | 76 +++++++++++++++------------
 2 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/nova-core/gsp/boot.rs b/drivers/gpu/nova-core/gsp/boot.rs
index 8afb62d689cb4..fbf81eb6c34dc 100644
--- a/drivers/gpu/nova-core/gsp/boot.rs
+++ b/drivers/gpu/nova-core/gsp/boot.rs
@@ -146,7 +146,7 @@ impl super::Gsp {
         self.cmdq
             .send_command_no_wait(bar, commands::SetSystemInfo::new(pdev, chipset))?;
         self.cmdq
-            .send_command_no_wait(bar, commands::SetRegistry::new())?;
+            .send_command_no_wait(bar, commands::SetRegistry::new()?)?;
 
         hal.post_boot(&self, dev, bar, &gsp_fw, gsp_falcon, sec2_falcon)?;
 
diff --git a/drivers/gpu/nova-core/gsp/commands.rs b/drivers/gpu/nova-core/gsp/commands.rs
index f84de9f4f0450..514d75fb52b8f 100644
--- a/drivers/gpu/nova-core/gsp/commands.rs
+++ b/drivers/gpu/nova-core/gsp/commands.rs
@@ -66,37 +66,44 @@ struct RegistryEntry {
 
 /// The `SetRegistry` command.
 pub(crate) struct SetRegistry {
-    entries: [RegistryEntry; Self::NUM_ENTRIES],
+    entries: KVec<RegistryEntry>,
 }
 
 impl SetRegistry {
-    // For now we hard-code the registry entries. Future work will allow others to
-    // be added as module parameters.
-    const NUM_ENTRIES: usize = 3;
-
     /// Creates a new `SetRegistry` command, using a set of hardcoded entries.
-    pub(crate) fn new() -> Self {
-        Self {
-            entries: [
-                // RMSecBusResetEnable - enables PCI secondary bus reset
-                RegistryEntry {
-                    key: "RMSecBusResetEnable",
-                    value: 1,
-                },
-                // RMForcePcieConfigSave - forces GSP-RM to preserve PCI configuration registers on
-                // any PCI reset.
-                RegistryEntry {
-                    key: "RMForcePcieConfigSave",
-                    value: 1,
-                },
-                // RMDevidCheckIgnore - allows GSP-RM to boot even if the PCI dev ID is not found
-                // in the internal product name database.
-                RegistryEntry {
-                    key: "RMDevidCheckIgnore",
-                    value: 1,
-                },
-            ],
-        }
+    pub(crate) fn new() -> Result<Self> {
+        let mut entries = KVec::new();
+
+        // RMSecBusResetEnable - enables PCI secondary bus reset
+        entries.push(
+            RegistryEntry {
+                key: "RMSecBusResetEnable",
+                value: 1,
+            },
+            GFP_KERNEL,
+        )?;
+
+        // RMForcePcieConfigSave - forces GSP-RM to preserve PCI configuration registers on
+        // any PCI reset.
+        entries.push(
+            RegistryEntry {
+                key: "RMForcePcieConfigSave",
+                value: 1,
+            },
+            GFP_KERNEL,
+        )?;
+
+        // RMDevidCheckIgnore - allows GSP-RM to boot even if the PCI dev ID is not found
+        // in the internal product name database.
+        entries.push(
+            RegistryEntry {
+                key: "RMDevidCheckIgnore",
+                value: 1,
+            },
+            GFP_KERNEL,
+        )?;
+
+        Ok(Self { entries })
     }
 }
 
@@ -107,15 +114,18 @@ impl CommandToGsp for SetRegistry {
     type InitError = Infallible;
 
     fn init(&self) -> impl Init<Self::Command, Self::InitError> {
-        Self::Command::init(Self::NUM_ENTRIES as u32, self.variable_payload_len() as u32)
+        Self::Command::init(
+            self.entries.len() as u32,
+            self.variable_payload_len() as u32,
+        )
     }
 
     fn variable_payload_len(&self) -> usize {
         let mut key_size = 0;
-        for i in 0..Self::NUM_ENTRIES {
-            key_size += self.entries[i].key.len() + 1; // +1 for NULL terminator
+        for entry in self.entries.iter() {
+            key_size += entry.key.len() + 1; // +1 for NULL terminator
         }
-        Self::NUM_ENTRIES * size_of::<fw::commands::PackedRegistryEntry>() + key_size
+        self.entries.len() * size_of::<fw::commands::PackedRegistryEntry>() + key_size
     }
 
     fn init_variable_payload(
@@ -123,12 +133,12 @@ impl CommandToGsp for SetRegistry {
         dst: &mut SBufferIter<core::array::IntoIter<&mut [u8], 2>>,
     ) -> Result {
         let string_data_start_offset = size_of::<Self::Command>()
-            + Self::NUM_ENTRIES * size_of::<fw::commands::PackedRegistryEntry>();
+            + self.entries.len() * size_of::<fw::commands::PackedRegistryEntry>();
 
         // Array for string data.
         let mut string_data = KVec::new();
 
-        for entry in self.entries.iter().take(Self::NUM_ENTRIES) {
+        for entry in self.entries.iter() {
             dst.write_all(
                 fw::commands::PackedRegistryEntry::new(
                     (string_data_start_offset + string_data.len()) as u32,
-- 
2.53.0



