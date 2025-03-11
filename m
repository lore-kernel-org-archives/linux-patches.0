Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859E41A5BA4;
	Tue, 11 Mar 2025 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706791; cv=none; b=KFn3fAA2/psai3IEpZzuYDO1U23up27Z8TLSRch7meiiyIBOiHhoQzouuiHu+YZOK8IllVtdDUG+U402u2eoNwmkGnq4IiYF1vAVq3CEosDPNzkJIx8VgnXJAhMmD1Fi4b0d4awho2af3kV9CudTlRazWEufbk8RwBzbnSmQ14k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706791; c=relaxed/simple;
	bh=lv4UpegVMBbc6vfD4d1ae3KYKZPhlvK4rv4f+2eMn2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CX9Ic2q28GAdWYPdIzya6fHqC5g+24PqyEhmrjPyS0hB4uA0T1HyQhsPddyHBxSnjVk4Ue7yyzY75za+p8RI8xDSMrdPkZGg4kYSiBMp+3ycdQofWL/7A+I4yt8v6Vchd0f3wbTg2+CLhW+aPjPEpv2QFB1+e/Sm/6Ko5NCmtaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEe7Zgpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEe7Zgpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D3EC4CEE9;
	Tue, 11 Mar 2025 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706791;
	bh=lv4UpegVMBbc6vfD4d1ae3KYKZPhlvK4rv4f+2eMn2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEe7ZgpuC1DGytziouxHYVS2h4xxmXiUz1s8mZXrn+6RiwmhqGCW5UI+zFTIagw9P
	 SETWpXk1AkigSc03EWDdHYW6C4KLSveiovfrA8/WOn/MhlSgQ19EtgA8EkuOsAP4Kr
	 RuJDr2kh1luVSO+ORVGCP9zrDMQU14BgkzHPX83I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.10 168/462] binfmt_flat: Fix integer overflow bug on 32 bit systems
Date: Tue, 11 Mar 2025 15:57:14 +0100
Message-ID: <20250311145804.992859257@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 55cf2f4b945f6a6416cc2524ba740b83cc9af25a upstream.

Most of these sizes and counts are capped at 256MB so the math doesn't
result in an integer overflow.  The "relocs" count needs to be checked
as well.  Otherwise on 32bit systems the calculation of "full_data"
could be wrong.

	full_data = data_len + relocs * sizeof(unsigned long);

Fixes: c995ee28d29d ("binfmt_flat: prevent kernel dammage from corrupted executable headers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/5be17f6c-5338-43be-91ef-650153b975cb@stanley.mountain
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -534,7 +534,7 @@ static int load_flat_file(struct linux_b
 	 * 28 bits (256 MB) is way more than reasonable in this case.
 	 * If some top bits are set we have probable binary corruption.
 	*/
-	if ((text_len | data_len | bss_len | stack_len | full_data) >> 28) {
+	if ((text_len | data_len | bss_len | stack_len | relocs | full_data) >> 28) {
 		pr_err("bad header\n");
 		ret = -ENOEXEC;
 		goto err;


