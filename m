Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602E2FFF9D;
	Thu,  2 Jul 2026 16:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011305; cv=none; b=dWvnzVUD8s8Na+ZSu6xa/Os41+D2M0htXOX1AntXO/gfkaW5Tq9qtG3/EMDWlDvcp6dIA86gR2JYWsw/g+cSAEihIj9ae92kwUxBycjbAXIwrLK3Wn2jLVBiBrgKbdxX5CUzHuODORSeu6F/XPWFpK2TMP9XvZ0uGdWJU8MKjQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011305; c=relaxed/simple;
	bh=CKaOLxmGry6/8ww9e0OHu4AcKaoGQSahGbjDlypiu1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpnOJqRrHi+LWPbMabMPqV7HqZLFbsBiUAkflDr2ev0ozqkJueWVoA2k/nnaHSkJ3wTueSbZXlRoAtc/q1W59nxH0xxct5y6o50NOlgyNTvsEE7TSPKUzFsJd6wBKgkyTuihhvoNO0W4U3iTG9hUwEHfOEj6m3zWsnBHYz/mUBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1ANv15j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1ANv15j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1F61F000E9;
	Thu,  2 Jul 2026 16:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011304;
	bh=+1/YvLUOcWclwEomvnse5j+hpd2yZgH04d0NO9GlLhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1ANv15jrmpZ//YaMLnU9YvtsbtZGqmVDmrLGZfmL6WQFsoGzOmEENuvoT85/+bb9
	 IMUUZWXQWLFJUC5YVGqJEnhRSJjpGvZMNQKVG10wYV+Z0JSW/Ld7x4m/4rXiniv38r
	 SwxnKBzTeNhpAMtpZMU6k0p3s2SsJspwPpfI5oK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.18 059/108] wifi: iwlwifi: mld: validate sta_mask before ffs() in BA session handlers
Date: Thu,  2 Jul 2026 18:20:56 +0200
Message-ID: <20260702155113.330418707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit f056fc2b927448d37eca6b6cacc3d1b0f67b20d2 upstream.

Three BA session handlers use ffs(ba_data->sta_mask) - 1 to derive a
station ID without checking that sta_mask is non-zero. When sta_mask is
zero, ffs() returns 0 and the subtraction wraps to 0xFFFFFFFF, causing
an out-of-bounds access on fw_id_to_link_sta[].

Add WARN_ON_ONCE(!ba_data->sta_mask) guards before each ffs() call,
consistent with the existing check in iwl_mld_ampdu_rx_start().

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB788115C6CE873271A9A15A25AF51A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/agg.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -64,6 +64,9 @@ static void iwl_mld_release_frames_from_
 	}
 
 	/* pick any STA ID to find the pointer */
+	if (WARN_ON_ONCE(!ba_data->sta_mask))
+		goto out_unlock;
+
 	sta_id = ffs(ba_data->sta_mask) - 1;
 	link_sta = rcu_dereference(mld->fw_id_to_link_sta[sta_id]);
 	if (WARN_ON_ONCE(IS_ERR_OR_NULL(link_sta) || !link_sta->sta))
@@ -166,6 +169,9 @@ void iwl_mld_del_ba(struct iwl_mld *mld,
 		goto out_unlock;
 
 	/* pick any STA ID to find the pointer */
+	if (WARN_ON_ONCE(!ba_data->sta_mask))
+		goto out_unlock;
+
 	sta_id = ffs(ba_data->sta_mask) - 1;
 	link_sta = rcu_dereference(mld->fw_id_to_link_sta[sta_id]);
 	if (WARN_ON_ONCE(IS_ERR_OR_NULL(link_sta) || !link_sta->sta))
@@ -347,6 +353,9 @@ static void iwl_mld_rx_agg_session_expir
 	}
 
 	/* timer expired, pick any STA ID to find the pointer */
+	if (WARN_ON_ONCE(!ba_data->sta_mask))
+		goto unlock;
+
 	sta_id = ffs(ba_data->sta_mask) - 1;
 	link_sta = rcu_dereference(ba_data->mld->fw_id_to_link_sta[sta_id]);
 


