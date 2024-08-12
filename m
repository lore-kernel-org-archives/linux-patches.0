Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1916A15C127;
	Mon, 12 Aug 2024 16:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480363; cv=none; b=te9CiBpNYfK0/3ThSg09524bVB2o9+J+FEl6X3lwCdSAsMBT4qXc5dxEtMSInik+lgqhqdtI2QFilxKpq6HkaXS3KfkwKnZYXZTgXznXbAfGuAOxg73GGmCO+Friwo2Y+K6GQiDlJxy+NDMf11WAMMnKv0MFxW7y2bZRTihbfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480363; c=relaxed/simple;
	bh=3LC2DWjzZnyVjnUl8W0CFBXSE+LE4PWMdS3JIOWIN8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rG6SB7BUuOboaTJGz1YX0w5bBUv45L67qvQYPeekFKiJ96KZwRHDeEljS8gOlxVdv351ERHSJUQvefPTC7Vfg2ul5Bwbnb2hbhYshRybUkZIdFxl1BWlJFCQLcKc0J6k8Xl1JjZjxEPh5ihyiu6a4CVI4G9WdZm8E+RsoG4TF+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sW96PBE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sW96PBE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714B5C32782;
	Mon, 12 Aug 2024 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480362;
	bh=3LC2DWjzZnyVjnUl8W0CFBXSE+LE4PWMdS3JIOWIN8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sW96PBE8oclpK6BG06xhyIYta1VL2HNbWkqao37VZ9OsV76nHTakvwqaLbcK7Z+TD
	 DbW8Or7SwEqN0SLrfoME45iVgHKdWlbDhQde9TeXtJUFU9zuqp0thZ4jfq4k9C7uqB
	 N9MvFZHktoqInI/gQs+SDZmD3YPGko5NQ0Tm8b60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 174/263] drm/amdgpu: Forward soft recovery errors to userspace
Date: Mon, 12 Aug 2024 18:02:55 +0200
Message-ID: <20240812160153.211048608@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Ashton <joshua@froggi.es>

commit 829798c789f567ef6ba4b084c15b7b5f3bd98d51 upstream.

As we discussed before[1], soft recovery should be
forwarded to userspace, or we can get into a really
bad state where apps will keep submitting hanging
command buffers cascading us to a hard reset.

1: https://lore.kernel.org/all/bf23d5ed-9a6b-43e7-84ee-8cbfd0d60f18@froggi.es/
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Reviewed-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 434967aadbbbe3ad9103cc29e9a327de20fdba01)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -262,9 +262,8 @@ amdgpu_job_prepare_job(struct drm_sched_
 	struct dma_fence *fence = NULL;
 	int r;
 
-	/* Ignore soft recovered fences here */
 	r = drm_sched_entity_error(s_entity);
-	if (r && r != -ENODATA)
+	if (r)
 		goto error;
 
 	if (!fence && job->gang_submit)


