Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7281EE00B;
	Tue,  3 Dec 2024 16:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242759; cv=none; b=E0nv4tALQcRNJyLv/OBylMEjGIH8dq1Dd8YydRl0Y+UNBHWP7NLfXbPvWs+PExTKo4xot3Tj2jZFIzFQWn8CKONhQ0Zy2pYXjjbu0X2xx69b/WbRXDPhRedju6IGJ8vjcXX5yaLHy43Jt7iemyVGdQwZ2w+pPiw30ia7Ekv+HPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242759; c=relaxed/simple;
	bh=fLisO0hDlxerws7V9Lrb0VqtaMXaaqiAY1izMFbUYFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pn3D0CkdjSHg0Xq08/9xhP5FV0E/rS91NPdJvNY0OAlSVpvFmM+UprYXbYS2CB1g+Ds7BMlfYkCfI5sVk3m/dpX1CdnMKkcO5yVAseRDfQnH1Owz6eMxuYayHP5t5eBnEA6qn2P0pYKWeniY5WHbJmgVZ0nR6ihLKRrw1acUYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjZp2buD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjZp2buD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F935C4CECF;
	Tue,  3 Dec 2024 16:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242759;
	bh=fLisO0hDlxerws7V9Lrb0VqtaMXaaqiAY1izMFbUYFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjZp2buDFG3VwYZ/tE4+wCxtgzm6B3ZP/fDPRYq0WE4PoaJk/Al4lVUsfLv+aneHl
	 GY8afQivuv43SRgExuPDe1KtfaM3+bDeTkjAyRPy5W49oJldtYHn/KYyKbIglhVfDT
	 dEjudoGIrLVijcMEJYLrcnIRhNecFqjkUY4+npyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 802/826] x86/Documentation: Update algo in init_size description of boot protocol
Date: Tue,  3 Dec 2024 15:48:49 +0100
Message-ID: <20241203144815.043029265@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit be4ca6c53e66cb275cf0d71f32dac0c4606b9dc0 ]

The init_size description of boot protocol has an example of the runtime
start address for the compressed bzImage. For non-relocatable kernel
it relies on the pref_address value (if not 0), but for relocatable case
only pays respect to the load_addres and kernel_alignment, and it is
inaccurate for the latter. Boot loader must consider the pref_address
as the Linux kernel relocates to it before being decompressed as nicely
described in this commit message a year ago:

  43b1d3e68ee7 ("kexec: Allocate kernel above bzImage's pref_address")

Due to this documentation inaccuracy some of the bootloaders (*) made a
mistake in the calculations and if kernel image is big enough, this may
lead to unbootable configurations.

*)
  In particular, kexec-tools missed that and resently got a couple of
  changes which will be part of v2.0.30 release. For the record,
  commit 43b1d3e68ee7 only fixed the kernel kexec implementation and
  also missed to update the init_size description.

While at it, make an example C-like looking as it's done elsewhere in
the document and fix indentation as presribed by the reStructuredText
specifications, so the syntax highliting will work properly.

Fixes: 43b1d3e68ee7 ("kexec: Allocate kernel above bzImage's pref_address")
Fixes: d297366ba692 ("x86: document new bzImage fields")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20241125105005.1616154-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/x86/boot.rst | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/arch/x86/boot.rst b/Documentation/arch/x86/boot.rst
index 4fd492cb49704..ad2d8ddad27fe 100644
--- a/Documentation/arch/x86/boot.rst
+++ b/Documentation/arch/x86/boot.rst
@@ -896,10 +896,19 @@ Offset/size:	0x260/4
 
   The kernel runtime start address is determined by the following algorithm::
 
-	if (relocatable_kernel)
-	runtime_start = align_up(load_address, kernel_alignment)
-	else
-	runtime_start = pref_address
+   	if (relocatable_kernel) {
+   		if (load_address < pref_address)
+   			load_address = pref_address;
+   		runtime_start = align_up(load_address, kernel_alignment);
+   	} else {
+   		runtime_start = pref_address;
+   	}
+
+Hence the necessary memory window location and size can be estimated by
+a boot loader as::
+
+   	memory_window_start = runtime_start;
+   	memory_window_size = init_size;
 
 ============	===============
 Field name:	handover_offset
-- 
2.43.0



