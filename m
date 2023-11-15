Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D22364CF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyQjlcZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2809DC433C9;
	Wed, 15 Nov 2023 19:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076342;
	bh=LCdbfv1oWqVcFQX7LQIJBzT/IeHrIgp+W/EgPtY8IZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyQjlcZyhPcQKqvq9BhkQIVGEPsolOgH8OQczVfo+w2XcLi9Q1ZrZy0yXDNYaIIZg
	 +YD5rJmytMC7Zqs5j8o5/g3ujiKtMWTLHjUccocZpZlIIhEPJg2gXE3Adco3gKiM8U
	 ByUZzjmf5s5cpzIcSV7pf2YkhgYXR3Fh3O3QHu5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Sierra <alex.sierra@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 231/550] drm/amdkfd: retry after EBUSY is returned from hmm_ranges_get_pages
Date: Wed, 15 Nov 2023 14:13:35 -0500
Message-ID: <20231115191616.739559575@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit ebac9414a56a5f7c336db5f5c7cc34713b649407 ]

if hmm_range_get_pages returns EBUSY error during
svm_range_validate_and_map, within the context of a page fault
interrupt. This should retry through svm_range_restore_pages
callback. Therefore we treat this as EAGAIN error instead, and defer
it to restore pages fallback.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: eb3c357bcb28 ("drm/amdkfd: Handle errors from svm validate and map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index a9b57c66cb7d7..4c1b72194a6f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1651,6 +1651,8 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 		WRITE_ONCE(p->svms.faulting_task, NULL);
 		if (r) {
 			pr_debug("failed %d to get svm range pages\n", r);
+			if (r == -EBUSY)
+				r = -EAGAIN;
 			goto unreserve_out;
 		}
 
-- 
2.42.0



