Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59131DE2CF;
	Tue,  8 Oct 2024 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391796; cv=none; b=WEyz7abZLNM3x5VDhARruWOz1ErBlyTRmFpAoWvCXy6frsBnJfsJm6Dmj6zM34AfSD/6P4I8lkwQFt6S7C4tH2kEd7EkbqyGWnJRd4o8jGvpFzddDirk4JXqfZzPa+19pG7hGIBn/LsjwixCGVyWodPkrpC0TDZ5JWz8cF0O6n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391796; c=relaxed/simple;
	bh=JZNeuNXTPViikHWTCE6PisxrsEomDLJKuylAYjMLiI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WcT8inxDbSjqEToF+om2d7QJinTdwXdRGMm3mwACEo6L8Ctg5etb2w5ceQbYNe14INdeMUFI7J5Z0ge7xD5x2yIAufhePIzThsR95g0FXhS0tOxSklE1YLBBLKtmLV9TbvVRox6lv1teAprYpot42Ov42z/Ns3CVO7aKb0PCuN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWijxuC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWijxuC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073CEC4CEC7;
	Tue,  8 Oct 2024 12:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391795;
	bh=JZNeuNXTPViikHWTCE6PisxrsEomDLJKuylAYjMLiI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWijxuC7f7ynXluSXZxhbFqiKnjQlDSJ44RhG8jq3lXWVWPkTVXHQeLKO3/VNQ/G0
	 ZDNnIDlDNtOwJRhlF9R+GjNi2TPVfd6UTW9EFd77a7KTtBgHJBN7zu7qaphk8eWVB5
	 If+EdWf2Kgt51PjAdOB9XJJzucrPVGmk32FDVRCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 207/558] drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit
Date: Tue,  8 Oct 2024 14:03:57 +0200
Message-ID: <20241008115710.489493054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit fec5f8e8c6bcf83ed7a392801d7b44c5ecfc1e82 ]

Before this commit, only submits with both a BO_HANDLES chunk and a
'bo_list_handle' would be rejected (by amdgpu_cs_parser_bos).

But if UMD sent multiple BO_HANDLES, what would happen is:
* only the last one would be really used
* all the others would leak memory as amdgpu_cs_p1_bo_handles would
  overwrite the previous p->bo_list value

This commit rejects submissions with multiple BO_HANDLES chunks to
match the implementation of the parser.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 6dfdff58bffd1..78b3c067fea7e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -263,6 +263,10 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 			if (size < sizeof(struct drm_amdgpu_bo_list_in))
 				goto free_partial_kdata;
 
+			/* Only a single BO list is allowed to simplify handling. */
+			if (p->bo_list)
+				ret = -EINVAL;
+
 			ret = amdgpu_cs_p1_bo_handles(p, p->chunks[i].kdata);
 			if (ret)
 				goto free_partial_kdata;
-- 
2.43.0



