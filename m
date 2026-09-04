Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6986E3515D2;
	Fri,  4 Sep 2026 05:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498353; cv=none; b=uRnCUNEcNZZerT+W/bCkubtBeBrzoX1KePfPmP28ru8x5TVQ45IvA4+pcU83fxNSXtP8hOd0u75uTmu+CWZJF3luvPBQBi4PjyRBS/3iPBcEXS2lKZK0Izh0WdBaUfB3m33A9abTtlnue6YaunDTVNGfR5c6gJI2z/pe/cqnd+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498353; c=relaxed/simple;
	bh=MzzuBFG19Tr/YbdT8ofVLljIBye3+75Pq9Jp/0d4REU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tj+CnJ58yRJWWYhVf8QyUG8Gk5bgU4HoK/rSYCLOhIHWKJI6B3EusVd6bJ/ohjNBBx6lv+rpVBVi2zpek82eV/hud2150QRPeJPas1cY7oXatKgxRJlQNWejMmaLuGFZXQ5FAzdC/pUNnmYxIzsZUpSeUf4qtx8yFYd0N0W/DD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Eq1dHwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Eq1dHwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0781F00A3D;
	Fri,  4 Sep 2026 05:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498352;
	bh=Bl1GGLgrytmQiUXaZXVOnZSjRwBUjpQIH4eagnxQmYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Eq1dHwu+eAGJ4FHpg3WOyUWA6q1pUT49DxmNU0u06DdlYNFDMVLSrOH2zIP/za1X
	 g2X7WW08718KYlT+uHT8GkDR9w3CyyDPh2Wz2nP7HsBnHiwWv8yR66zTrYaWeXjpUn
	 7m/2HGgr+PX7ZXITFuhx8OeTHWeempMFVlByrRjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Younes Akhouayri <git@younes.io>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 031/713] rust: dma: return zero for Coherent reads past EOF
Date: Fri,  4 Sep 2026 06:49:59 +0200
Message-ID: <20260904045804.529523545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Younes Akhouayri <git@younes.io>

commit 5391b147d9fd8d4736e28c629cda00fd37c2304a upstream.

Coherent<T>::write_to_slice() calculates a zero-byte copy when the file
offset is beyond the allocation, but still calls
UserSliceWriter::write_dma(). The latter rejects offsets beyond the
allocation even when the copy length is zero, so a debugfs read past EOF
returns -ERANGE.

Return before calling write_dma() when the offset is at or beyond the
allocation, matching simple_read_from_buffer() EOF semantics.

Fixes: 016818513936 ("rust: dma: implement BinaryWriter for Coherent<[u8]>")
Cc: stable@vger.kernel.org
Link: https://rust-for-linux.zulipchat.com/#narrow/channel/291566-Library/topic/.E2.9C.94.20Possible.20past-EOF.20bug.20in.20Coherent.3CT.3E.3A.3Awrite_to_slice/near/611677095
Signed-off-by: Younes Akhouayri <git@younes.io>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
Link: https://patch.msgid.link/20260730-fix-dma-coherent-eof-v2-1-8aff21054afa@younes.io
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/dma.rs |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -1005,7 +1005,11 @@ impl<T: KnownSize + AsBytes + ?Sized> de
             return Ok(0);
         };
 
-        let count = self.size().saturating_sub(offset_val).min(writer.len());
+        if offset_val >= self.size() {
+            return Ok(0);
+        }
+
+        let count = (self.size() - offset_val).min(writer.len());
 
         writer.write_dma(self, offset_val, count)?;
 


