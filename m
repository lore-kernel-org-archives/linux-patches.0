Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A750EC11;
	Wed, 30 Sep 2026 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787475; cv=none; b=UzQ+sG4wbTkNIQJtILeHh72tX8WxvsNT7+eiWfeNfIkCgn9aWLgZoS92AwYkPDmXQm/sb8zrXe7NtAKhzdrfDKJ5nX0GZwAFBzS32iP9OXlHZVF4t1Si/hMoTXOb1HBcsTW9Vj6Wd0InozJZMGfg3uZ7eS6MclFvm5bElfdrMxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787475; c=relaxed/simple;
	bh=wXEogamuAyrr2ioR1BgOE4buSWFjcy59Wyyxs6epWkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caZfwajRGxGQrmkS6fMezvgvY618lAX/TQxv+nEIujrRV66Zp5hbZSLdH44jv3e0jMYnh8PnDFbbmTAVCa2reSQfFo5U/+Lo1zPxlFU0gM4Va5yMgEn/N0ZZM3YoZFDf68+Ncr1Tnda4e9zm08KB6kTW3uy6p+F9wxrIaObUr5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00O8kH9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00O8kH9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8566F1F000FF;
	Wed, 30 Sep 2026 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787474;
	bh=026g1tZ3/ru7JfhAYSyJEHtpyCHho0+ze/QReVF/jIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00O8kH9JQCf1O6kAo1pipXSoOToXmzCDqjphpgk1J4OyYDD4oSvqugDtFU/LcRWHM
	 XRN8hyL4VGTrY3AzTpE8tvpAP+Lt4dKcthHbHLwsaek/rxNOT3k5UuyZrBNMAszznO
	 dJWXqbgRPS1uP9v1IZ6FwOTyevi36GR9Qc6Fk+lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melody Wang <huibo.wang@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 7.2 241/457] x86/sev: Make vTPM SVSM calls preemption-safe
Date: Wed, 30 Sep 2026 17:25:46 +0200
Message-ID: <20260930152351.245798166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Melody Wang <huibo.wang@amd.com>

commit 6c43c72748fffd29dec15cd1f31e9a32949bc437 upstream.

Two functions in the SVSM vTPM guest implementation do not disable
preemption when fetching the SVSM Calling Area Address (CAA).

The SVSM CAA is a per-CPU structure. When a thread is preempted and migrated
to a different CPU after fetching the per-CPU CAA, the SVSM call will execute
on the new CPU with the original CPU's CAA. Which is wrong.

Move the CAA fetching operation inside svsm_perform_call_protocol() which
disables interrupts around the SVSM call and thus runs preemption-safe.

Fixes: 770de678bc28 ("x86/sev: Add SVSM vTPM probe/send_command functions")
Signed-off-by: Melody Wang <huibo.wang@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/a5bc0d4a2c462a0089109e145c21626b244b2ff0.1789345277.git.huibo.wang@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/sev/svsm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/coco/sev/svsm.c
+++ b/arch/x86/coco/sev/svsm.c
@@ -74,6 +74,14 @@ int svsm_perform_call_protocol(struct sv
 
 	flags = native_local_irq_save();
 
+	/*
+	 * 'caa' is a per-CPU variable. To avoid using a stale or incorrect
+	 * 'caa' if the task is preempted or migrated to another CPU after it
+	 * is fetched, always fetch 'caa' and then issue the SVSM call with
+	 * interrupts disabled. This ensures the correct 'caa' is used.
+	 */
+	call->caa = svsm_get_caa();
+
 	ghcb = __sev_get_ghcb(&state);
 
 	do {
@@ -321,7 +329,6 @@ int snp_svsm_vtpm_send_command(u8 *buffe
 {
 	struct svsm_call call = {};
 
-	call.caa = svsm_get_caa();
 	call.rax = SVSM_VTPM_CALL(SVSM_VTPM_CMD);
 	call.rcx = __pa(buffer);
 
@@ -345,7 +352,6 @@ bool snp_svsm_vtpm_probe(void)
 	if (!snp_vmpl)
 		return false;
 
-	call.caa = svsm_get_caa();
 	call.rax = SVSM_VTPM_CALL(SVSM_VTPM_QUERY);
 
 	if (svsm_perform_call_protocol(&call))


