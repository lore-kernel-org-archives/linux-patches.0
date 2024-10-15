Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A10D1C07FF;
	Tue, 15 Oct 2024 13:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997577; cv=none; b=UqGZYMLH5Rv+MKx45+RtPeEQU7G5/yqWFcTof3CIVbAAXxEjkcmeXRCXyXugB40CVj2ZJGnQg3Ls+N9VLdNGTmxt/6orqNCk8GQpyvNZ3SjCmvDzLgxizmVtrYn8/tlUwy9fbg01pAHLTu7qbMUFl6ueahpy+MHBnYHjbFA2iqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997577; c=relaxed/simple;
	bh=/zW9rjcCZykc1zLtWL8d/cOWogd/Ec1bVtiGklzHvnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggvBqWd/CxkUc7dZf8iTZ4qYkPrhDbZhIpvVr2DFghL63SXgleWwIbMPt2YdSLZ1Fz2BDUzTXZ2HjMl1KqBMf8dyLRsVKT1GU0G4j2UG3I0yY75EJe9cBymxGkXdRV/l0rVXI27xjBQmyVijjiMDePhLyS/OWQcEOugKPV/a1Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dm8Oxebi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dm8Oxebi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E49C4CEC6;
	Tue, 15 Oct 2024 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997577;
	bh=/zW9rjcCZykc1zLtWL8d/cOWogd/Ec1bVtiGklzHvnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dm8OxebiDUEVg+cIXUBJMerQuz2HynybVYt/HyVcByLJdkmfBzlPGBTz0zqKZgn/N
	 Hv1jI8gATiRyB61bSTnhRUXedtwD0TkA+XXlUmgIDkUgjchG7ieR0l0ocTMjeLa29X
	 xFjXIPHcXbcfyogEmwCdlHJddHNLfgxDQN+fV/gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.10 223/518] drm/amd/display: Round calculated vtotal
Date: Tue, 15 Oct 2024 14:42:07 +0200
Message-ID: <20241015123925.605524701@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Chen <robin.chen@amd.com>

commit c03fca619fc687338a3b6511fdbed94096abdf79 upstream.

[WHY]
The calculated vtotal may has 1 line deviation. To get precisely
vtotal number, round the vtotal result.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -131,7 +131,7 @@ static unsigned int calc_v_total_from_re
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


