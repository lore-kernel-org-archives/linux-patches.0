Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94CE2DC783;
	Mon, 17 Aug 2026 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977258; cv=none; b=XUjpJgnMkJSxMDlUk0c05FxFkgvXNyI1sokEVYI9b3dvL6CzWz1VqXO2S3IoU3dB3v4IP0+QME4trX+qJm6wNesVp/yMvpj0nPC1c5dlkt7upw5reQtNarP+cMJdX9tddUL4zQ95BEGe1nO8IBpeyQ/M66jewz+doWT3Lgz9LM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977258; c=relaxed/simple;
	bh=Rc/odrJdqhkogeQxePBboLPLNnBxOoXVc3MOj2JmjCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzTASjRxP54MhhTXQlWIwicrS2HccRyzLLJOMHSlkvqh75Kd8Ik/BESTYJnnx0rCC8X3jGo+1mDaOfd6o1TLJPaGOI8+YjCxB4owdlNzoxa7obJZYLFY1FfuN02dqrk/UAx2/Y40JVuBPcGnc8tRuK8MjsjcvTrtFdaaFgYOMEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARt3fR12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARt3fR12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022E61F000E9;
	Mon, 17 Aug 2026 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977257;
	bh=utrRB4H873WXcS0swQl4DmoEFHV7Gxg45r1ekZUcdqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARt3fR124qbWzOo1Fk9BnGPrL5Wjfc/XDSSbe4FA6Ru1RsSvDdFWg2zifD8419lDO
	 G2hnsOHbitVDWJ1Idorb5bXTGBFK7+9z5qc3X0kBEqM6n8EsTuWdvdNosaU4B9KIDY
	 3RlrZyiLtNi6iLmxJTD3X1f0D2oiZKn+IFFj1WJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 230/456] drm/amdgpu: invoke pm_genpd_remove() before freeing genpd
Date: Mon, 17 Aug 2026 15:30:20 +0200
Message-ID: <20260817132549.116141762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

commit 28c9b3c5dc35cc790d11e26ca3fc6e068be63998 upstream.

Call pm_genpd_remove() to unregister from global list prior to releasing
acp_genpd memory, and clear the pointer after free.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd8650d7a91ee8b768e202354672553faa5cc1f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -466,7 +466,9 @@ static int acp_hw_fini(void *handle)
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
+	pm_genpd_remove(&adev->acp.acp_genpd->gpd);
 	kfree(adev->acp.acp_genpd);
+	adev->acp.acp_genpd = NULL;
 	kfree(adev->acp.acp_cell);
 
 	return 0;


