Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C273B19DE;
	Fri, 15 May 2026 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862467; cv=none; b=bxOmcni/OLKz6KMqaZO3jpS6dJ40cEGxgo1FZwtNGyT6VhL9UUpdyMABG5XG/yeUhiUz0ffHkUHaBBgdR7vuElpJ1D8kg4mnCPJxmHid446MvaGHCRwo9CQ8lsPFkF7FArwsgr76pI3sDVUsSpte1DufEji52u+XmtfkP3HVtPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862467; c=relaxed/simple;
	bh=SO1iqbXk4rhWZEsPIPV99w25JKmx2cHXTsBGF765J18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpvxLtkOjv5+ItpBHVFpIE+72N9W2SaYeNHsvlXAwcvS9qpq8cNQUwQpiz9T0xuI2qLwORCYeitCGnw0soXcufVkDL5oHcsY9Qtj2In2uU5na93AvHVaIezEpJ2NqE9g13TS9XCxfz9IHg1zafc/e6xyPTW+Iki3gE49qfpJyEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPZeY79N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPZeY79N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEDDC2BCB0;
	Fri, 15 May 2026 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862466;
	bh=SO1iqbXk4rhWZEsPIPV99w25JKmx2cHXTsBGF765J18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPZeY79NwYX19IANWcsZhbOWYZPy/rc5R9titdCmX7cvH0AkCn+wAIrMjIaQD/YHq
	 mJQDd+dEy6qJww4+OQsVYV2fbeCpCyHBwg6HrohHh7MEHbnUkDv4apYoB9Tg8T2dAz
	 tTh5g6pwIyFqR5UjgkdVRdU4VTyycVQS6ZBmOIEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>
Subject: [PATCH 7.0 059/201] drm/colorop: Preserve bypass value in duplicate_state()
Date: Fri, 15 May 2026 17:47:57 +0200
Message-ID: <20260515154659.812240803@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit 0d9710aeb6959ae244f255986187562fa50504b9 upstream.

__drm_atomic_helper_colorop_duplicate_state() unconditionally
sets state->bypass = true after copying the existing state.

This override causes the new atomic state to no longer reflect
the currently committed hardware state. Since the bypass property
directly controls whether the colorop is active in hardware,
resetting it to true can inadvertently disable an active colorop
during a subsequent commit, particularly for internal driver commits
where userspace does not touch the property.

Drop the unconditional assignment and preserve the duplicated
bypass value.

Fixes: 8c5ea1745f4c ("drm/colorop: Add BYPASS property")
Cc: <stable@vger.kernel.org> #v6.19+
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260310113238.3495981-2-chaitanya.kumar.borah@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_colorop.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/drm_colorop.c
+++ b/drivers/gpu/drm/drm_colorop.c
@@ -441,8 +441,6 @@ static void __drm_atomic_helper_colorop_
 
 	if (state->data)
 		drm_property_blob_get(state->data);
-
-	state->bypass = true;
 }
 
 struct drm_colorop_state *


