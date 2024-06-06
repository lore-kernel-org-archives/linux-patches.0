Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0F1A254F;
	Thu,  6 Jun 2024 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683767; cv=none; b=aGfIP3XVLdlPvJudZ23NcK+Oi6Y4Wi1sWgZ70xe9OES4zYnoSz+wMZC1zkrzvdSgoW+mpXvs11qGInT6dhxLUVUKkSRdKGj+bw/w9mqHXoQtGEGUXqInPteHohJ/uJxkErvSipoJ8X0DikMwhiWHWma7PXfXzxBV3HQ/tMN9Cho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683767; c=relaxed/simple;
	bh=sI/ffrj9UIFzdeacXAdfFyEWEpW2TlqyjrxOfKc8t1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX/kGYQSqDEFnjhsjZvjkY6Va6N2rge3VhcRNv/8SJrwMdpkF4wOTfavWd4ykC+G45FSPDNMFDRvyI2CSWNekw1AMD+Vr2b7digSqbMW8MYHUaKvM8F3NYBEiyhz9EBfZ+ee0Hexv7Pk/9tq+CENnVS8/1IK3w6QMdX5opb6aw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5kFZhMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5kFZhMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB05EC2BD10;
	Thu,  6 Jun 2024 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683766;
	bh=sI/ffrj9UIFzdeacXAdfFyEWEpW2TlqyjrxOfKc8t1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5kFZhMR0fK7zf4IgVeFQyQHzKfu1FPR7RB0DhcRkejUHfClKCUprFAFp3qS1avpA
	 SoYrzQPcSsm8G2o/yOdoqAerRJTy7SVOH6U4k2HyktncPdNLWzBeWxWav3VPGZG6Pr
	 5SnlM+XaP8l8wWE/jqZ/xFxhrf1pzLKLKkHEsAhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 744/744] platform/x86/intel-uncore-freq: Dont present root domain on error
Date: Thu,  6 Jun 2024 16:06:56 +0200
Message-ID: <20240606131756.337159958@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit db643cb7ebe524d17b4b13583dda03485d4a1bc0 upstream.

If none of the clusters are added because of some error, fail to load
driver without presenting root domain. In this case root domain will
present invalid data.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 01c10f88c9b7 ("platform/x86/intel-uncore-freq: tpmi: Provide cluster level control")
Cc: <stable@vger.kernel.org> # 6.5+
Link: https://lore.kernel.org/r/20240415215210.2824868-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -234,6 +234,7 @@ static int uncore_probe(struct auxiliary
 {
 	struct intel_tpmi_plat_info *plat_info;
 	struct tpmi_uncore_struct *tpmi_uncore;
+	bool uncore_sysfs_added = false;
 	int ret, i, pkg = 0;
 	int num_resources;
 
@@ -359,9 +360,15 @@ static int uncore_probe(struct auxiliary
 			}
 			/* Point to next cluster offset */
 			cluster_offset >>= UNCORE_MAX_CLUSTER_PER_DOMAIN;
+			uncore_sysfs_added = true;
 		}
 	}
 
+	if (!uncore_sysfs_added) {
+		ret = -ENODEV;
+		goto remove_clusters;
+	}
+
 	auxiliary_set_drvdata(auxdev, tpmi_uncore);
 
 	tpmi_uncore->root_cluster.root_domain = true;


