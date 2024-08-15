Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805C21714A8;
	Thu, 15 Aug 2024 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729418; cv=none; b=MDNPLj+aIWVQgYzTUWQ+yWDj7a8TylqBm/rOgqxIPBWPZa4NVsDIn8rTiuw7SinFFGq1gtjHWwfGCr1MDJvNnBV2IsJ3IZ94SS8XEo2ojpxLzedZFJH6pz4MpaLvnqMX1zaEyfvgQEayvgiNMC8D5jcn4phtT6VOf80s6P36Fn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729418; c=relaxed/simple;
	bh=UfuZW983r0ncrJkLNHbSwGzKJbCTyQr6kmu/jp1XXqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi25a6Loq/7SlUj1/RaGGuk5vqxm8nmxhy2TPoDnHca1cgb4aojMf9u1YuJYxkIgH2eHhlu7P9UrCiLHUpmkwDHlHLzjZ5uMZ3ylilxmF4p9Jc6BpBtGfiMiQTMWyFM3IekwIf4hmZeaFOCIGe+daV3qCZYfA4fqVywB+VbJ0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wU8Y6dvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wU8Y6dvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F4DC32786;
	Thu, 15 Aug 2024 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729418;
	bh=UfuZW983r0ncrJkLNHbSwGzKJbCTyQr6kmu/jp1XXqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wU8Y6dvoCi2gBktbwEb4rQqrncq6FMsKYwvlud3TcRjZjxNIkAbFebPPkIRKH7AcV
	 y5L/JIB4zwX71K5PI14tn9uIyDw+lBH1HnN3FtAymoeBS6j27mThh26/djHfOgO9YQ
	 25H08jhWh4xTdjb1Yfy4K76YtcUl3ezjo5EhQ2bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/484] KVM: s390: pv: add export before import
Date: Thu, 15 Aug 2024 15:19:08 +0200
Message-ID: <20240815131944.763121222@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 72b1daff2671cef2c8cccc6c4e52f8d5ce4ebe58 ]

Due to upcoming changes, it will be possible to temporarily have
multiple protected VMs in the same address space, although only one
will be actually active.

In that scenario, it is necessary to perform an export of every page
that is to be imported, since the hardware does not allow a page
belonging to a protected guest to be imported into a different
protected guest.

This also applies to pages that are shared, and thus accessible by the
host.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-7-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-7-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Stable-dep-of: 3f29f6537f54 ("s390/uv: Don't call folio_wait_writeback() without a folio reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 8b0e62507d62e..56bb0a4829770 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -234,6 +234,32 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
 
+/**
+ * should_export_before_import - Determine whether an export is needed
+ * before an import-like operation
+ * @uvcb: the Ultravisor control block of the UVC to be performed
+ * @mm: the mm of the process
+ *
+ * Returns whether an export is needed before every import-like operation.
+ * This is needed for shared pages, which don't trigger a secure storage
+ * exception when accessed from a different guest.
+ *
+ * Although considered as one, the Unpin Page UVC is not an actual import,
+ * so it is not affected.
+ *
+ * No export is needed also when there is only one protected VM, because the
+ * page cannot belong to the wrong VM in that case (there is no "other VM"
+ * it can belong to).
+ *
+ * Return: true if an export is needed before every import, otherwise false.
+ */
+static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+{
+	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
+		return false;
+	return atomic_read(&mm->context.protected_count) > 1;
+}
+
 /*
  * Requests the Ultravisor to make a page accessible to a guest.
  * If it's brought in the first time, it will be cleared. If
@@ -277,6 +303,8 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 
 	lock_page(page);
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
+	if (should_export_before_import(uvcb, gmap->mm))
+		uv_convert_from_secure(page_to_phys(page));
 	rc = make_secure_pte(ptep, uaddr, page, uvcb);
 	pte_unmap_unlock(ptep, ptelock);
 	unlock_page(page);
-- 
2.43.0



