Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE2404BE9;
	Tue, 21 Jul 2026 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655170; cv=none; b=GsZTJrgA0h0e0TaXGj/ynWbOYSatzDE9NNgV5ENZ1U+NtL7k7aoMtOSqbqppK+Et+0lmz+6ig9RCcujyhUjgoKeTutMjgzguL9C2e4kPgDI3pfO8sM3EjB7oZQIGdmtpjCzCELz752TH13m/0pUCZfNydFZX5ZCIjDXi6+pAI04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655170; c=relaxed/simple;
	bh=NbCMMLwnGr56J6oLKpLLUYx6H1AtEYj6V6Wu8LUYlmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yxko0o2LRMHVgTtGeK1dayu7z4N7c4ITkHkfGltH2BsXI/kJFl4MLn5a3mcDKX+TH25YTPxxFF6CJqYJPEX3Dg+9V5fQoH8Y4GRN34Ms6EZCBgTprI6LosuPz2eEtB5KNscldFv1+MU5LCrTmZLfPM2m0pilLb5Y+8qj8teQxcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13qedR0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13qedR0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44AA1F000E9;
	Tue, 21 Jul 2026 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655169;
	bh=EUWEX+QG9ZOfjwecR2j6XxDZY34Vk9SHGsjJ57wpaBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13qedR0FdP/o8NwPPlq04/g2fSErlE2o5U0p9SPVvPA+U+vcHKF5rUfS4f+qCp76Z
	 w9ZqaKYvyEENPNfakg/0Hd+X2I+AI0mM9KIJfX5Ey49jxI/3KEZj6BLHVkkV3qBh00
	 UZkqyuaTrtSkfa1LfGVnRH79JLN50DljRepLZkis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 1980/2077] amdkfd: properly free secondary context id
Date: Tue, 21 Jul 2026 17:27:33 +0200
Message-ID: <20260721152639.411112782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Lingshan <lingshan.zhu@amd.com>

commit a88419af8dbd5abf8b1dfdfd9346376bce5413b4 upstream.

Function kfd_process_free_id() should skip over
the primary kfd process because its context id
is fixed assigned, not allocated through the ida table.
This function should only work on secondary contexts.

Fixes: fac682a1d1af ("amdkfd: identify a secondary kfd process by its id")
Signed-off-by: Zhu Lingshan <lingshan.zhu@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8799ba6fb6a48438aea20c82e74c2f2a3d2b2e7a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -910,7 +910,7 @@ static void kfd_process_free_id(struct k
 {
 	struct kfd_process *primary_process;
 
-	if (process->context_id != KFD_CONTEXT_ID_PRIMARY)
+	if (process->context_id == KFD_CONTEXT_ID_PRIMARY)
 		return;
 
 	primary_process = kfd_lookup_process_by_mm(process->lead_thread->mm);


