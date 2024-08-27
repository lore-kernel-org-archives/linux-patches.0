Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FF31C57AF;
	Tue, 27 Aug 2024 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770228; cv=none; b=WGTuhU1etqm8bY/Icwcbxdq4M/xPtkREY8Mg4gXM6+5OlcPmB28rNcRcYaUQ0G6wPSsGGVedE31YmBXuwyEgGSoHmJEk/cfGCXalqq9gRwMPaZFJZiUPhFcjpQPRl9uUZOKad8GDLm7h0i9gZ2uBN76WMi8cx/gcnJPZ4Etu7N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770228; c=relaxed/simple;
	bh=A2HQ5j+f6j5Yq/RSHRCnynG+GOOZnvtUrrPpcLgkVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUn+5hkT+3xDCvVxBsp+FNSngk5rMdYo0e/jodQ3vfaYCp5n8F1HVAi+H35MkXhRIavvsplaNuYHVoW/HJNsdWakuSl0bBPkowjco+JG2KJIvL2LL6QSWZGX+RLBZkdPOhlJcsSk3gD44kd2In9j9OzquKvPpctJbx8ttffoREQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojAkgUaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojAkgUaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3AEC4DDF8;
	Tue, 27 Aug 2024 14:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770228;
	bh=A2HQ5j+f6j5Yq/RSHRCnynG+GOOZnvtUrrPpcLgkVR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojAkgUaIGhD9+siGgRN9sjndnlVOGUEBw3+L0vVaziLu/DencP3QtmKz0lPeaTFyT
	 rQFMkub8i8uYlD27CZJzn5wR9I0JCK5AAhFosFfy8kUWxx2JzH8lgIHpfeRlAbvQ69
	 lqrCZJnhzHnR6sOm+1yQNgwCg1K7WfGKpelllwe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaul Triebitz <shaul.triebitz@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/341] wifi: iwlwifi: mvm: avoid garbage iPN
Date: Tue, 27 Aug 2024 16:36:37 +0200
Message-ID: <20240827143849.728538211@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit 0c1c91604f3e3fc41f4d77dcfc3753860a9a32c9 ]

After waking from D3, we set the iPN given by the firmware.
For some reason, CIPHER_SUITE_AES_CMAC was missed.
That caused copying garbage to the iPN - causing false replays.

(since 'seq' is on the stack, and the iPN from the firmware
was not copied into it, it contains garbage which later is
copied to the iPN key).

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240205211151.2be5b35be30f.I99db8700d01092d22a6d76f1fc1bd5916c9df784@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9c89f0dd69c86..08d1fab7f53c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1849,9 +1849,12 @@ iwl_mvm_d3_set_igtk_bigtk_ipn(const struct iwl_multicast_key_data *key,
 		memcpy(seq->aes_gmac.pn, key->ipn, sizeof(seq->aes_gmac.pn));
 		break;
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
 		BUILD_BUG_ON(sizeof(seq->aes_cmac.pn) != sizeof(key->ipn));
 		memcpy(seq->aes_cmac.pn, key->ipn, sizeof(seq->aes_cmac.pn));
 		break;
+	default:
+		WARN_ON(1);
 	}
 }
 
-- 
2.43.0



