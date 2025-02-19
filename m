Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2F11D47A2;
	Wed, 19 Feb 2025 08:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955098; cv=none; b=uyrtqKF1rMLfznYI3/hlz5Va9oYjncjp48o/T4kPSoDVW3X/WAZkbhkzdftIaAXsI7P9xa+5RbndmbtCKToQJ7t+Gi9VcSgOvM/60Vs1otaoL2Q1MAprCYiz9LNDNqRkCFZ8aMK6MCbvj91w7e89ZhWym3To+j44c7MIWAHWYKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955098; c=relaxed/simple;
	bh=HGrnZXnPN81LzYrRBpASryEm6CzYH8724BcknCk50ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaUibBClpY0hiOpVJRdwEab73/Q6HGuzlY0MOg2gdS93+DLErt+ezUdRq0bQMAemNjsRRYGrBiMYHIYBa9DMKPnha1v78bikkucTjF1XxZ2UcI+H78Y+37KhNpiRtXRqp97azS8t8HLtzPD5Mf0DS5q0gnjGgoB19Fql4jbVW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MI8/UTMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MI8/UTMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D94C4CEE6;
	Wed, 19 Feb 2025 08:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955098;
	bh=HGrnZXnPN81LzYrRBpASryEm6CzYH8724BcknCk50ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MI8/UTMiQACLdKzoHwfp1MH6XxJE6VAH1hkqMo2nEyB90GtIxqLReNAmjNR48WPpZ
	 Ll0UyzsXySZYRE3fmt9AUheWPy8KEllzKxaxZBXKOGQZSAqg0SosEoekyyS5tFyhAf
	 GIG0aWsLJfDfwTKVfMP7rkqZ0YQSTXjlDXVCrdZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 099/230] drm/amdgpu: avoid buffer overflow attach in smu_sys_set_pp_table()
Date: Wed, 19 Feb 2025 09:26:56 +0100
Message-ID: <20250219082605.569700904@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiang Liu <gerry@linux.alibaba.com>

commit 1abb2648698bf10783d2236a6b4a7ca5e8021699 upstream.

It malicious user provides a small pptable through sysfs and then
a bigger pptable, it may cause buffer overflow attack in function
smu_sys_set_pp_table().

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -607,7 +607,8 @@ static int smu_sys_set_pp_table(void *ha
 		return -EIO;
 	}
 
-	if (!smu_table->hardcode_pptable) {
+	if (!smu_table->hardcode_pptable || smu_table->power_play_table_size < size) {
+		kfree(smu_table->hardcode_pptable);
 		smu_table->hardcode_pptable = kzalloc(size, GFP_KERNEL);
 		if (!smu_table->hardcode_pptable)
 			return -ENOMEM;


