Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6113F12C805;
	Tue, 30 Apr 2024 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474507; cv=none; b=Ddminwx3DSQBOkfxRajW88cjzQXMGQgFLHkFy00sjtp+Fprn80GJfri4Az8MdA4EY6uHH/k+4dd4UzmTLcLQOkE8v2y4qCXGOX4kj//+/yMT3oPZkz7UAygava4NevCXWtK8y3jARX/c5EOtEASy2EcE3wdtfaK4v8hxfOIZ6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474507; c=relaxed/simple;
	bh=l6VVWWY3Pzi42Y9W1FLDlNXghuNGapa5KnTqMu6ZFXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkPDNq86s/O4wwSJzj6sIo387cJ5h2GMY0j1QVFSLNMjIwHe+xtn6RZCBL45fOSR3TpkMRu7q89HZ1p1qkqdc/OWEJnGf3qbgbCvS6rYyImGBQQsV959PQM7aingb17p7xa6L/CaJvJ9Hhm3lIujGMyElOJKtzxcts2SwgY0fSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaybEbBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaybEbBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE621C2BBFC;
	Tue, 30 Apr 2024 10:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474507;
	bh=l6VVWWY3Pzi42Y9W1FLDlNXghuNGapa5KnTqMu6ZFXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaybEbBkkBUfvDt2oYTHAJKp/TzDAq09n13TtZ8wCxuc00paOrXsGwy1INbcZOTYJ
	 LqmvWMLXpRBQ4oECFQno9ye8sNl02b9FW/UkNjlLV8pRRVOYlsdySv9SR22m25UppI
	 E3ukukLi6U1m8NyOfkBMoNgs7OSDqHijna0061ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Veerabadhran Gopalakrishnan <Veerabadhran.Gopalakrishnan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 177/228] drm/amdgpu/umsch: dont execute umsch test when GPU is in reset/suspend
Date: Tue, 30 Apr 2024 12:39:15 +0200
Message-ID: <20240430103108.912086639@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <Lang.Yu@amd.com>

commit 661d71ee5a010bdc0663e0db701931aff920e8e1 upstream.

umsch test needs full GPU functionality(e.g., VM update, TLB flush,
possibly buffer moving under memory pressure) which may be not ready
under these states. Just skip it to avoid potential issues.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Veerabadhran Gopalakrishnan <Veerabadhran.Gopalakrishnan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
@@ -766,6 +766,9 @@ static int umsch_mm_late_init(void *hand
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (amdgpu_in_reset(adev) || adev->in_s0ix || adev->in_suspend)
+		return 0;
+
 	return umsch_mm_test(adev);
 }
 


