Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EF11CCB32;
	Tue,  8 Oct 2024 12:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392044; cv=none; b=Arj8Bobq8Fvp+DfcHPmpIdUbMQ84WfPX2ATz6Xmfj3y2wgskRX9CTVqnQ8OLCcJtiIJqo0vQ9NSwMMpnt2Q8zM8dHK8xu68LksJ1eJUVVQhlv7/m4I9sYFkgorISda7rlzJ/Y/V0B+ZoiIJcWAmDh5HIpsQj+1aQXveenA+tuCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392044; c=relaxed/simple;
	bh=o2u150M0/8kim3OuWoRmlGFeHLGv+avUpYRa14m83Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD0Hz/HPSpxKKCf9/ehblGO0AVBtkfmybVe5VqXbvfD1XvOh1uZaCK3+W8kVAb2XDP/0OECWaV9MXUTsKNQ7WWTSihbH6/4xh28VPBnrrYewRmf7738BiLTfQIr7/j6Ekbh/m0egyX1SBZo9UQ4VnaXCGv1U+9INEBqFLAOUYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qE9p8Sgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qE9p8Sgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE4BC4CEC7;
	Tue,  8 Oct 2024 12:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392044;
	bh=o2u150M0/8kim3OuWoRmlGFeHLGv+avUpYRa14m83Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE9p8SgttT9tVGKLYYOh1HghNmiWlzEtzDKSQEjZgyulsVHNznkZHA6jzT4BdczfZ
	 OqrSoPDOWyvxwK+wFDJIGlXSsNJWZ9iUPhnJIpa2y/Vib+N5z2x3HViy4Cp/pfsblU
	 JjYh8VG1b7XIkv1LvFb1zuLqW5I+rVTWnpx7Lbuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Dexuan Cui <decui@microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 299/558] tools/hv: Add memory allocation check in hv_fcopy_start
Date: Tue,  8 Oct 2024 14:05:29 +0200
Message-ID: <20241008115714.086859780@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit 94e86b174d103d941b4afc4f016af8af9e5352fa ]

Added error handling for memory allocation failures
of file_name and path_name.

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240906091333.11419-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240906091333.11419-1-zhujun2@cmss.chinamobile.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_fcopy_uio_daemon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/hv/hv_fcopy_uio_daemon.c b/tools/hv/hv_fcopy_uio_daemon.c
index 3ce316cc9f970..7a00f3066a980 100644
--- a/tools/hv/hv_fcopy_uio_daemon.c
+++ b/tools/hv/hv_fcopy_uio_daemon.c
@@ -296,6 +296,13 @@ static int hv_fcopy_start(struct hv_start_fcopy *smsg_in)
 	file_name = (char *)malloc(file_size * sizeof(char));
 	path_name = (char *)malloc(path_size * sizeof(char));
 
+	if (!file_name || !path_name) {
+		free(file_name);
+		free(path_name);
+		syslog(LOG_ERR, "Can't allocate memory for file name and/or path name");
+		return HV_E_FAIL;
+	}
+
 	wcstoutf8(file_name, (__u16 *)in_file_name, file_size);
 	wcstoutf8(path_name, (__u16 *)in_path_name, path_size);
 
-- 
2.43.0



