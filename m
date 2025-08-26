Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04EC1AB52D;
	Tue, 26 Aug 2025 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213894; cv=none; b=W6LC8W1/Ox44mP5Rdorn4jB/pvkSzol+yZwtJmyh+Tqx3jI0Evj0Hs5eSFEou3Jtnl+l9/NWbspQXUH/3m9uemV7iYwgeVwlIXTc6Xnp9jvp1Rzj8Px1WjCS8+sDAcgf/EZ2Ozd03kEhfRE1yZDcflsuU54rJ5vg6iEximQL5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213894; c=relaxed/simple;
	bh=xO3YDGVPIf+yJYr01GvWC3IbfGAkqoqCBU5Y2clxGtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seJJbRKn5Gm2BRZbeo1Am52HBG5HRw6NlhoWQ3upRN1s1CI5KsiwJQ4Fva90EKMNxQFUPJSihJGKujGsxPK2wTq0/R0CtKauC/bhsm2bl+HWmf3PYinGAcKhorYOtxuL82XtZus8M7+HI/yBWCb5/7EWhpeBGvNQaCUiKYtdMhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2pmQaHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2pmQaHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E373C4CEF1;
	Tue, 26 Aug 2025 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213893;
	bh=xO3YDGVPIf+yJYr01GvWC3IbfGAkqoqCBU5Y2clxGtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2pmQaHPC/39ftDXiXKp8EzdxE4BRm7NJpHgBnQsj6iBa+LP6AfBfZJgzA1Mmgb6G
	 RaKQUQyvtvf8xNqBPE+aMYpZTOAOyAxebr1umXQwKzqnvVUlqc3AGzMLm1qNdch1sF
	 U5cw1m+zDHPSE06BV0i7tBDGcwgLNLzVbAzIwpT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 512/587] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Tue, 26 Aug 2025 13:11:01 +0200
Message-ID: <20250826111006.020728602@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


