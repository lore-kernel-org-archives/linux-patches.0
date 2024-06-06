Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36371974F2;
	Thu,  6 Jun 2024 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683091; cv=none; b=JwtSaa2/IvqBasUSv5Gt+aTYcmy3r8JUHBJUQQiI7vmOa8ziKDq+hnS+knpjSRQkRFTYWvtVmI2tWVqxd6M3R5DPsAgArc5i8BiWH67SCqRTuNxcq2w/lDE2WWOccdki7/zzaHK25q+E/Uqv5i+Gyu8cbWeR9exjBDPioFjEnrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683091; c=relaxed/simple;
	bh=SKshPOtNns6GVJEF6xYfdb+XqwyhHXkJVWVM24dekAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpJANjPUCeZD0l6ny9Ym71Uj1j2PJZZRVC4Y26zmJ4ZO7IQrpcgwZyQqs1jtA9I7T4QurwetHEAgiGnctrHRk81augUCZvB6SDY9fUsriJhrqVcgbobbso965vZt7drNgeHlIE4KwKY9aA1ObFZsny29jhZmQHnNddFp8VsmXf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O85Dd2zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O85Dd2zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14B5C32781;
	Thu,  6 Jun 2024 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683090;
	bh=SKshPOtNns6GVJEF6xYfdb+XqwyhHXkJVWVM24dekAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O85Dd2zwJ0AWFQqIxscyD+kVwUWwyBVIoFRB2gquGZtc2hqS8lUX+zayEZV1I8A1/
	 TIa/+XLSB1xbOUw1CoQdG1BsihKzYSAR6d3018aryEqKlBJnbRg3vfHOLrJvJ8tQKa
	 kR3Ek0e02qDLmzDweqVgkkO/ASXQfA40bg4iEbgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.9 374/374] platform/x86/intel-uncore-freq: Dont present root domain on error
Date: Thu,  6 Jun 2024 16:05:53 +0200
Message-ID: <20240606131704.417598756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -240,6 +240,7 @@ static int uncore_probe(struct auxiliary
 	bool read_blocked = 0, write_blocked = 0;
 	struct intel_tpmi_plat_info *plat_info;
 	struct tpmi_uncore_struct *tpmi_uncore;
+	bool uncore_sysfs_added = false;
 	int ret, i, pkg = 0;
 	int num_resources;
 
@@ -384,9 +385,15 @@ static int uncore_probe(struct auxiliary
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


