Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060FD3BE650;
	Tue, 16 Jun 2026 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626434; cv=none; b=ktK/H5rOvI+u6DalgkPOGWl5O4DMV3u20xUOtqYmnctUthhLON1JAXaQcLnPs+hV9eOjPOcPQvFsoB6vVyRvHSUDhQ+3jrPKy6+1Ucfwz2KefVFb3lNQ1AllnjXguW8SSgbnAG7m7h4q8RYudPi8mUFG0dXTcdmGJOEojU3pk9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626434; c=relaxed/simple;
	bh=diWRuINQzW8b3pnUZD8YpMFHgO1j4paAdqboD0HAxrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiEoLLAvXy6f5qiBBDtz9Jb6eEB1u0c88L2YqnDjX2y0Vn7SUjAy98eUczJs4kpqcQME5M3JDNJsl5ZKYNmj7B2WBa1tNXITGx+tAv53TKFhMWMml+k9RDphbCcZRvIUrBJaXrcKBUN+n1Hms+FLANopJMf7zNx6kgFY9nhKrgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4MMsnwD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4MMsnwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36291F000E9;
	Tue, 16 Jun 2026 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626432;
	bh=xMZPHxBU5fuDi++OT9IwTSLpdLmy4bTQYfgRhp2ZXow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4MMsnwDn4Ml6ak5tyLTT9MfQSrtcg9OUZxJ1VKi3gEh4kSvpq+W9JN2lZU0JDphq
	 L93UJdbjlV3C78XMF25IXx/mwQLHf0tONu1kCct9CbvmELssXUCu8agVjfMxnLHrUs
	 23DWruWZwujszOZvcRcF4TCtZWTq+d6POX3xw4Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>
Subject: [PATCH 6.18 287/325] drm/v3d: Wait for pending L2T flush before cleaning caches
Date: Tue, 16 Jun 2026 20:31:23 +0530
Message-ID: <20260616145113.068448839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit abf888b03a9805a3bc37948a0df443553b1c0910 upstream.

v3d_clean_caches() starts the cache-clean sequence by writing
V3D_L2TCACTL_TMUWCF to V3D_CTL_L2TCACTL and then polling for that bit to
clear. It does not, however, check for an L2T flush (L2TFLS) that may
still be in flight from a previous operation.

On pre-V3D 7.1 hardware, kicking off the TMU write-combiner flush while an
L2T flush is still pending can clobber bits in L2TCACTL and cause cache
inconsistencies.

Poll for L2TFLS to clear before writing L2TCACTL on V3D < 7.1, ensuring
any pending flush has completed before a new clean is issued.

Cc: stable@vger.kernel.org
Fixes: d223f98f0209 ("drm/v3d: Add support for compute shader dispatch.")
Link: https://patch.msgid.link/20260530-v3d-fix-rpi4-freezes-v1-1-c2c8307da6ce@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -212,6 +212,14 @@ v3d_clean_caches(struct v3d_dev *v3d)
 
 	trace_v3d_cache_clean_begin(dev);
 
+	/* GFXH-1897: Ensure pending flushes complete before writing L2TCACTL */
+	if (v3d->ver < V3D_GEN_71) {
+		if (wait_for(!(V3D_CORE_READ(core, V3D_CTL_L2TCACTL) &
+			       V3D_L2TCACTL_L2TFLS), 100)) {
+			drm_err(dev, "Timeout waiting for L2T clean\n");
+		}
+	}
+
 	V3D_CORE_WRITE(core, V3D_CTL_L2TCACTL, V3D_L2TCACTL_TMUWCF);
 	if (wait_for(!(V3D_CORE_READ(core, V3D_CTL_L2TCACTL) &
 		       V3D_L2TCACTL_TMUWCF), 100)) {


