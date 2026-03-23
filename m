Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AAB3C07A;
	Mon, 23 Mar 2026 14:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274821; cv=none; b=IpWjriZO3NB10nkwKfsx169c7cOK3vhFdCDqlsZzO4hPdyp1ISzwCbYZmAcyVb5Qjx8YkLzLoPf7A22EbR9DtnaD4r9Firu9ZVTCwZPz1XWbsFyMpzVUC7WuZCOJUXQNuoLzuQW0dDKMigR1MxlbTJC8k0rnbasAT8sm/kG+kuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274821; c=relaxed/simple;
	bh=uC0y2LSZp8VJaPQGttGE0fOAXQbD+OrznBfCpPq3Fis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GraTRuL5tAOTLB4IZyeESOhK5KqgAKHItYW1ro4SmBkQgqh6vMhDj6dYgrqcC1pytfYXLf0xmHDGcOaOPyGufLY7Kfm770RVkzytVC5iZMvNJWiYEKiN5DwZ5i8W5CqR8fS4HF08hJcm4fMB93jXkkrGSfsycxqF38a+F663r5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj1EcKqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj1EcKqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96CAC4CEF7;
	Mon, 23 Mar 2026 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274821;
	bh=uC0y2LSZp8VJaPQGttGE0fOAXQbD+OrznBfCpPq3Fis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj1EcKqj5AUfG+r5KVynGwlPdoYtG/ONCyzByWPRZO/pp/2shY3iEb3pnrJG7pRDD
	 nXhmPjHCe2IgKSiknUvuNKUZMFtI7ANDFdQ9Itj4CAb2p+7s+OlgSyf09jNPWucROV
	 4aWIzuXXUP/eKOrKiKeNsFqosJN4FJyezTqJMAiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 082/212] drm/amdgpu/mmhub2.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:45:03 +0100
Message-ID: <20260323134506.366298123@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0b26edac4ac5535df1f63e6e8ab44c24fe1acad7 upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e064cef4b53552602bb6ac90399c18f662f3cacd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -154,14 +154,17 @@ mmhub_v2_0_print_l2_protection_fault_sta
 	switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 	case IP_VERSION(2, 0, 0):
 	case IP_VERSION(2, 0, 2):
-		mmhub_cid = mmhub_client_ids_navi1x[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_navi1x) ?
+			mmhub_client_ids_navi1x[cid][rw] : NULL;
 		break;
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
-		mmhub_cid = mmhub_client_ids_sienna_cichlid[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_sienna_cichlid) ?
+			mmhub_client_ids_sienna_cichlid[cid][rw] : NULL;
 		break;
 	case IP_VERSION(2, 1, 2):
-		mmhub_cid = mmhub_client_ids_beige_goby[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_beige_goby) ?
+			mmhub_client_ids_beige_goby[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


