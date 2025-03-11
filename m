Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001FC25B691;
	Tue, 11 Mar 2025 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707478; cv=none; b=jUTmoe41bg1CemQ5k8I+l5TglSINM+jrvriXdhXoNhhT7vblWd+JtUh5j6nLaoH90iN0QRlig93yCR/VKmgjUjJo0COBW9FXSpHE+epCIX3rfovIFMli3Mg6q4YjNMSrL6+Gc7y/+5b1B0kI8L1ku3SDJiEH1q7fpoDngyGbnjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707478; c=relaxed/simple;
	bh=RgZbfYgVyVPWzg/0JVjgfwHYJUtPtaeiXBW3frkgj30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAuVpEwfltjxzsi30WQsykfd/joKdiVQQIG6aQqtawCm77z1xnPptNvNy+lCDuwfOKY1c4rCRWlmowVl77ygxNxrxdMxzQtnvTew4VIg3t1L+zY4zeFNMzGq/bT3fG3Tv/1E4fRMtts5h8SegPDIDJTEgF70pklK8NXulKKeRPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQFSL8j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQFSL8j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7210EC4CEE9;
	Tue, 11 Mar 2025 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707477;
	bh=RgZbfYgVyVPWzg/0JVjgfwHYJUtPtaeiXBW3frkgj30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQFSL8j/oqXFqxCXvOvjD/ikVDzDMrXtnwkr6w62IOoOu6WSPDbywWmMa4ytSM3KA
	 BIL0uS1aN9JDY9FKBoID81ZiA/IpoAi08fnkBlDeOz16zKNLFxruqiGUFTsFhZ/WnO
	 xUxKticOF21mPPidsBBXMv/hO5PaiCTUFUF5VfjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 402/462] s390/traps: Fix test_monitor_call() inline assembly
Date: Tue, 11 Mar 2025 16:01:08 +0100
Message-ID: <20250311145814.216539030@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 5623bc23a1cb9f9a9470fa73b3a20321dc4c4870 upstream.

The test_monitor_call() inline assembly uses the xgr instruction, which
also modifies the condition code, to clear a register. However the clobber
list of the inline assembly does not specify that the condition code is
modified, which may lead to incorrect code generation.

Use the lhi instruction instead to clear the register without that the
condition code is modified. Furthermore this limits clearing to the lower
32 bits of val, since its type is int.

Fixes: 17248ea03674 ("s390: fix __EMIT_BUG() macro")
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/traps.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -276,10 +276,10 @@ static void __init test_monitor_call(voi
 		return;
 	asm volatile(
 		"	mc	0,0\n"
-		"0:	xgr	%0,%0\n"
+		"0:	lhi	%[val],0\n"
 		"1:\n"
-		EX_TABLE(0b,1b)
-		: "+d" (val));
+		EX_TABLE(0b, 1b)
+		: [val] "+d" (val));
 	if (!val)
 		panic("Monitor call doesn't work!\n");
 }


