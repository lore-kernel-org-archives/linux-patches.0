Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD5E26AC3;
	Fri,  4 Sep 2026 05:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499840; cv=none; b=W5LhrT/wlqwnAPCqC/nqjoBbR+r7hM4dSPF9Z0bhobc+4wvkQ1K3XReDCpZb+DSa5uEGmt8FPCulGbRCmhJmWz32RfF26tk9Ax+CegCjw5gdQrk86dTteERWzfEv4u5qgxl02QUQvtEuIGh17xtZPoSbCSBW58GtWqeArpbrWFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499840; c=relaxed/simple;
	bh=DArXJwg1NiXevZEtYed2ayeiUNOW/vIs5VUhkSBoMJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gL9pWEWw7G7KW03l7RbWyB9oqdkB68UKzMNuGAztZZMxF97c/M8t4Ki5cxwDa/N6O+9wH0UcD+JpxB27/gVc3fdjKlSXvWivIsL2JRsjvF9OLHvwv6FWvV9vbu9iQlt1EcxYvwB8hqOeSNzWamsUly2g+lYp1FT37S4L1jqOlyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8FOXD90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8FOXD90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39CE1F00A3D;
	Fri,  4 Sep 2026 05:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499839;
	bh=KV076UDjDpvcrXvHMRbbGkfd8dvVR8uf+O4UFEC7iHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8FOXD90AgScmrfYzlHCtUgbI4wnd9G9iAZD3SR/m2UCCFpbOs046M83dlqwCi+hM
	 P8tNEIi5bPAT0ibs4Wkg57igQ19DDyU04vdvJCaPMVvudaSPY5IcqtUkKC0w1rqSPR
	 Qy0Sz0R6Ei3xiq7KaRoRwrlFzKxJXe9N/A7NWP44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 559/713] platform/x86: ISST: Validate max level for set feature
Date: Fri,  4 Sep 2026 06:58:47 +0200
Message-ID: <20260904045816.348905570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit e45d6b8472861d3bac86bb37f8556a7c5aca3266 upstream.

Validate the level before setting, so that it fails early instead of
failing later when checking the bit mask for allowed levels.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -951,6 +951,9 @@ static int isst_if_set_perf_level(void _
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (perf_level.level > power_domain_info->max_level)
+		return -EINVAL;
+
 	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 


