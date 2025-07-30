Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B1536124;
	Wed, 30 Jul 2025 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868552; cv=none; b=IgXZa6KIjS23xt0qEEM/L4L8OD5BIk3fjUv6Jj9SZlKBXb9TFBIq6k3sJVr9u9VDwt1yq9FOXLphGRN7v7+GXCo1fOZFvwxhiLoJGWiYinmmMiRit53+h33cB1QLwAToFHcQ5cnstP1mavOHmQ4BBg6rFq+w4hJ1z30WzqLMkZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868552; c=relaxed/simple;
	bh=Feh2uBkmB/MxPv6EHWLcYf6W4IAu9Emt3rubsL3GRvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLxcR8tFjCPpck/bfCmbSCtoYg3XRNLwzfB0/bd/dktGAQYwqShFWTFRf76IdKXtuNvftth0c4HFeVxHh+/I7QoZhfRg+4AB/cL7foqXT1XXdZUfQT1N/JSmMPZwjza0bEal1VJNnXpLSfqraHN74Us7cSnHYmY9nXm2hUg3P6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+4wFY2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+4wFY2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCFCC4CEE7;
	Wed, 30 Jul 2025 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868551;
	bh=Feh2uBkmB/MxPv6EHWLcYf6W4IAu9Emt3rubsL3GRvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+4wFY2alnPdJPi8dyxJaln3wRCBfJ3WkJUQK125WBcxDXHMPv65bmN9QmJ32dq8s
	 XZ4Yro9jkfDRhfYl0HOq3k+EpsEJnrb5znRrTmuRz0YVBpcyWvRG/yC7rjL3PeZ8zB
	 JCJ0q/7UFuCuTNxVczCrw7gxSKoKRh2ktbN4q6SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/117] staging: vchiq_arm: Make vchiq_shutdown never fail
Date: Wed, 30 Jul 2025 11:34:46 +0200
Message-ID: <20250730093234.248576276@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f2b8ebfb867011ddbefbdf7b04ad62626cbc2afd ]

Most of the users of vchiq_shutdown ignore the return value,
which is bad because this could lead to resource leaks.
So instead of changing all calls to vchiq_shutdown, it's easier
to make vchiq_shutdown never fail.

Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250715161108.3411-4-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 97787002080a1..20ad6b1e44bc4 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -739,8 +739,7 @@ int vchiq_shutdown(struct vchiq_instance *instance)
 	struct vchiq_state *state = instance->state;
 	int ret = 0;
 
-	if (mutex_lock_killable(&state->mutex))
-		return -EAGAIN;
+	mutex_lock(&state->mutex);
 
 	/* Remove all services */
 	vchiq_shutdown_internal(state, instance);
-- 
2.39.5



