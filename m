Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E041143757;
	Wed, 19 Jun 2024 13:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803377; cv=none; b=mCD/3ajEaddwAITu8qC8dTEuyMc68ue6rjtnsGfvaiLZcspW5pUZ4klcCtdSG12gOpD46LjEV8lfK5bZgZY9djke3gcdV/5rQYcXwPW3JMmUcroDVZM2v14mHGnPhUctVBWv0rPt1e1GvJq8TqCjlRINOTQ/IcRAoG64AxEIbNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803377; c=relaxed/simple;
	bh=QsWca1lSsPAqKhorSbdkEvpUSYobetYvik4gO0iAEW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4L8b+RIjdLTpn7BAxUHHC1WnNLqzGCre4swR5W3ZCpW2Smr4L5rQHVM+yjIKZo8AEg8dErPY8agQ+IT+eoiMLurlBfA9/3AbKlcCm39VcRRaAt9qXYDD2KgmsU6oz9nIDSW7jUnasX0LA9lzhL7yHOj7kpf44ZKYUhoB+dpSF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4qCbf8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4qCbf8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876DEC2BBFC;
	Wed, 19 Jun 2024 13:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803376;
	bh=QsWca1lSsPAqKhorSbdkEvpUSYobetYvik4gO0iAEW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4qCbf8GOKQ2i5GIwMrEjzs0xa+c7shmYALgZQmXI4DumKhjAY+j5JFmVha5rVko8
	 xKqqUmNc04uMhNuOG3EBOOV1/cbmWrO+zZ5NAPyd7M7Vt1BLUqFUMHNkJdf1OL9ILW
	 jQAEoh2AkGpgSAzLs02cQYtxU0kZ6FK3dcRAhDZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.9 215/281] x86/kexec: Fix bug with call depth tracking
Date: Wed, 19 Jun 2024 14:56:14 +0200
Message-ID: <20240619125618.234415637@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Kaplan <david.kaplan@amd.com>

commit 93c1800b3799f17375989b0daf76497dd3e80922 upstream.

The call to cc_platform_has() triggers a fault and system crash if call depth
tracking is active because the GS segment has been reset by load_segments() and
GS_BASE is now 0 but call depth tracking uses per-CPU variables to operate.

Call cc_platform_has() earlier in the function when GS is still valid.

  [ bp: Massage. ]

Fixes: 5d8213864ade ("x86/retbleed: Add SKL return thunk")
Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20240603083036.637-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/machine_kexec_64.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -295,8 +295,15 @@ void machine_kexec_cleanup(struct kimage
 void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
-	void *control_page;
+	unsigned int host_mem_enc_active;
 	int save_ftrace_enabled;
+	void *control_page;
+
+	/*
+	 * This must be done before load_segments() since if call depth tracking
+	 * is used then GS must be valid to make any function calls.
+	 */
+	host_mem_enc_active = cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT);
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)
@@ -358,7 +365,7 @@ void machine_kexec(struct kimage *image)
 				       (unsigned long)page_list,
 				       image->start,
 				       image->preserve_context,
-				       cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT));
+				       host_mem_enc_active);
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)


