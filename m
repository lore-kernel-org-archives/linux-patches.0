Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060081;
	b=IwRO11NmfAxl2APQdQTzIdNQljA8lq2M7QwyOFHsbnmv8c8L8zjjszFBxKyFM3b7Dgjf
	 XfgEsNXBOpA2o5zWE5D+kFeM37/2sOqBXfOJy/8k1MfIy/Xd1908320egLY2TD8zCJoMr
	 JaVTlyUtVY5WC47j6060Hnq8FBCOzVcyv8qVIPTcb+VXf89Z1sEK1Bz99KYw0aHP8B4JG
	 aalXDZkLhX8/Gp37g7M1J0iXi4ouF89Lmo6UPoi4CPijnG99H3n2uYbeeBTFUDz7LTSdq
	 9q1+7BUMqk5O/QGaZsmRa0I2ja0rM3ACDHD2e1R1aId/uXVM91eZEuFNjVMuuVm8FLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xc+qTG+iSiT5QTqDD+OxedH76TUlp5i0MXdJWJFPfzc=;
	b=3H0f0pP3FxhUaWeVysOUqt0R4kkRgh8rp5u8OlKrXADPTU2UvU7k5nQYyzgB+ZyyEGAD
	 /mfvnT52s6Xw/82amQJTvJ0lYMj2DloC+wUFpwoBD+QinupRPOZ32dXP70oy+HhAQwoSC
	 xy5aytwf3BIbcPjIlLGlWQtRloZGIpR1375rolUe8mXdpNDgBffZ56+xEviepYlJ8Y1By
	 EA+/H/plW8qzLNruGRENfWLhitAo/r0xumy/iYPZ9bKQC/aDeuXQ6VMiTT4wmwgtSUQ7x
	 vDVAF+6n8f8faezj+kqlf201hlDodpczAJeCJI7H2azcsdRivo1gTrrMxsHkt8OOQJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tACdtVfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D5A606A326;
	Thu, 19 Nov 2026 03:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tACdtVfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEBF1F000C4;
	Thu, 19 Nov 2026 03:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060080;
	bh=xc+qTG+iSiT5QTqDD+OxedH76TUlp5i0MXdJWJFPfzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tACdtVfgq37xHLqhlWdFlIgOg2z0qfVKsXjNlOAyeZBXJLn1bA9l3TQUvQ7CD0R6O
	 w8cQWVMDiAqXjE6W84jUyuyehGHpo2w16Xngs9XyfXrJtkM+HV/bFkWPu5C+h3CXwC
	 6J0AOCjS1d9u82l2MnxImR2cXdcpK+RZDfhO9wV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1072/1848] mm/vma: dont leak the charge for stack growth
Date: Wed, 18 Nov 2026 15:51:50 +0100
Message-ID: <20261118150002.825130174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b1ee87802111156e27557e82acc31fa7dfc76e2a ]

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-44-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: replaced vma_test(vma, VMA_ACCOUNT_BIT) with a direct VM_ACCOUNT check on vma->vm_flags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 290822968e218..8b819f050ce50 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2399,7 +2399,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0



