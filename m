Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B772D6E6B;
	Tue, 26 Aug 2025 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208689; cv=none; b=M6uWmGsMq0LmBfVY6UhNUvpl5mol2HSwX2npfVWmJXMukNtxfZTpI4UwMTSGVIGx8ORfIp7qMPRu6AVN0sLj4zEv7UcM3VgeuehfFtDzSRZj2cpNhF0fQV48+cOID6UXlnOcz5/ziInA/GFYWhVqHfycsjmITna3cuYvndmpHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208689; c=relaxed/simple;
	bh=Q6OD8UPmnpob6nH7B56kjcz4yM8+IG4Ym5eRiAFPFtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O6BP+ZMYn1KlmEs792+9v5CWs9mrIRLhUhYMYNRmtWJKiP55sj0qjYommMoHLBmt5oXAWzbzb6fQy3/v7GNlZCuS+h/HUMQaAKo7M53PLZ1LOWPPjo+i4qWruAI63jkfm/owMm01/EXRPB16aS+JA545YzHO0m9tCmncJrnLfSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x56kWhRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x56kWhRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F95DC4CEF1;
	Tue, 26 Aug 2025 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208688;
	bh=Q6OD8UPmnpob6nH7B56kjcz4yM8+IG4Ym5eRiAFPFtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x56kWhRs3NtrAXUcvuzZbV5W7oN9+AS62IHKAldurJsbl/KIUIgVryS41O90eNgZA
	 8BqIrwCpdWHxFH9xfNzrC8TpyC5VN36JceZUoZuVq+X4gZktozhK3aIMukL/XmG7dy
	 YhmGeo/289woBJTGgAqrHyeCZ4J/zlYY7tmOCNhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 177/322] platform/x86/intel-uncore-freq: Check write blocked for ELC
Date: Tue, 26 Aug 2025 13:09:52 +0200
Message-ID: <20250826110920.232712278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit dff6f36878799a5ffabd15336ce993dc737374dc upstream.

Add the missing write_blocked check for updating sysfs related to uncore
efficiency latency control (ELC). If write operation is blocked return
error.

Fixes: bb516dc79c4a ("platform/x86/intel-uncore-freq: Add support for efficiency latency control")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250727210513.2898630-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -189,9 +189,14 @@ static int uncore_read_control_freq(stru
 static int write_eff_lat_ctrl(struct uncore_data *data, unsigned int val, enum uncore_index index)
 {
 	struct tpmi_uncore_cluster_info *cluster_info;
+	struct tpmi_uncore_struct *uncore_root;
 	u64 control;
 
 	cluster_info = container_of(data, struct tpmi_uncore_cluster_info, uncore_data);
+	uncore_root = cluster_info->uncore_root;
+
+	if (uncore_root->write_blocked)
+		return -EPERM;
 
 	if (cluster_info->root_domain)
 		return -ENODATA;


