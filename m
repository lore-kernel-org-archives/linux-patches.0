Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B805C189B85;
	Tue, 30 Jul 2024 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356431; cv=none; b=uibKLBypmULkAeH7GP3NvIfrlWnDCHQC3jCCJi6r1urFwYjU/LeJqF4QH3mpBFkVqY8+osLIePMjlHpI/VJew/8ui8dw5f5hMNXSGVRDWKlPhJ4e8+tsfy12qNeZvkISqjpYSnjlMbSQqPEwqVkEjbMxF3vWZsjiFi4MAh4+/ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356431; c=relaxed/simple;
	bh=jzfDbByuOS3Ziofk87OG6Q8/47M/5Hb7yRWL8d5jsgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLwYp47gnhw8S7LDTFhJ6F8LYLgn+6KA7ErtHlb0RlUZuhatyG/eLll+04+vmO7tTo5FAkBn95kJOCVqM+98zJ7S9yPdR9GwTCTYawyXYMvSDXekZdqw6LroNjLykOwUCmmw6nITBO26aWbMsJNSHXmaagMjSPerY2T7x3FhUZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3jEi9cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3jEi9cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390C8C4AF0E;
	Tue, 30 Jul 2024 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356431;
	bh=jzfDbByuOS3Ziofk87OG6Q8/47M/5Hb7yRWL8d5jsgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3jEi9cf3fKkbrd3cxePAKE7sAPxcN9aC1t5xlhrAoSUFcEfZOBTeR+gJahLofCNM
	 /jPwCHED4MwDWMOqyMvqKst5zXMbbt9CzsavdLhZpyebIYuNIuJhK/YebFobeZMWEj
	 kIh8sZpNVRHiKsJPwFR+FrvOQrf0BaT2vDGagZcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Currey <ruscur@russell.cc>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/440] powerpc/pseries: Add helper to get PLPKS password length
Date: Tue, 30 Jul 2024 17:47:04 +0200
Message-ID: <20240730151623.332666446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit 9ee76bd5c7e39b622660cc14833ead1967f2038d ]

Add helper function to get the PLPKS password length. This will be used
in a later patch to support passing the password between kernels over
kexec.

Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230210080401.345462-23-ajd@linux.ibm.com
Stable-dep-of: 932bed412170 ("powerpc/kexec_file: fix cpus node update to FDT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/plpks.h       | 5 +++++
 arch/powerpc/platforms/pseries/plpks.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/powerpc/include/asm/plpks.h b/arch/powerpc/include/asm/plpks.h
index 8dab5c26c1e41..9e2219b0202db 100644
--- a/arch/powerpc/include/asm/plpks.h
+++ b/arch/powerpc/include/asm/plpks.h
@@ -153,6 +153,11 @@ u32 plpks_get_maxlargeobjectsize(void);
  */
 u64 plpks_get_signedupdatealgorithms(void);
 
+/**
+ * Returns the length of the PLPKS password in bytes.
+ */
+u16 plpks_get_passwordlen(void);
+
 #endif // CONFIG_PSERIES_PLPKS
 
 #endif // _ASM_POWERPC_PLPKS_H
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 2b659f2b01214..eea251105e394 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -348,6 +348,11 @@ u64 plpks_get_signedupdatealgorithms(void)
 	return signedupdatealgorithms;
 }
 
+u16 plpks_get_passwordlen(void)
+{
+	return ospasswordlength;
+}
+
 bool plpks_is_available(void)
 {
 	int rc;
-- 
2.43.0



