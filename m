Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF44158211;
	Tue,  9 Jul 2024 11:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524095; cv=none; b=XEZm0zEU8dmwwCGo7eNVbCm6N3epJspeJTpKY7lbr3prqEW9zVE08k/fRsNz6NjrzVPJCSUwpWeOdt/+IzEvkGNE5wYJ5QmX/0rjYe6S5cgZ2J41zNBKGJVjdCEUqcHQzjkBmMLacQcSGeXOTe2iV3OSFk2SHqvX47qlTqETjWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524095; c=relaxed/simple;
	bh=IjmwyOGTIdKTPKS/aQXWzCMFsdraYI2nznAZEphCN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfNaZh2bUuwFpdTQy/QqV3s72kUI76skijYAhir++yMn82U/RAH5ntt7WhGBBlvYj7T+hZ6BPTqk6ZACFs5Pq1hjSi1kVEWbKBh3S1Dwcq7MdSDM7o6D7RJmJEPuCTDRbgygcLlKrtAQIcVamcRoBOuAJZvmNY8rmBfJdYDJ0Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7KqRuVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7KqRuVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31318C3277B;
	Tue,  9 Jul 2024 11:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524095;
	bh=IjmwyOGTIdKTPKS/aQXWzCMFsdraYI2nznAZEphCN2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7KqRuVGTxC2+yiqQDNHgTszIDQgVyNqOXQWECGZoM0BBt7aOutoock2nx/8TttDo
	 X/jOxlAZCbmb+puFnsI5cxNHZg+x1s2OdrfJhbduQxuzwuqwtNQMgPggmGLPWNGU5y
	 BtJiiunLeSbSwmOLpI4M/1NlAVShAphdKei3C8b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 027/197] drm/amdgpu: fix double free err_addr pointer warnings
Date: Tue,  9 Jul 2024 13:08:01 +0200
Message-ID: <20240709110709.968157432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

[ Upstream commit 506c245f3f1cd989cb89811a7f06e04ff8813a0d ]

In amdgpu_umc_bad_page_polling_timeout, the amdgpu_umc_handle_bad_pages
will be run many times so that double free err_addr in some special case.
So set the err_addr to NULL to avoid the warnings.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
index 20436f81856ad..6f7451e3ee87e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
@@ -170,6 +170,7 @@ static void amdgpu_umc_handle_bad_pages(struct amdgpu_device *adev,
 	}
 
 	kfree(err_data->err_addr);
+	err_data->err_addr = NULL;
 
 	mutex_unlock(&con->page_retirement_lock);
 }
-- 
2.43.0



