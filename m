Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4D61EF39E;
	Tue, 26 Aug 2025 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215231; cv=none; b=G1nC/kDlgdm6idzocwuJvKD6nEnPQj9xLHyEkYamcM0F/ZEfG962JeqspsuTZyKvy9GaoB5K58XCJ/7L53v4wfc/YXbmhQBvirafuQzSkMu/6/kE8aKApw4Yb4hH4pc4J7g27GJpIelq7e5xNcs5S38une1l2LYIbWDnryjbhvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215231; c=relaxed/simple;
	bh=C2CxFTc+T5YcAYW/hztnpk6cVB78xZ1horICN2KAh6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHtDgFVVWkf+/Mf8xJT9LvwL1EepsoAf+EGH6Fcyj+Zxu9SLNKNHXoSnYCmT8MeIB9UvWjEMgrHRIQZogn3KUEcahxfnM712/MSnLEZqR99gaby0oX0oBYVcvuLU/l8E7LYbD+J+dvjwtcf3g24gW1tz+jaXSCx/AY6Ez0n5Gxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OK7qG3Wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OK7qG3Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1508C4CEF1;
	Tue, 26 Aug 2025 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215231;
	bh=C2CxFTc+T5YcAYW/hztnpk6cVB78xZ1horICN2KAh6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OK7qG3WkOodlD7fcv6STF+3HRDpxKIwqLLkBRhPYVb1s0Fm0l9sPKw+leDXvHcee3
	 DOwiawqMCkYwtmFRlk8wHJhCGjjWD2RPHb0l3MZ1820y76e0V1GFiRchZlXCajPoM0
	 ZPIOGvnrRoKulxNORKvH9d4BEOUs3t+nR8l881hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 436/482] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Tue, 26 Aug 2025 13:11:29 +0200
Message-ID: <20250826110941.601617887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f ]

Reading DPCD registers has side-effects in general. In particular
accessing registers outside of the link training register range
(0x102-0x106, 0x202-0x207, 0x200c-0x200f, 0x2216) is explicitly
forbidden by the DP v2.1 Standard, see

3.6.5.1 DPTX AUX Transaction Handling Mandates
3.6.7.4 128b/132b DP Link Layer LTTPR Link Training Mandates

Based on my tests, accessing the DPCD_REV register during the link
training of an UHBR TBT DP tunnel sink leads to link training failures.

Solve the above by using the DP_LANE0_1_STATUS (0x202) register for the
DPCD register access quirk.

Cc: <stable@vger.kernel.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250605082850.65136-2-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -663,7 +663,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
+		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
 		if (ret < 0)
 			return ret;
 	}


