Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4054306497;
	Mon, 13 Oct 2025 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369092; cv=none; b=Z1Ivg+o+dCRGv5H5M3fEB/ESHSILoqt7hex2nmPWcxFPvPZQ6aGYqfIggMG8aw1LcYsSGtOHIzfEErKYL872RfZkJHTG9IOYxdyqx+ew3MaJWNg2Y3z+yAV/zJBoEEgJ7TRmTBEkI/9fZePg4H6PK+XKVWAJ5Lj9vjt8B/HbL3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369092; c=relaxed/simple;
	bh=cnYIYigWysodhlhgbSAryj2xo2RUnwUaTWDA5S05YYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSqIHxHRsFh+gXmneRihjUfRlh6MD0duzCNiV2yiHXVcBF07j9kAw9DYBRUxw7AvD1C8+s0xUBmu97GHMGzjZ6c0c+SbAZAVzspwz2j8RJUoDakMPnWCRi+/wmZtdGxKBWzAUleJmOfn2GE/QQgbaFk2cKWE2s+Kv5SsDL+PT/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkZWAUf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkZWAUf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDC8C4CEE7;
	Mon, 13 Oct 2025 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369092;
	bh=cnYIYigWysodhlhgbSAryj2xo2RUnwUaTWDA5S05YYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkZWAUf+SfBtPJrkDXfv9Z7LsSwykRARWXwNytB38DlwjkUVSCVcSn0ngGxr40TAB
	 vnbyj9qGaNckIY+BxwPLuhJ/VYydH3pyg327ZpBiyD/4K99jTZoQD5QvnHiJuYKTqe
	 hglt4Vo4Lsvoiv30FSMn9fuF+C7N2IlH7sxGG3a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 092/563] vdso/datastore: Gate time data behind CONFIG_GENERIC_GETTIMEOFDAY
Date: Mon, 13 Oct 2025 16:39:13 +0200
Message-ID: <20251013144414.630471211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 7c0c01a216e6d9e1d169c0f6f3b5522e6da708ed ]

When the generic vDSO does not provide time functions, as for example on
riscv32, then the time data store is not necessary.

Avoid allocating these time data pages when not used.

Fixes: df7fcbefa710 ("vdso: Add generic time data storage")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250826-vdso-cleanups-v1-1-d9b65750e49f@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vdso/datastore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 3693c6caf2c4d..a565c30c71a04 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -11,14 +11,14 @@
 /*
  * The vDSO data page.
  */
-#ifdef CONFIG_HAVE_GENERIC_VDSO
+#ifdef CONFIG_GENERIC_GETTIMEOFDAY
 static union {
 	struct vdso_time_data	data;
 	u8			page[PAGE_SIZE];
 } vdso_time_data_store __page_aligned_data;
 struct vdso_time_data *vdso_k_time_data = &vdso_time_data_store.data;
 static_assert(sizeof(vdso_time_data_store) == PAGE_SIZE);
-#endif /* CONFIG_HAVE_GENERIC_VDSO */
+#endif /* CONFIG_GENERIC_GETTIMEOFDAY */
 
 #ifdef CONFIG_VDSO_GETRANDOM
 static union {
@@ -46,7 +46,7 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 
 	switch (vmf->pgoff) {
 	case VDSO_TIME_PAGE_OFFSET:
-		if (!IS_ENABLED(CONFIG_HAVE_GENERIC_VDSO))
+		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
 			return VM_FAULT_SIGBUS;
 		pfn = __phys_to_pfn(__pa_symbol(vdso_k_time_data));
 		if (timens_page) {
-- 
2.51.0



