Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4336232ED57;
	Mon, 29 Dec 2025 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025466; cv=none; b=lpkrhVMehjrOaa67dSmFz8sNpGpuU1vmMpKC8l2CeVSojAGej+d4zahvoAMk2vxnXezGjEixG9r1ivPQUz7v8n1qFO7MBMX4ODd8NjIq0weazGJ/OTzru+3djwENM0FnVTcp9fSZHrCfGV64omT03UrWpuueXkU5ZhSPOyN2ljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025466; c=relaxed/simple;
	bh=SpcFvbfgu+R3f95FkScudvx2xVpge32X5w9tw0/2UKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHqw8111eetiSZmTk3Se5OFLIZOqMKZOF85llChfx66uHK2Q6m2IZguCNqpBlAmFlTBociZj72DzNr7ou9hIXG8vlr4qaYutPiqkL0nwwH/mf6yzdkcTi5CZiKdAlFWRgicUWwfCmdta384CbVV7iCoYb+DjhfVjy8UUjIVQN1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuGXo0QV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuGXo0QV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F84FC4CEF7;
	Mon, 29 Dec 2025 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025466;
	bh=SpcFvbfgu+R3f95FkScudvx2xVpge32X5w9tw0/2UKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuGXo0QV493U31+bjaTuo+exb2FhdzRbjwXEJx4lXjVau7EE34XSb6GpRpoTpA7Tn
	 Tiuf+1Jy6P9gjltVdTURWPxsDwZdF46nE9AViQzMbtROQRUIknVjIAxEUOgHQ4r5ER
	 n+2Gf3vPZbdkGGBIBIUNw+udFDusIS8jFmM2j7Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Marko Turk <mt@markoturk.info>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 223/430] samples: rust: fix endianness issue in rust_driver_pci
Date: Mon, 29 Dec 2025 17:10:25 +0100
Message-ID: <20251229160732.559388975@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Marko Turk <mt@markoturk.info>

commit e2f1081ca8f18c146e8f928486deac61eca2b517 upstream.

MMIO backend of PCI Bar always assumes little-endian devices and
will convert to CPU endianness automatically. Remove the u32::from_le
conversion which would cause a bug on big-endian machines.

Cc: stable@vger.kernel.org
Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Marko Turk <mt@markoturk.info>
Fixes: 685376d18e9a ("samples: rust: add Rust PCI sample driver")
Link: https://patch.msgid.link/20251210112503.62925-2-mt@markoturk.info
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/rust/rust_driver_pci.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/rust/rust_driver_pci.rs b/samples/rust/rust_driver_pci.rs
index 5823787bea8e..fa677991a5c4 100644
--- a/samples/rust/rust_driver_pci.rs
+++ b/samples/rust/rust_driver_pci.rs
@@ -48,7 +48,7 @@ fn testdev(index: &TestIndex, bar: &Bar0) -> Result<u32> {
         // Select the test.
         bar.write8(index.0, Regs::TEST);
 
-        let offset = u32::from_le(bar.read32(Regs::OFFSET)) as usize;
+        let offset = bar.read32(Regs::OFFSET) as usize;
         let data = bar.read8(Regs::DATA);
 
         // Write `data` to `offset` to increase `count` by one.
-- 
2.52.0



