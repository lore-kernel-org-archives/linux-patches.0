Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D842D6622;
	Thu,  3 Jul 2025 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555381; cv=none; b=nXh5IUQlnGZq0camI1zCV7Mil/Tshl7Sv8t6bgdDJ4RRWM4ep4euKz4zUCsE9zwGIGA3NOrzwM40fUfQyuyQMJuJFZMuiQlRyWYJSfufaCTLLqUtY9BdSE9Xih8V8dgFFc+T/wiNzcBlogPAQggat6D2agpNLTf57IXnM3Tv3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555381; c=relaxed/simple;
	bh=pcal3LwAprzdM1Fd+xzUqEo7ZD2S+EQTjPdeSGmuDuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/8UxklrBohFna3nsTDFwKv5b2OlJ98hXYCsBCb0uH20ZMt5MMkjO97i4kzvpDXbJV/+EBeHwfOZYsA5YrXf8N51Ke8U2NiWOoKzFSUGH8vRsVWs+E6X+6GFyl4kgujn8SeTRGvDu+C9tPfSxqNOZU6umzL7oP3lhZVvzRX7e1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrlkfHho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrlkfHho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3417CC4CEE3;
	Thu,  3 Jul 2025 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555380;
	bh=pcal3LwAprzdM1Fd+xzUqEo7ZD2S+EQTjPdeSGmuDuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrlkfHho6MLoC+MMyR14lwsj/FH0Cu/373gFnZfD+ib7BjbFEx8Hm1OxhSCCy/pdS
	 HaNWUQlXc2jFj7HxDM8jTLcsQ3MdOKelUGk/ljjrxC1iClGojMs2jKBKTQk2eMHX0I
	 NK516BveoDYD85FR8Tmw3LfjfbtQaBgr1EOSG4/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 230/263] drm/xe: Fix memset on iomem
Date: Thu,  3 Jul 2025 16:42:30 +0200
Message-ID: <20250703144013.621204663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit 87a15c89d8c7b00b0fc94e0d4f554f7ee2fe6961 upstream.

It should rather use xe_map_memset() as the BO is created with
XE_BO_FLAG_VRAM_IF_DGFX in xe_guc_pc_init().

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250612-vmap-vaddr-v1-1-26238ed443eb@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 21cf47d89fba353b2d5915ba4718040c4cb955d3)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -1053,7 +1053,7 @@ int xe_guc_pc_start(struct xe_guc_pc *pc
 		goto out;
 	}
 
-	memset(pc->bo->vmap.vaddr, 0, size);
+	xe_map_memset(xe, &pc->bo->vmap, 0, 0, size);
 	slpc_shared_data_write(pc, header.size, size);
 
 	earlier = ktime_get();


