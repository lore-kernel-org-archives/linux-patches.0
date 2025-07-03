Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09852DE6F1;
	Thu,  3 Jul 2025 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556101; cv=none; b=Z06hPOuq/MBkoyNkVS/NP5ydXfzh2CaVMfJM6J+BaLdoo/2YDmrHsbzNwgDTniBassJsk5taiuKoRr7j3+OL/Zwx2BEMB1PcfsZCRPqXdEBzovOo2TwYDapvxLub79BoQCf6bgOhnDfUbzcaaZaL8DO0JD6WcHpHi2SEZ7WSUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556101; c=relaxed/simple;
	bh=q5sCbzYhOrILQeS+2GEhFrSDBqipHM084yGGxjIxI0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ba5hMghjRqCCVsJ7ZocIe9dSqjF6aglaGG3gxKmQZ1zqHGwZvYK7DGbhfn0iJ6de7MKvVv56EG0IUezmrwEFosS54UVghR5eSOOgEFwzutakgChBH8F88IVkN6Jx9AzR9NZMpVZkzl8rDNyn89ql+5RePjrnZ+OG3LZXt9ipzlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDlruePk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDlruePk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC420C4CEE3;
	Thu,  3 Jul 2025 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556100;
	bh=q5sCbzYhOrILQeS+2GEhFrSDBqipHM084yGGxjIxI0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDlruePkOypgR1BNpuHZCKn+GCvufl6VrQyHeb+3A9/5+J1HvEDq8AtrxZ1Aq5kuI
	 4kxNlOEOUXja02IMI39FhlTK9Xk4A/POUWVn6zbtUKoFe6AWof/NUidHeR2xwNbl4z
	 yLUdRf+pu4U19PeQS1LB65JWB/o7sbFGvKJuQ48g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.1 075/132] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Thu,  3 Jul 2025 16:42:44 +0200
Message-ID: <20250703143942.360601573@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

commit a3ef3c2da675a8a564c8bea1a511cdd0a2a9aa49 upstream.

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
(cherry picked from commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
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


