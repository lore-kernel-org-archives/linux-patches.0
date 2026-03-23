Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1279A3BB9E3;
	Mon, 23 Mar 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279153; cv=none; b=hruWZizaebh/P/jO8HXAnlIo9u75trXwaTKzPY8PUgftOnGxBC6aEJBhJ4ozjaguom4YIRAJViA7sFcBOAyd37vXIUKdBstj7tEQqPBrEFt4dCA6ETvb6KknooD9X0mGqL6gONpkK27RoKpuSpvrcfB30N24IuDax6qcl8NSZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279153; c=relaxed/simple;
	bh=ldpwCz7pxNXmj4dIqhFgLD/IH+aDV8ZuBSWnuH5ZpYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhI6LZ/250mnawrNmGExj//acw6Gh+do6xad7SRIFjvGLmPoTD5JpDXEHzMbz+j4/8lRZ5CgBNwUCDbfghYvrQ1nTD7jyiOlx3y5gJk2VEQxxBxPl2M7TYskLp4PouCyvRlR7ZJKsow5l9FucAD7uwrVRjIefyu1rpO7MBE9nlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMTKXNVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMTKXNVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A96C2BC9E;
	Mon, 23 Mar 2026 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279152;
	bh=ldpwCz7pxNXmj4dIqhFgLD/IH+aDV8ZuBSWnuH5ZpYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMTKXNVBGuGnJ22MRwJrkGjRQ57wgRCD18OJt0LiyM2hVrTxqkEMPXLJVKifX0Bsm
	 TrluY9bqrl75WMM/1R7wwECjxKiszBS6pDx1RV3CFl8oESQF7TZ+1Og/vtxmGBv3EK
	 h7BjUSUjGqjYbFTDWQ5WpkH/seoPJXyNl+w/KbaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 492/567] drm/amdgpu/mmhub3.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:46:52 +0100
Message-ID: <20260323134546.154276966@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cdb82ecbeccb55fae75a3c956b605f7801a30db1 upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f14f27bbe2a3ed7af32d5f6eaf3f417139f45253)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
@@ -110,7 +110,8 @@ mmhub_v3_0_print_l2_protection_fault_sta
 	switch (adev->ip_versions[MMHUB_HWIP][0]) {
 	case IP_VERSION(3, 0, 0):
 	case IP_VERSION(3, 0, 1):
-		mmhub_cid = mmhub_client_ids_v3_0_0[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v3_0_0) ?
+			mmhub_client_ids_v3_0_0[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


