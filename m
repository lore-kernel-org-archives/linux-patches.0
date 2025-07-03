Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30E92EFDB4;
	Thu,  3 Jul 2025 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555642; cv=none; b=Mys6O/S6b/bB/UEi8CTp7zeiYRPBaKSOCNuP4qJ1WAGfX5c1M0iu9PTRdtLaXSdjz6uTUXSDjA6YwcvNrdlz7ZckI8gfr4oK25m1ttyu6UuKStgW23aXulhMoekyPPzFm7nBaRj1SFroTqKPxhno+82FMeY7fWsSUnhJJNdlwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555642; c=relaxed/simple;
	bh=AjDHE67LMjMFiPmUyuBEg1jLldjsksaQ3kqmSEwWNnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fc5emPGaIF1JyBEenUBZcaNIRrrqzkcZa85fRTXVrSqWlq1x2Zz4Y4HeB2KQesjaNw0+jWx1twu9tXC4fHAtNrjqRdVlCoXNWs25XmfulgKfm7CXl44k9NRd2a2Owhpzei46tX+dR/fNsdOpOs7zGAk2EuhmbljWpC2knmgciKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwPPmaH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwPPmaH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B938C4CEE3;
	Thu,  3 Jul 2025 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555642;
	bh=AjDHE67LMjMFiPmUyuBEg1jLldjsksaQ3kqmSEwWNnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwPPmaH+WAMQ8PZCQPnodQ0u9XNsN963ndznu4K38auddObTJVLUXhhFkJ0KPgWN7
	 KzbTV46Po6qst6VnpBkhEmOzONtYSLTcetz1ta2UMDyhOFECF7QBGB3qkP+bnHrb5/
	 XSAUB0v/UiA4u9GCOSC+9wEtbzjW06uPEcBK7Z0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.6 077/139] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Thu,  3 Jul 2025 16:42:20 +0200
Message-ID: <20250703143944.176604348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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


