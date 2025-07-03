Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A02E7BBF;
	Thu,  3 Jul 2025 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554957; cv=none; b=kRaLFQmJXMfk5pbuwHMhxfkzThk5qaNuFjTqSE86pM86DjqZmYG7hnFJK4SBmoF3dtup9YvXKI8UBoynflAvE6ZwjU6bBaZRSXBn7PUZrTdiO6ncgVNFzurmMfQ1Y5n35aShZO4VVEEyR+09c1NW+riubxpj3SKTQvlndg7EtAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554957; c=relaxed/simple;
	bh=JldWJHydv/9FSB0KnhTd8wlLhQHxiQipRHNBf6567K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKUAZx3zBO0eQdcU9Ixwc6nV8M6PTyY0b1ZSnjCg4+fZZvNDGo6mqwlZMUPNjZaZ1xbVNWAP2tkH2zIQhazmu63AW4Ld9jwTdFTULhF0CGOkWQ0gW/ezSx/0XmsfwAwmxKf7TgAl4IhSJgbgA4b3bMFDJZn0m8s0LrP4pYMhZ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0nSbxEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0nSbxEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1037C4CEE3;
	Thu,  3 Jul 2025 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554957;
	bh=JldWJHydv/9FSB0KnhTd8wlLhQHxiQipRHNBf6567K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0nSbxEMAnsI8/EuQ5m/2HrjVrTBsujDBActF8M3rTeJJ5trtPXbOBg8b26iqwYC3
	 +2UA9H8paUYY60tSoLo2le9fBNOsa3HP886AgKQnHMbl1hY/9OtXp+9W79381lgXTq
	 ceoQZNqYZAFuD82pQ3NZR6zchUGNL13+cbSGDNh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.15 124/263] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Thu,  3 Jul 2025 16:40:44 +0200
Message-ID: <20250703144009.328001957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -723,7 +723,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
+		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
 		if (ret < 0)
 			return ret;
 	}


