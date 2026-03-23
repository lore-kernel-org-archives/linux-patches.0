Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD43AD527;
	Mon, 23 Mar 2026 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274152; cv=none; b=Ld3wX+Kn33drOCbQjrak3X9JYt8nKIQ/MkBzdiSjbTPlOPVu27R+bdd5MDnMjKmQ9t5CJwhFsE2F1AiHNWBL1x65HPykVDRwJisJ2Ei8ZO7UCJco7tAAXsFJ4hdi9iRzgFgmFIf2WcTCSeNEn5QT14qMYac7ATrYRxhPBAR83kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274152; c=relaxed/simple;
	bh=Xg1Ex0QOZ5CzLNt3zKVn2JK9nAhqzLM9i54Dbyfu75I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkUHbXvs8ieWYLUNmdCgF0bpjnGJN9GZqjtb/qsRy8YetEziLY0jduZelDxmg4jTRpvsofSL3rEXgKlX1g7ol5pyfsyiu8UR4j5aERUiWd5fwP7jG94AaIFhsmyWx5swRvtk09uwHeCsrEAiNBL7+w2NM6jK2Qyh+qFmVgwiP1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stWbvpPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stWbvpPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF0AC2BCB1;
	Mon, 23 Mar 2026 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274152;
	bh=Xg1Ex0QOZ5CzLNt3zKVn2JK9nAhqzLM9i54Dbyfu75I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stWbvpPEBvr13w6tKu7/aptO+lA8DegOSkTLfS0Ma83RBQMshkv2QowGMAoQZoBen
	 rmEzBQR8KoC8Kx5aBbgTgIhtH10pU4oiRssJ6JTbiIRobDZFgQE20KLTVv3Jz1gLEO
	 8igaCrbUgL9EoU18AjiqpJOm4yyMdjVwIpC0MCoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 074/220] drm/amdgpu/mmhub2.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:44:11 +0100
Message-ID: <20260323134506.935406335@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


