Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989A5921F1;
	Wed,  9 Sep 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964437; cv=none; b=Xj/CXemWHKk1URR9f2Cni7aGsHY9WQXMLt6nxMkSrPYl5LwggYI7rPYyMWurn/GQsEEjtIix275iWnq2M5jNj+PCC+aBl/OWRUNAreAyBKKPbBFnlTlRQ96g96ndAbEEVUUTnyLft0ZfjtvVATZll20bF+O/XrMQG70HB2C8H+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964437; c=relaxed/simple;
	bh=ES/XNylNOoYPupwgYtlguvKrqShp2wlMEQGg/B5wKoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWWwJbIN/eWT2DdoBdJ/Xou/V7ha86kBzFa+DJkUIL32/5Ui0DT5GFDT2JdRpDyngAhtsXfILKx2jAWHD65qdrJ1YWkyBqTm/+hjIkt4yj4ic5oix3NebUf1Io5pteOV4FYb/s6RbYynFCxIKDY8PAWnoaHhVxdxs0OcIjZKdXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbEUK6zk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbEUK6zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17271F00A3A;
	Wed,  9 Sep 2026 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964436;
	bh=SJhC1jAcHwD0r1ZNBpa4b1BFVOGrxoKuu1+5Eb0bG1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbEUK6zkpHSRRzeCDqN2skqzXrisT3nD8BOwPSp/MMSaBjG2OtRd5IDzmyGfL9QwO
	 lM+KqUnrLKJ2j+XuhGIGIsKdzFSTS95z8J8tadKCCARyvvmrnzfyiKDJwx1yo5NRpl
	 pRXXB4NZT3rEvOl0gWzggZCQtV/ispWdKtFncGw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 395/583] drm/amdgpu: Skip accessing psp rum time db for APUs
Date: Wed,  9 Sep 2026 15:41:20 +0200
Message-ID: <20260909134251.680356929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>

commit a26301203a196a991527f7b1ab884d4dd0e7c95e upstream.

Psp runtime DB is for dGPUs only.

Signed-off-by: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dce8195027f146467c9378efb2bb1b0859cb735e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -372,6 +372,12 @@ static bool psp_get_runtime_db_entry(str
 	bool ret = false;
 	int i;
 
+	/*
+	 * Runtime DB is for dGPUs only.
+	 */
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
 	if (amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 6) ||
 	    amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 12) ||
 	    amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 14))


