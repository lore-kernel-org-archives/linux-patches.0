Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EF22D12ED;
	Fri,  7 Aug 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115592; cv=none; b=sq7CTh9Rbl2rs81+9+enqOgrICe+b7a4iuqhAWcqaowknO/i2z1+e3FSU+6CBpUSXR880iF4shzRZlssfBXlREEkxQTl86uFBSlU7HhB1mWULNyALeiT4A6ZU0fE1ppTytc8kSq9vnS7xxvY0lG1RCXwBtE5Y8TrYPdco9Mm3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115592; c=relaxed/simple;
	bh=Fg/vA4YHzU9gDnG+TEk6tXRl+9bcE4tTnan9ekxSDa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXsk8CKeQl7e/we3FO3n+2wrJn8vnmNL1Liwoo3JAJ/C1Yjvj3d6AFClz4fptpZETiyjH/X+2lOcUJjYzAcNsvcSl8u2Ut5pKVBKchqOo9PT/L6nAjAmAequ2Ev/cXYdbdqd7dgtQZm3x9L8RE1WcEjpio/nUDRm1YSAunmkwjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx4gES3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx4gES3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5215A1F000E9;
	Fri,  7 Aug 2026 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115590;
	bh=iGrEzN7+4F3Y6ss30v/IOh8ODyLhtp0CKdwNQ8ImYeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wx4gES3fcXfWC/rk/HNut1iF6TDSKi7xGxLqE/17Pbqi0HzaePQ2EbSfhRl/1CDWM
	 c76o6iOXsJ8JpALGjk4AytGw033ufhm5rG/4UAXWiqNjbNCO/l43Eavrf3P9Bevm+x
	 r/c6DxgGt/18jTB5pd2H0yPh5Oy44fWTVk+Q6pII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 328/396] drm/amdkfd: Handle invalid event type in CRIU event restore
Date: Fri,  7 Aug 2026 16:38:08 +0200
Message-ID: <20260807143431.365798004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

commit a9cdc85839e4fe2c760aa4ca6cc341c31ad1918a upstream.

In kfd_criu_restore_event, there was no handling for
the event priv data having an invalid event type. The priv
data here is untrusted and can be invalid.

In that case, fail with EINVAL.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2e8e9963cd5c41aa14fd5316bf9ec92e7a0e3097)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -521,6 +521,9 @@ int kfd_criu_restore_event(struct file *
 
 		ret = create_other_event(p, ev, &ev_priv->event_id);
 		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 	mutex_unlock(&p->event_mutex);
 


