Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481351A680D;
	Mon, 23 Mar 2026 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274137; cv=none; b=T73YYNdq2IgdXAJnVNcBmdZB5UD03XmjsD6ZPAtKusJrbDNmzHQLxpbUOg4oWOebYAf/c8t00WrUHdTUQz37zXP/UyGZ+ezMaMFkn5YMd7Hm/30ipWIo/THUZc4UGAG1zwOKYpoFmFAxAkMjR3YdMXj6EKPfTkGP+ZEXOEkQInU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274137; c=relaxed/simple;
	bh=oduutQ2/EMPNfA5K32PVsaVtAcMlDcyXhXaMFt35l/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9BHgBxXGQsTbK367F1vFPkwzKtrAnrftoBXvhN2kuHtBHwPb2fJX4BvvAJCqA+2XTUJTWWaCbJiCK5mhoLOZCFNSXWJ37wHRDMjr+7HplUGl6foYYf8K1Fw4p74DnmUS8auHUj8d5qw6rEGI1VReRxbOsL5+9pND2pih9haWUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7e4EeLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7e4EeLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1849C4CEF7;
	Mon, 23 Mar 2026 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274137;
	bh=oduutQ2/EMPNfA5K32PVsaVtAcMlDcyXhXaMFt35l/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7e4EeLeiH+W9fgl0qkrhWxrt+PLoWrsHwdofcks7HV4KWES7BggobWX8eWl0XYNC
	 725CCGabtLw5kiK1jGCrwf2v8+dqEdMKS70y4/wUZe5A3dvJFJnjIokpjfl7OVRL+w
	 vbdLsWnwvBquWKk39LWxOiF5YLbj2DgSjDR5iC58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 079/220] drm/amdgpu/mmhub4.1.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:44:16 +0100
Message-ID: <20260323134507.091205272@linuxfoundation.org>
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

commit 3cdd405831d8cc50a5eae086403402697bb98a4a upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 04f063d85090f5dd0c671010ce88ee49d9dcc8ed)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
@@ -102,7 +102,8 @@ mmhub_v4_1_0_print_l2_protection_fault_s
 		status);
 	switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 	case IP_VERSION(4, 1, 0):
-		mmhub_cid = mmhub_client_ids_v4_1_0[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v4_1_0) ?
+			mmhub_client_ids_v4_1_0[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


