Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127AD1C860D;
	Wed,  5 Mar 2025 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197760; cv=none; b=ZW+fP9cietidIIzw65s9zI2wDtGkaju5wnBqCht7lfBmWi9uqcizdY3rZKyOALBSvGTbmTsze+u2NjBA+LjjzgV86DP/i05UtaTb0XxPPMtLb2tHmb1YAELFfeajvqJPtJSpbos7kfDgc4P/yhl8ZyBjELek8J3J/i96wgdCPOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197760; c=relaxed/simple;
	bh=Qml3oEwIK0G29Ux9VxhTZ9mTijCKtB1UMh9eFJns+rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyRxmc2pDMVEcVXiEKb3kWd4Ujjy3en/bA6v6XPOf0v0Mfo1SgjbO/d4pROZZDfWktAoWZCVHypC+lIPui5+h7/iTs7IH6nm1yztTBZ4OZBqWIYX8qzx6TqzyBNU7nWvBqWdWGSlS/PZ++iKNeAfh6AzaUdEgcuYj4cbQiQ9nAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZuTZSay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZuTZSay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C095C4CED1;
	Wed,  5 Mar 2025 18:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197759;
	bh=Qml3oEwIK0G29Ux9VxhTZ9mTijCKtB1UMh9eFJns+rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZuTZSaynMuLzfWAYJXOmYKdEWlNPTetmpf6CSxXsTzannaDmGp2BPSA2tS1KaM5B
	 qXecRPPLstoQrCodnR/je/wrZzRu++cgGRiFQPc6Xgdnp0RriLWoCUe3GvKz9pKerE
	 Gu/faPT6Pl8+GguLnUA/BR7zT3AOA8kqNmQI6scA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>
Subject: [PATCH 6.6 090/142] Revert "rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads"
Date: Wed,  5 Mar 2025 18:48:29 +0100
Message-ID: <20250305174503.949854077@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomas Glozar <tglozar@redhat.com>

This reverts commit 83b74901bdc9b58739193b8ee6989254391b6ba7.

The commit breaks rtla build, since params->kernel_workload is not
present on 6.6-stable.

Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -900,15 +900,12 @@ timerlat_hist_apply_config(struct osnois
 		auto_house_keeping(&params->monitored_cpus);
 	}
 
-	/*
-	* Set workload according to type of thread if the kernel supports it.
-	* On kernels without support, user threads will have already failed
-	* on missing timerlat_fd, and kernel threads do not need it.
-	*/
-	retval = osnoise_set_workload(tool->context, params->kernel_workload);
-	if (retval < -1) {
-		err_msg("Failed to set OSNOISE_WORKLOAD option\n");
-		goto out_err;
+	if (params->user_hist) {
+		retval = osnoise_set_workload(tool->context, 0);
+		if (retval) {
+			err_msg("Failed to set OSNOISE_WORKLOAD option\n");
+			goto out_err;
+		}
 	}
 
 	return 0;


