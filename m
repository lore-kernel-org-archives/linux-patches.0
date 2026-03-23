Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1A23AB9D;
	Mon, 23 Mar 2026 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277200; cv=none; b=sRbZXVOCbAyJrILT7Ku0225GeVQQNcx08k4u7dqylvyg7rX/7gVRJ6TbqMioU7BZ0Zx1f1GZTFlWZsmvqc7o2CfkhM6o5yYAYaQTH0gQI7ZNEE0VztRWLfh1Yz47trmUHpHyAyV0uI82Lv2vUb7rArTCwJP16UEZiHoWHYd+TP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277200; c=relaxed/simple;
	bh=JISaupgXFro9sBYE4CPfSDReOACjxwDJOxupkGpjDn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p022ZD4jb3HEu0x7NvWWIGZqpjGhcWxwnMZA9H3jZsgKk7m2UsXfGJL9Rr0Wk0UDM65UNYBZpMynmM96aE1yNJ2ZjjiS+DjZ0R3Jxw0CN+PnnzdPmCN5L6mxhnXuIy47m4zOsUvccD1TXJbj/9Vth4cxA9AKBE3iGNbgR0BsJpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHVSiEGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHVSiEGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188C0C4CEF7;
	Mon, 23 Mar 2026 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277200;
	bh=JISaupgXFro9sBYE4CPfSDReOACjxwDJOxupkGpjDn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHVSiEGGFXDxUFSjUA7xpoyhW+cduB0xCAFUF33G3cOE+sMT7Hh3vlUOzp4C2vxOf
	 3MO0+lFr3evEezMHvMOwTU3JBTAQOjkkhG+TEZgWR9OLv7iOidczcWqi9CP+8g9Sx/
	 +GiFkgBEiMyxKx1ZFwTDEnwFtr+Fajm3CvGg1QeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 353/460] drm/amdgpu/mmhub2.3: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:45:49 +0100
Message-ID: <20260323134535.226639191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a54403a534972af5d9ba5aaa3bb6ead612500ec6 upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 89cd90375c19fb45138990b70e9f4ba4806f05c4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -94,7 +94,8 @@ mmhub_v2_3_print_l2_protection_fault_sta
 	case IP_VERSION(2, 3, 0):
 	case IP_VERSION(2, 4, 0):
 	case IP_VERSION(2, 4, 1):
-		mmhub_cid = mmhub_client_ids_vangogh[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vangogh) ?
+			mmhub_client_ids_vangogh[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


