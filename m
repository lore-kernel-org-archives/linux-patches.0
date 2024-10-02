Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBAD1EA80;
	Wed,  2 Oct 2024 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880232; cv=none; b=RSbXWH69ikQPJ4sH8msJJ0AZRdoL5CwHrhqlIwJWOuLkX5/nSnP8ouXRoxtPU08xZRz4dbpanxAyUKv8v3KlTBKblZHgHFGRhgYzFwaK2uFnDQUOAI0EEK/vBi7DR53XU5qVynY08tt/p2Bv2pCBOsfJrPpAOAz4YmE1wcWe638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880232; c=relaxed/simple;
	bh=fyV65lUCUz951zPZinbgqag2TrtBFrq6DNmckckeO6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVBKZVHCALzSyCVglkP8yidgo0zen0yZ7GpHMVgvjxzAmL/4pYXQoGcOhinKvFmskAt181t5FbKtWpaEm6Zmt5yJB517zvWcf0vYAc3mdqQ87TOthE6Hf+XKqAQTvJvU6ulozr2WfDZDRKuC+UQEeV3BuAjZEW5iQaVzaFYQHOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHFS+b9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHFS+b9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690ABC4CECD;
	Wed,  2 Oct 2024 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880231;
	bh=fyV65lUCUz951zPZinbgqag2TrtBFrq6DNmckckeO6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHFS+b9zwjDbtj8ejOe+2g6DreX8Qx5Y0/UUAmUuBGTb99S+I9g00c1sbwHlnGRnm
	 bLtf5i54zOR3CA6GgCsVYIH5hURjpQygXLUZeC+Ok7+wNYSh1kc3v98EtdmLYsC+Xi
	 Oz8UoLZvQGz+R3vmwbjGeOJlawFlfyvLSceb8RJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 6.6 388/538] xen: move checks for e820 conflicts further up
Date: Wed,  2 Oct 2024 15:00:27 +0200
Message-ID: <20241002125807.747737174@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit c4498ae316da5b5786ccd448fc555f3339b8e4ca upstream.

Move the checks for e820 memory map conflicts using the
xen_chk_is_e820_usable() helper further up in order to prepare
resolving some of the possible conflicts by doing some e820 map
modifications, which must happen before evaluating the RAM layout.

Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/setup.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -855,6 +855,28 @@ char * __init xen_memory_setup(void)
 	/* Make sure the Xen-supplied memory map is well-ordered. */
 	e820__update_table(&xen_e820_table);
 
+	/*
+	 * Check whether the kernel itself conflicts with the target E820 map.
+	 * Failing now is better than running into weird problems later due
+	 * to relocating (and even reusing) pages with kernel text or data.
+	 */
+	xen_chk_is_e820_usable(__pa_symbol(_text),
+			       __pa_symbol(_end) - __pa_symbol(_text),
+			       "kernel");
+
+	/*
+	 * Check for a conflict of the xen_start_info memory with the target
+	 * E820 map.
+	 */
+	xen_chk_is_e820_usable(__pa(xen_start_info), sizeof(*xen_start_info),
+			       "xen_start_info");
+
+	/*
+	 * Check for a conflict of the hypervisor supplied page tables with
+	 * the target E820 map.
+	 */
+	xen_pt_check_e820();
+
 	max_pages = xen_get_max_pages();
 
 	/* How many extra pages do we need due to remapping? */
@@ -927,28 +949,6 @@ char * __init xen_memory_setup(void)
 
 	e820__update_table(e820_table);
 
-	/*
-	 * Check whether the kernel itself conflicts with the target E820 map.
-	 * Failing now is better than running into weird problems later due
-	 * to relocating (and even reusing) pages with kernel text or data.
-	 */
-	xen_chk_is_e820_usable(__pa_symbol(_text),
-			       __pa_symbol(_end) - __pa_symbol(_text),
-			       "kernel");
-
-	/*
-	 * Check for a conflict of the xen_start_info memory with the target
-	 * E820 map.
-	 */
-	xen_chk_is_e820_usable(__pa(xen_start_info), sizeof(*xen_start_info),
-			       "xen_start_info");
-
-	/*
-	 * Check for a conflict of the hypervisor supplied page tables with
-	 * the target E820 map.
-	 */
-	xen_pt_check_e820();
-
 	xen_reserve_xen_mfnlist();
 
 	/* Check for a conflict of the initrd with the target E820 map. */


