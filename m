Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF31494D9;
	Fri,  6 Dec 2024 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496228; cv=none; b=Cp+naQM4/1s6wi7WtsTwJW/n6DNFXvzwR5X/jju32/KSBgbp+Gp7GfwIKc70Pv8DxqSak90/zOTu371GJgpKaAyUKo8hCpUQuQmfJDcOkylKoG6Nk+ylSQRJ/+yXYodQwSnqbOx3QZ6Ki9hF66/3EQJmnT0EsBR1Vy8o6ccgOB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496228; c=relaxed/simple;
	bh=S+2aXAO5aGXyZw3HUFuFBTj2MblcNepaIbmwaZ8Gezc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plsFnKXUv42BIjfAvsc416TCQ07hsxeA5B8a6hrgoIwcK4bws6i0V0+t0YTEhSMSfs1BzVv8c96pRBe+WJmnS8QBY0zuPPLaSDfMLs+QmFZ2XZsjEqzaXOX7EOPAaFS4r1BqWBibzdb3VWgsIjLGlnzJEeYvUztQu8oabTMqliI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8ecM1KX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8ecM1KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E188C4CED1;
	Fri,  6 Dec 2024 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496227;
	bh=S+2aXAO5aGXyZw3HUFuFBTj2MblcNepaIbmwaZ8Gezc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8ecM1KXUIDOWAM/7lyGkfXIJF7i9JvqHP6ZuCzzSVTHuAhswFCbxVlu9PVZEOCNa
	 +UWT9OVM4ptfKVbGxm7GY+tpyF1FkY7RtLOypwr9dWabOXzTsF2g3sC3133W64BlC4
	 oemO7mxiu0vdVdpLvT3AX7P0bkBjMUa2hW6Lk74Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 090/146] thermal: int3400: Fix reading of current_uuid for active policy
Date: Fri,  6 Dec 2024 15:37:01 +0100
Message-ID: <20241206143531.120174083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 7082503622986537f57bdb5ef23e69e70cfad881 upstream.

When the current_uuid attribute is set to the active policy UUID,
reading back the same attribute is returning "INVALID" instead of
the active policy UUID on some platforms before Ice Lake.

In platforms before Ice Lake, firmware provides a list of supported
thermal policies. In this case, user space can select any of the
supported thermal policies via a write to attribute "current_uuid".

In commit c7ff29763989 ("thermal: int340x: Update OS policy capability
handshake")', the OS policy handshake was updated to support Ice Lake
and later platforms and it treated priv->current_uuid_index=0 as
invalid. However, priv->current_uuid_index=0 is for the active policy,
only priv->current_uuid_index=-1 is invalid.

Fix this issue by updating the priv->current_uuid_index check.

Fixes: c7ff29763989 ("thermal: int340x: Update OS policy capability handshake")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.18+ <stable@vger.kernel.org> # 5.18+
Link: https://patch.msgid.link/20241114200213.422303-1-srinivas.pandruvada@linux.intel.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -137,7 +137,7 @@ static ssize_t current_uuid_show(struct
 	struct int3400_thermal_priv *priv = dev_get_drvdata(dev);
 	int i, length = 0;
 
-	if (priv->current_uuid_index > 0)
+	if (priv->current_uuid_index >= 0)
 		return sprintf(buf, "%s\n",
 			       int3400_thermal_uuids[priv->current_uuid_index]);
 


