Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9914183CC3;
	Mon, 18 Aug 2025 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526162; cv=none; b=uXux7ifworZcLL3UacFATKm9bY6v+v1VwuE7fdq57NhbjtPjKByg3hSnO2rhWzmLNxQ009lsWhjdDhRL79Xv3e58d2TBoJrX0RkMje7GUhwFyRpwBsdHUkT1rEceuS/eJQCw40pHPZliAKvoWHw2reJX28fgyEQ5pZOZtfoL+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526162; c=relaxed/simple;
	bh=llBPYvrJVMHqxbgs/dt0+8SW6yKH1iKHKvv9EjN44M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lD2wotUOo4vmzWGgliLvhC6OTx2IFFQJdV+5CqP+1/joPEltyebEw+avWo3hQw9LJXtXxL+vcGNSmmp6M5b5cYK3VY7P+EcDeIwk/Vz87ECj5VaZXPpqrcdYT7xA+Gfo4CKm5WqjPHAY1sEtkm5ceyyicWHW6XPAF/ZexITgt68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWCY+zCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWCY+zCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E611C4CEEB;
	Mon, 18 Aug 2025 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526162;
	bh=llBPYvrJVMHqxbgs/dt0+8SW6yKH1iKHKvv9EjN44M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWCY+zCn8J7NWh22T+sNXD+U4KiibnkGP4kU1OO6nhdh+CYojimFeMzzUhUNw8c4j
	 utAfqxdyyI0LJOy8JPX6fL9W3PiyZP+lpu0xJ3EBdBU6r+u7zREu0g36M8jX5N879h
	 6z1GFIeo4zQeZG+Qhg8BmsWxD7ZdDAFkAsp+ksq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 475/570] drm/i915/fbc: fix the implementation of wa_18038517565
Date: Mon, 18 Aug 2025 14:47:42 +0200
Message-ID: <20250818124524.186837280@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Govindapillai <vinod.govindapillai@intel.com>

[ Upstream commit fd56b9c9507f32b16159f9a922e1af5628254567 ]

As per the wa_18038517565, we need to disable FBC compressor
clock gating before enabling FBC and enable after disabling
FBC. Placing the enabling of clock gating in the fbc deactivate
function can make the above wa logic go wrong in case of
frontbuffer rendering FBC mechanism. FBC deactivate can get
called during fb invalidate and then the corresponding FBC
activate can get called without properly disabling the clock
gating and can result in compression stalled. So move the
enable clock gating at the end of one FBC session after FBC
is completely disabled for a pipe.

Bspec: 74212, 72197, 69741, 65555
Fixes: 010363c46189 ("drm/i915/display: implement wa_18038517565")
Signed-off-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://lore.kernel.org/r/20250729124648.288497-1-vinod.govindapillai@intel.com
(cherry picked from commit 82dde0407ab126f8413fd6c51429e5057ced5ba2)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index bed2bba20b55..6ddbc682ec1c 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -550,10 +550,6 @@ static void ilk_fbc_deactivate(struct intel_fbc *fbc)
 	if (dpfc_ctl & DPFC_CTL_EN) {
 		dpfc_ctl &= ~DPFC_CTL_EN;
 		intel_de_write(display, ILK_DPFC_CONTROL(fbc->id), dpfc_ctl);
-
-		/* wa_18038517565 Enable DPFC clock gating after FBC disable */
-		if (display->platform.dg2 || DISPLAY_VER(display) >= 14)
-			fbc_compressor_clkgate_disable_wa(fbc, false);
 	}
 }
 
@@ -1708,6 +1704,10 @@ static void __intel_fbc_disable(struct intel_fbc *fbc)
 
 	__intel_fbc_cleanup_cfb(fbc);
 
+	/* wa_18038517565 Enable DPFC clock gating after FBC disable */
+	if (display->platform.dg2 || DISPLAY_VER(display) >= 14)
+		fbc_compressor_clkgate_disable_wa(fbc, false);
+
 	fbc->state.plane = NULL;
 	fbc->flip_pending = false;
 	fbc->busy_bits = 0;
-- 
2.50.1



