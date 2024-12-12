Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C515C226542;
	Thu, 12 Dec 2024 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020637; cv=none; b=CAr335Acem5FQLcd4SE/1Z944gwgTXYVMx8wYP1V7nQVB0KP5KQeLOUVl/UIx8rhlGoYJrd3fFMHmjPSEF+w6CCCfghNgPLitFCs0dmx4zEPM9hkbLmLBtVx+F27WQ48WMIdjtmvPLNCrIpMjLPPWLJ29Z/BvZyX/Di5+37n6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020637; c=relaxed/simple;
	bh=HCgQ90lr0Y+wKyZmZUdBOe3qcY+YO2+HRJnOzUWLD7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/8NLW1nMFtBd6+tYyUFnuV4TH852Ibxjc6RW4qsM7pQOL5tJlWjfgQUdhszW5QYmufAB//Lnmb7vPkeky+TDIuFDBzCNKADCXnTjEUwpRCONrQf4mWMXBkNylBFgfhgFBZ8c57H+KFjF1k2rsK0DbJ3M4/Om1lQ1V1BaILu4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FK60m2La; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FK60m2La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA36C4CECE;
	Thu, 12 Dec 2024 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020637;
	bh=HCgQ90lr0Y+wKyZmZUdBOe3qcY+YO2+HRJnOzUWLD7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FK60m2LaV78lOz9whwo7gAu3Lr1nEN++P9/02U1M4iIN0+we+N3Fg5c8imaHgknbw
	 /zHapbk1m/Xe5v5+8jE2GkW4fDum3RthBEWgqjpfQWhGavxgY0DJk0kisn82LrniQw
	 vUBLF0pCsYdKuKnzoM9Z0hueWByIct9xBtTRL+lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 491/772] thermal: int3400: Fix reading of current_uuid for active policy
Date: Thu, 12 Dec 2024 15:57:16 +0100
Message-ID: <20241212144410.241829198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,7 +145,7 @@ static ssize_t current_uuid_show(struct
 	struct int3400_thermal_priv *priv = dev_get_drvdata(dev);
 	int i, length = 0;
 
-	if (priv->current_uuid_index > 0)
+	if (priv->current_uuid_index >= 0)
 		return sprintf(buf, "%s\n",
 			       int3400_thermal_uuids[priv->current_uuid_index]);
 


