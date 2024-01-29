Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DF1586DC;
	Mon, 29 Jan 2024 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548238; cv=none; b=Hcxt1BdRjJTXlLh9lfsiyp7t/+jTgJP/14511X6FgV7jEkzqmER6wBTyNY8eb4rGebI28HmpxTLojKjzq5o693/xkNV0gS4J7sQRQXE9TLvGl0jok5GxphYruMF3pEmtS8sRW3wJWHv1440HwMKVkOlIRVcHW2EHSPlvi5E5hB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548238; c=relaxed/simple;
	bh=BYyebpNM/4fD9MH0MXdhMwR73YnAWpH+a4WrbayOkFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN072jnQ81oVc56ZqActgd4DOuHZokeIg4nUIPP2Qp0hN5CQz2tRW7DgEjBDStDX/YidnfWs93k/P7wI1wpotLyOC7G5GQ6qa+SU36Qlyjl2RXB6UF4r6KDfa3ErR5XVq95KTcqB2M/qscT+CeSBFbNtavPBkffczLPboOxwHtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAe2jrFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAe2jrFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E84C43390;
	Mon, 29 Jan 2024 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548238;
	bh=BYyebpNM/4fD9MH0MXdhMwR73YnAWpH+a4WrbayOkFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAe2jrFFbOfmVtyd38LSwE9T20i8ZsirZEWYwLSsi/dIMkl/CLSVHJOAcMhn1OYDH
	 aaDu6Gcsz+rCopAOebFZ3/lgzkQJOs8nF+pKhwDgMWtbVUWt//zltBIwAJ5fDQv7df
	 s81I/FYwjcyKd8IQypCY+VEq0yXtzfVn6HEpISXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 265/346] drm/amd/pm: Fix smuv13.0.6 current clock reporting
Date: Mon, 29 Jan 2024 09:04:56 -0800
Message-ID: <20240129170024.184200374@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit a992c90d8ed3929b70ae815ce21ca5651cc0a692 upstream.

When current clock is equal to max dpm level clock, the level is not
indicated correctly with *. Fix by comparing current clock against dpm
level value.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -924,7 +924,9 @@ static int smu_v13_0_6_print_clks(struct
 			if (i < (clocks.num_levels - 1))
 				clk2 = clocks.data[i + 1].clocks_in_khz / 1000;
 
-			if (curr_clk >= clk1 && curr_clk < clk2) {
+			if (curr_clk == clk1) {
+				level = i;
+			} else if (curr_clk >= clk1 && curr_clk < clk2) {
 				level = (curr_clk - clk1) <= (clk2 - curr_clk) ?
 						i :
 						i + 1;


