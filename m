Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AECB1B2181;
	Tue, 15 Oct 2024 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998594; cv=none; b=dKWEGDW6+wLKTowz1MOmbFs7pN/xK9hSrXGCmNfREdxE26sBBdEJ9y89HqEzuR6yGrskEYT1PQcseswgMa4ufQZ2b6S/jeTfxgPNmRfCa3qrx/feg9MfAPPQ/JRmWQ9ac1eVPJmE0ya6nNNiJ7x/H68TYIKPz8BRMWH51X0Echs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998594; c=relaxed/simple;
	bh=qvGJjLlsaZJQMBgrUJhYv6j81sf58sGRKO8wFuD3BtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL6UOKmXodXjfZj/bazmkf+HlkaQiFAMdwqUtCQyE2rKxSuXd80wcsCnsy9fiJO4GxYyZAQVo6ZHWW23PeJjO0yXN9hyMdqzy7dfT/AnGCuDiv8aTjlW5jhGGTy0kUudr1ck64tfiVddFeK3yWbGCjGBZtirv/sCCQx7rv09m78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMuqlZ+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMuqlZ+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6773C4CEC6;
	Tue, 15 Oct 2024 13:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998594;
	bh=qvGJjLlsaZJQMBgrUJhYv6j81sf58sGRKO8wFuD3BtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMuqlZ+oF0YlTPA6iYRM7Imc2vGJHIzVEPtfk64LXHbXADGKFI0YCPNrUhUfTVYhR
	 a1Eo4NkdXsB1fTzXSagHXAxoNfz3zRxQ/wr6rhjxvhWCaHv3Gf6FvT6PhWTs9tUIPO
	 x0CAABiSemU9a+9BaoMuUrsVgQKNOtJXXLFkd1vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonatan Maman <Ymaman@Nvidia.com>,
	Gal Shalom <GalShalom@Nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 510/518] nouveau/dmem: Fix vulnerability in migrate_to_ram upon copy error
Date: Tue, 15 Oct 2024 14:46:54 +0200
Message-ID: <20241015123936.673992078@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Maman <Ymaman@Nvidia.com>

commit 835745a377a4519decd1a36d6b926e369b3033e2 upstream.

The `nouveau_dmem_copy_one` function ensures that the copy push command is
sent to the device firmware but does not track whether it was executed
successfully.

In the case of a copy error (e.g., firmware or hardware failure), the
copy push command will be sent via the firmware channel, and
`nouveau_dmem_copy_one` will likely report success, leading to the
`migrate_to_ram` function returning a dirty HIGH_USER page to the user.

This can result in a security vulnerability, as a HIGH_USER page that may
contain sensitive or corrupted data could be returned to the user.

To prevent this vulnerability, we allocate a zero page. Thus, in case of
an error, a non-dirty (zero) page will be returned to the user.

Fixes: 5be73b690875 ("drm/nouveau/dmem: device memory helpers for SVM")
Signed-off-by: Yonatan Maman <Ymaman@Nvidia.com>
Co-developed-by: Gal Shalom <GalShalom@Nvidia.com>
Signed-off-by: Gal Shalom <GalShalom@Nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008115943.990286-3-ymaman@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -149,7 +149,7 @@ static vm_fault_t nouveau_dmem_fault_cop
 	if (!spage || !(args->src[0] & MIGRATE_PFN_MIGRATE))
 		return 0;
 
-	dpage = alloc_page_vma(GFP_HIGHUSER, vmf->vma, vmf->address);
+	dpage = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vmf->vma, vmf->address);
 	if (!dpage)
 		return VM_FAULT_SIGBUS;
 	lock_page(dpage);


