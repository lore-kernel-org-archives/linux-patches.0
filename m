Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355FD1DF27C;
	Tue,  8 Oct 2024 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390282; cv=none; b=a/1SJ8P0MT6zgBJm38RoUQoje4bstU80b/1QoBG/I2QrYfhEzWwgpRuCa4xctuasQDZJNI2VDJNcnjPzGsY9vmP7k5H60prZORIra7M4eiNQTl3khvbaMiRrldHloBQuID4+rvZZ3xkGR0ZnVIzXIKs1pYCMQNPRe3Lb+Of1pLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390282; c=relaxed/simple;
	bh=2dxySYWyf4Z9YW3D5OpQbiONkQmgPSFEH+PWce8+rZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzHWUszKhB6Pha4WbEyAsqpvCA4gP1TqmbKPPNgrgMmoDOADXyT5IP26PlpU779K50IREA3DDth7BcGWsMxIC+9fsaBvhGupMc5fGD9hF9h0YQc4YKcQRG+Az4ol+1DEAHC+Nxj0xIE2/ffIk2m03asMkFtP+Wfb2nXkrSUTf2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+XxoxBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+XxoxBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76F8C4CECC;
	Tue,  8 Oct 2024 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390282;
	bh=2dxySYWyf4Z9YW3D5OpQbiONkQmgPSFEH+PWce8+rZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+XxoxBoBubGcr0mPi18GfDeTydIkUPA2M2v9gqTsZ7ZlkFdtfBugjJAcYFkSoSko
	 bwCT3hNOH3aPKwfxLnAZZyyc/p7JsoSTDe++pX7paPQxksIOg0Qca34mbrOkclgnmG
	 vyjYOHB6fSKgUu9nNyBrbUqc8DNgvx/pe2+eI1p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Dexuan Cui <decui@microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 244/482] tools/hv: Add memory allocation check in hv_fcopy_start
Date: Tue,  8 Oct 2024 14:05:07 +0200
Message-ID: <20241008115657.897962956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



