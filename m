Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC9141F7D5;
	Thu, 16 Jul 2026 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208996; cv=none; b=D7SUwOQPFET/4wMWmLm4E5mM1SE6M52UIuiXFXUzHMPCTL1G72OXQBjV7PZsiOdWVmnsXobclhpRd8cHj4LQK9eXvmXIpji44ujNk6f3RZfVK/bk7uYLoFOOrLzryvwQ+IlI82YKU+/Tcz2/XEG4BY51hxiFkp47fDZGkPL/SKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208996; c=relaxed/simple;
	bh=/K0nMKL4vhEcQ9Don9z/a5tr6ZaO8mw9XhPpSTuUZeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgGsqg3aFQVtHmcU2hHYNa/sl4duHf5APxzjwVdQgqIwzSy7RxgnT9L7R/yvHzUBX2JYLfvjZKQEq0mGSFjpHiZq106u3ZudVF6KBPN35p1HmRC9ZyEMLFdo+NFi9ECc4kL71eJKjqElOLdLk1Elv+Y7Kg4uHkiL1FRg1RQT+FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBUAEJBi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBUAEJBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508181F000E9;
	Thu, 16 Jul 2026 13:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784208994;
	bh=5wYPtzVJ09qNMj3vW6aY6m6usRwQxTX7vg4+vuTcauQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBUAEJBi0Q7QFI4TrU8ui67iBesOW4DWcN9+jHUkBI20yDUkv6txAWcqUkSx2srMZ
	 X0bUkerJdvVSeocKcqO96M+P6gpBU2o2Gb+D6hJiJcQP3rrzAw8Ppj0ktXVZvySSzF
	 ad/vJKy3qRwZepv+8Ao+Jdc/u0dnGqwwsjKGmhkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.1 018/518] rust: pci: use static lifetime for PCI BAR resource names
Date: Thu, 16 Jul 2026 15:24:46 +0200
Message-ID: <20260716133048.176198845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit e566a9e17f3774c962b6d2522750f227f027edc6 upstream.

pci_request_region() stores the name pointer directly in struct
resource; use &'static CStr to ensure the pointer remains valid even if
the Bar is leaked.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522004943.CDA7C1F000E9@smtp.kernel.org/
Fixes: 3c2e31d717ac ("rust: pci: move I/O infrastructure to separate file")
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260525202921.124698-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/pci/io.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/pci/io.rs b/rust/kernel/pci/io.rs
index ae78676c927f..3ce21482b079 100644
--- a/rust/kernel/pci/io.rs
+++ b/rust/kernel/pci/io.rs
@@ -153,7 +153,7 @@ pub struct Bar<const SIZE: usize = 0> {
 }
 
 impl<const SIZE: usize> Bar<SIZE> {
-    pub(super) fn new(pdev: &Device, num: u32, name: &CStr) -> Result<Self> {
+    pub(super) fn new(pdev: &Device, num: u32, name: &'static CStr) -> Result<Self> {
         let len = pdev.resource_len(num)?;
         if len == 0 {
             return Err(ENOMEM);
@@ -252,7 +252,7 @@ impl Device<device::Bound> {
     pub fn iomap_region_sized<'a, const SIZE: usize>(
         &'a self,
         bar: u32,
-        name: &'a CStr,
+        name: &'static CStr,
     ) -> impl PinInit<Devres<Bar<SIZE>>, Error> + 'a {
         Devres::new(self.as_ref(), Bar::<SIZE>::new(self, bar, name))
     }
@@ -261,7 +261,7 @@ pub fn iomap_region_sized<'a, const SIZE: usize>(
     pub fn iomap_region<'a>(
         &'a self,
         bar: u32,
-        name: &'a CStr,
+        name: &'static CStr,
     ) -> impl PinInit<Devres<Bar>, Error> + 'a {
         self.iomap_region_sized::<0>(bar, name)
     }
-- 
2.55.0



