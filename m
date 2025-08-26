Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD0B34DCF6;
	Tue, 26 Aug 2025 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216925; cv=none; b=JVw2NsNwInLP3YM+FJ5UpwHQbUfoYXu4RtHGiSX8xxyyROjiZPN6LCh7HvHZdkstMFM9JHn7no5jE+uJR6P07e6GlcqSDSnOo1+LqwnHoy+xVGE6jZZAdr8Z6FpA+zNaPfEyDXc77dkwwTvion433tA53daPkb+yKJhisqWiBHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216925; c=relaxed/simple;
	bh=JL2zx+LdVArgj2aBcKbpxBauXC/vkkPUtagm9b6dnbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1ZOD65NZ9R5R5yXFmvafL0WblQgxkYqIVKih6TO1vg4ZO4ckEezFJxZslSLyalYvn1WaU+H9j5pT9lqF/kkwXU+/LYekvu+UYCEmh45Ra0EekZpnF1FcWh/UMYYdHTtpttbQa8WOifUah63O9doEr56Bde9VlgQPTMM1RFLEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9wk9Tay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9wk9Tay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA8AC4CEF1;
	Tue, 26 Aug 2025 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216924;
	bh=JL2zx+LdVArgj2aBcKbpxBauXC/vkkPUtagm9b6dnbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9wk9TaycE/fcAzecaWGsZ9kwMJmAE8YVEIXoqHKqu8FsjP1q/TtL2ujTd3ZrE72t
	 E7Q5LAXsgD2RVB2rKdvHA3IflIJoWRtj16Sooikjv4VH+XwUNSZCChayGcNyUwGLwH
	 kr88vGfRwzLLc9Gen+Ws6lnlc2lhe2Ps7E6ud5T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 594/644] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Tue, 26 Aug 2025 13:11:25 +0200
Message-ID: <20250826111001.258970214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ call to drm_dp_dpcd_access() instead of drm_dp_dpcd_probe() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -336,7 +336,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_DPCD_REV,
+		ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_LANE0_1_STATUS,
 					 buffer, 1);
 		if (ret != 1)
 			goto out;


