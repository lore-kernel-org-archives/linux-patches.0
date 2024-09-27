Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B476118C033;
	Fri, 27 Sep 2024 12:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440228; cv=none; b=QQOPtUdeTRRKva/2PpUYNkvmqewpg8CYPRDlwv19dnHU8daRcJWV0HKWNrl+hJt/iwtR6uR4kg8ABObR4QAoZSyhlIa8gNeOVn+NA5M4yNjB32TA9YgKMXpIMcj8VLspnVkpXw8mXt2CpfEBlJz2PUQU/CyRS50VcQ6Co9PcNfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440228; c=relaxed/simple;
	bh=vpXi8Cdj6LtnwCahvZNDOHatOAxBtYpm28TzE7VnIMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8TVnZgfwLYPWxgF5BObCmuwvogtTj1SqPXICOyBrr3nEV6lyR8CiCVTb/VjrJnP3NO5MpJIqfalXwJg7d/jFHfwbWdNcQdVDAuH+u+LgzxpFtamDzSQA/09hOMTH0qZyZnvoXu6y1layCsffzHD2Jg2Ta+aXNxzwxuCZ7XTf+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/LZ9DLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/LZ9DLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DF9C4CECF;
	Fri, 27 Sep 2024 12:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440228;
	bh=vpXi8Cdj6LtnwCahvZNDOHatOAxBtYpm28TzE7VnIMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/LZ9DLIDvtbPe9LjBKCLvPOS44rTSWOMvVP/6Rlfidylpfb3n0gYJ4YBYv/nuCUU
	 al8ld0Bs+/A/RPF9bfmt4NIBYfu6iedxZyurFOZJn00C9uPqW7L9FUF2uU5TvhREpO
	 q0fJmvDqL8V1UVSqIDp79h5u9UV9nJHXZCQIGp1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.11 09/12] ASoC: amd: acp: add ZSC control register programming sequence
Date: Fri, 27 Sep 2024 14:24:12 +0200
Message-ID: <20240927121715.645693156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

commit c35fad6f7e0d69b0e9e7e196bdbca3ed03ac24ea upstream.

Add ZSC Control register programming sequence for ACP D0 and D3 state
transitions for ACP7.0 onwards. This will allow ACP to enter low power
state when ACP enters D3 state. When ACP enters D0 State, ZSC control
should be disabled.

Tested-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20240807085154.1987681-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/acp/acp-legacy-common.c |    5 +++++
 sound/soc/amd/acp/amd.h               |    2 ++
 2 files changed, 7 insertions(+)

--- a/sound/soc/amd/acp/acp-legacy-common.c
+++ b/sound/soc/amd/acp/acp-legacy-common.c
@@ -321,6 +321,8 @@ int acp_init(struct acp_chip_info *chip)
 		pr_err("ACP reset failed\n");
 		return ret;
 	}
+	if (chip->acp_rev >= ACP70_DEV)
+		writel(0, chip->base + ACP_ZSC_DSP_CTRL);
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(acp_init, SND_SOC_ACP_COMMON);
@@ -336,6 +338,9 @@ int acp_deinit(struct acp_chip_info *chi
 
 	if (chip->acp_rev != ACP70_DEV)
 		writel(0, chip->base + ACP_CONTROL);
+
+	if (chip->acp_rev >= ACP70_DEV)
+		writel(0x01, chip->base + ACP_ZSC_DSP_CTRL);
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(acp_deinit, SND_SOC_ACP_COMMON);
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -103,6 +103,8 @@
 #define ACP70_PGFSM_CONTROL			ACP6X_PGFSM_CONTROL
 #define ACP70_PGFSM_STATUS			ACP6X_PGFSM_STATUS
 
+#define ACP_ZSC_DSP_CTRL			0x0001014
+#define ACP_ZSC_STS				0x0001018
 #define ACP_SOFT_RST_DONE_MASK	0x00010001
 
 #define ACP_PGFSM_CNTL_POWER_ON_MASK            0xffffffff


