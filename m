Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6D5192D69;
	Mon, 21 Oct 2024 10:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506608; cv=none; b=W4rXFRsiWL+GMGXSiyLf7Mgs/2RNU+r+ssKeQlz84EnGZvYIJNeWzuR6f8YFVbFtSguKXJK/F/Ir9D/ib08rGBH8alD09V7KnIwnAl5CQ/deORJ3tAEeqqA7DB/paTz/UEdAXmMacXI9sSczSmFyElux+4QsIMQH+L/K4VKL/vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506608; c=relaxed/simple;
	bh=h8b8mZri9JTS8viDqSq00gEVWszXqkj587cY9aAuO+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orK9mBvgkWjAbbMPoJ0TNXrWcASAADI78gf8PcnygIGEpuU5z2Kq6tL2Eeqo7ef1fy+sWi8YqH6bWIAbcCgURcZaZSIACPcc/OTLGGkxLRVUHqiqZKlW+PI3CguHk1ExKa/606NGlVGk4yiSrRJfLNYzpq06rusZCXbabaI/HZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw3YemRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw3YemRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A715EC4CEC3;
	Mon, 21 Oct 2024 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506608;
	bh=h8b8mZri9JTS8viDqSq00gEVWszXqkj587cY9aAuO+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw3YemRqdDhp5rWoUzLq1tMDxBmbxhaGGfeSTAFW2G4pk7l4KaHMBPlkqOdUHaGbS
	 grSZr1ZaPh2J4PK9N3cpKSB/l6B3xwTl0szMOvicbVEhfYNkDKMewxBoKypEW/UHvs
	 h6KcYGY980zXrMaUrIiYWC+BVRJ9WyAVMlJn+s+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.11 061/135] drm/i915/dp_mst: Dont require DSC hblank quirk for a non-DSC compatible mode
Date: Mon, 21 Oct 2024 12:23:37 +0200
Message-ID: <20241021102301.714996316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 2f54e71359eb2abc0bdf6619cd356e5e350ff27b upstream.

If an MST branch device doesn't support DSC for a given mode, but the
MST link has enough BW for the mode, assume that the branch device does
support the mode using an uncompressed stream.

Fixes: 55eaef164174 ("drm/i915/dp_mst: Handle the Synaptics HBlank expansion quirk")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241009110135.1216498-2-imre.deak@intel.com
(cherry picked from commit 4e75c3e208a06ad6fd9b3517fb77337460d7c2b0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -465,6 +465,9 @@ hblank_expansion_quirk_needs_dsc(const s
 	if (mode_hblank_period_ns(adjusted_mode) > hblank_limit)
 		return false;
 
+	if (!intel_dp_mst_dsc_get_slice_count(connector, crtc_state))
+		return false;
+
 	return true;
 }
 


