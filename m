Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44CC3D6CA9;
	Fri, 24 Apr 2026 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038213; cv=none; b=uEkocBEym4LrAOepYbO42X5om+W9OojMEDDbLgkc9Foq1TBLLaQ/UeNCt9ZbkJ5mgDQ7//9evYTudPhc8LgXQUnlJgqlHUR/NsF5+aVpWBPZEqEAQy7b+2oJZKt7R3WtLGc4dkqfD/Z7x7qaMGbwPl9k+bvjqxZRIMCfviFomyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038213; c=relaxed/simple;
	bh=4FXg+BY0MuCXVTTaWdbK9CZD+6osLPreTXIKwNkJLkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jo69PV5H4OH0oTHdJqFJlm5ALCTxGFqvmUbMRyulnVjLJNWLji5G1MnA+yGk5EscMrg1UXcw1sedlV3Dft4uRJCGQBC+r7YXFJMkqlpp4IinVS2NI7OHAbIpl+/UBzhjSeIY/ZJ9I3TmHKxrqFC88l88RtTA2OfglVxbAjj0Gt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ilv5U1VT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ilv5U1VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E45C19425;
	Fri, 24 Apr 2026 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038212;
	bh=4FXg+BY0MuCXVTTaWdbK9CZD+6osLPreTXIKwNkJLkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ilv5U1VT2H4N+0JhL7VcVDjrTBBtbnjRVylRqiGK79ZTgCMWMUVx9Uk4zxz+eMQDo
	 33uDlm61bE2+mRB/ZNqFyI3RpclJNIF+ePsxFZ5Zgv37ey4/ckQIv8+EWkHsvOcYeF
	 DF5K+a2spuu2QHns3y2/O9CTMuOLIijJ1dfcnYms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Chen <chenste@linux.microsoft.com>,
	Baoquan He <bhe@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 04/35] ima: do not copy measurement list to kdump kernel
Date: Fri, 24 Apr 2026 15:31:11 +0200
Message-ID: <20260424132412.432475277@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Chen <chenste@linux.microsoft.com>

[ Upstream commit fe3aebf27dc1875b2a0d13431e2e8cf3cf350cca ]

Kdump kernel doesn't need IMA to do integrity measurement.
Hence the measurement list in 1st kernel doesn't need to be copied to
kdump kernel.

Here skip allocating buffer for measurement list copying if loading
kdump kernel. Then there won't be the later handling related to
ima_kexec_buffer.

Signed-off-by: Steven Chen <chenste@linux.microsoft.com>
Tested-by: Baoquan He <bhe@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_kexec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index cc418a7e27f20..501b952b36981 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -129,6 +129,9 @@ void ima_add_kexec_buffer(struct kimage *image)
 	size_t kexec_segment_size;
 	int ret;
 
+	if (image->type == KEXEC_TYPE_CRASH)
+		return;
+
 	/*
 	 * Reserve an extra half page of memory for additional measurements
 	 * added during the kexec load.
-- 
2.53.0



