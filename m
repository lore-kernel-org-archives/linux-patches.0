Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E4183CA6;
	Mon, 12 Aug 2024 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479510; cv=none; b=ifkFmBcmxSN/1Fs6TjYAyNrYc4jhhfhnQ0+/oKUnNRYJsRaHWHJBxh79wS7ec1mAVF7oDTJfmUKTlMTefBt0RfEi7N5VbxqqoBvVTEEYarGJMfIZ5s9cMq/pSWchFN9/LssaUT+7CbgADnwY/Qfw5SRXYxhB2s1YdgXUzoV8J0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479510; c=relaxed/simple;
	bh=j+6gWFIwypOv+jwmlVB7tUy5HSntSPjPIlTSYAoqkYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHUkdp/nbrCY7H4VmaIVgU//bLOWTsGycb+UcpxoW5j5GfE+8JoqEb4RRQLAfps3xkJA3hk0MlSQEK1WjDWTuetJEpdEyZlV5rYFK9PpYSQFebw5h5C6b7prfrYw5kog4zeCMl4DELhDVseDSv9+pwOeLUmAI7OF2WdC0t6FXF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ju6FjUO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ju6FjUO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536B5C32782;
	Mon, 12 Aug 2024 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479509;
	bh=j+6gWFIwypOv+jwmlVB7tUy5HSntSPjPIlTSYAoqkYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ju6FjUO1rNRAZlP/53sSil0wKfmQ4wnIb41RFVIdeC3oo/323RJYiV4Nml3sUPpsC
	 SAbMRCYEzQujINIdn/x/kNv/S5FVav8pjM8G7JzLtaOtyDe8A28jhLv7OjOcEjfsDh
	 IsZeVjapvDNCJoA8hYPo9kgA0D3FvPwoGCLjW+qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 110/189] drm/amdgpu: Forward soft recovery errors to userspace
Date: Mon, 12 Aug 2024 18:02:46 +0200
Message-ID: <20240812160136.376277658@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -258,9 +258,8 @@ amdgpu_job_prepare_job(struct drm_sched_
 	struct dma_fence *fence = NULL;
 	int r;
 
-	/* Ignore soft recovered fences here */
 	r = drm_sched_entity_error(s_entity);
-	if (r && r != -ENODATA)
+	if (r)
 		goto error;
 
 	if (!fence && job->gang_submit)


