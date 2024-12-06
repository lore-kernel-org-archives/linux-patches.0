Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69B207670;
	Fri,  6 Dec 2024 15:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498104; cv=none; b=NFUhp+YesRJ5CBreguRrrLFjDseDeb/CGwRbWVrp5DBc948VySAd4b0nv0lko3jeJABYnnuow/f4Qo7luE43QMgiZu39xKdopmCeUPg9ZJDejtSC1mOktKE3jHUTB5Dh66j7JjV5DUjRcf5wcOaO96cg8cDNJuQpROYm32ko+8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498104; c=relaxed/simple;
	bh=TIrpBFYkjdluJCNiJPweekdFM/8dfa5Bm9fdDPP6xtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItFSPhV3QYSiGAAvxZbHhkAfbAZwAw8RzcOpyt9GpiH1SJDXix6ydA9csv+67jxsQQgf6U/PcF8ZePGDW8DWVPbdhjBngjWfGBxcKSnpz9XSy/AP2IZ13Fb2HliU1572hOEzG4SqWVTOmDOpQgwD24AaLVklWjt3ZcEmg6wC8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4uszUue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4uszUue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B4FC4CED1;
	Fri,  6 Dec 2024 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498104;
	bh=TIrpBFYkjdluJCNiJPweekdFM/8dfa5Bm9fdDPP6xtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4uszUueY9BZI9qme5nl5NWCEdOdxj/2ykd40cYeYMf5mjCODDGfiPMXqDSTAXjUs
	 ivDw3LqnLBg+cHY2Y8edK1affzAC/qnobW5dvXi64qihsqYsq86VG/lvWRjcUDzc6N
	 d4vquQt6Xx6PD8cC+cvTb95GQg7u73jhRXdZtlDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 456/676] drm/amd/display: Check null pointer before try to access it
Date: Fri,  6 Dec 2024 15:34:35 +0100
Message-ID: <20241206143711.181762845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 1b686053c06ffb9f4524b288110cf2a831ff7a25 upstream.

[why & how]
Change the order of the pipe_ctx->plane_state check to ensure that
plane_state is not null before accessing it.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Xiangyu: BP to fix CVE: CVE-2024-49906, modified the source path]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1741,13 +1741,17 @@ static void dcn20_program_pipe(
 	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult))
 		hws->funcs.set_hdr_multiplier(pipe_ctx);
 
-	if (pipe_ctx->update_flags.bits.enable ||
-	    (pipe_ctx->plane_state &&
+	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult) ||
+	    pipe_ctx->update_flags.bits.enable)
+		hws->funcs.set_hdr_multiplier(pipe_ctx);
+
+	if ((pipe_ctx->plane_state &&
 	     pipe_ctx->plane_state->update_flags.bits.in_transfer_func_change) ||
 	    (pipe_ctx->plane_state &&
 	     pipe_ctx->plane_state->update_flags.bits.gamma_change) ||
 	    (pipe_ctx->plane_state &&
-	     pipe_ctx->plane_state->update_flags.bits.lut_3d))
+	     pipe_ctx->plane_state->update_flags.bits.lut_3d) ||
+	     pipe_ctx->update_flags.bits.enable)
 		hws->funcs.set_input_transfer_func(dc, pipe_ctx, pipe_ctx->plane_state);
 
 	/* dcn10_translate_regamma_to_hw_format takes 750us to finish


