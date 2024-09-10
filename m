Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DFE18CC17;
	Tue, 10 Sep 2024 09:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961279; cv=none; b=KseTXY7m2hy3K8fBG611MvNkWdULg+RfkVd5EsfNrxWrIpOEHefCXYBl9Gl4k1/Ipylp/noglGSusvThIvlsSsu3GvRFTEtdvEGw3hEiyi6gXlwwPNOxrif61QAyDXmOK4n1C7+R+5e0+7Gr35yBJ77mRWhnEZZAl0SZtPYYvHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961279; c=relaxed/simple;
	bh=uKqTaFvaeQ2oVb/uoYcKbEzlz4+Kd1xUGupgpTqPNjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4KkZHMHXC/6thDv4gNyIZ5ULMVlISzAAXi0NWaiVToOK8hTC3cYrRyHbnhrQdQyLqn40b6fTQPCKKvkR/Zk9su1yYGNc/o6yBJ8smuGgaek9NvdhfmanfCJei6a8KMq/RqTHRzfgV28v22y7gJe2QlJm8BCb0o4R4cXIoQBAqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5/ZsHYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5/ZsHYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC020C4CEC6;
	Tue, 10 Sep 2024 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961279;
	bh=uKqTaFvaeQ2oVb/uoYcKbEzlz4+Kd1xUGupgpTqPNjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5/ZsHYVxPepQ0ySthQOHzkuaWT+y3gsGaN16XM8yRUorkP5V+jwoAnl1ozXtA9KB
	 6pBPSIgqC5Co5sTEfdT7SDhcQlXZxS2K2TSz5UrG+E6S1VcDJnFHzCQ2MxtQp/lwDP
	 mmpkbGez9aGSVFXzYU/RGLL3XMuUKvdq61dKbxis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	robelin <robelin@nvidia.com>,
	Sameer Pujar <spujar@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 007/375] ASoC: dapm: Fix UAF for snd_soc_pcm_runtime object
Date: Tue, 10 Sep 2024 11:26:44 +0200
Message-ID: <20240910092622.507167145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: robelin <robelin@nvidia.com>

commit b4a90b543d9f62d3ac34ec1ab97fc5334b048565 upstream.

When using kernel with the following extra config,

  - CONFIG_KASAN=y
  - CONFIG_KASAN_GENERIC=y
  - CONFIG_KASAN_INLINE=y
  - CONFIG_KASAN_VMALLOC=y
  - CONFIG_FRAME_WARN=4096

kernel detects that snd_pcm_suspend_all() access a freed
'snd_soc_pcm_runtime' object when the system is suspended, which
leads to a use-after-free bug:

[   52.047746] BUG: KASAN: use-after-free in snd_pcm_suspend_all+0x1a8/0x270
[   52.047765] Read of size 1 at addr ffff0000b9434d50 by task systemd-sleep/2330

[   52.047785] Call trace:
[   52.047787]  dump_backtrace+0x0/0x3c0
[   52.047794]  show_stack+0x34/0x50
[   52.047797]  dump_stack_lvl+0x68/0x8c
[   52.047802]  print_address_description.constprop.0+0x74/0x2c0
[   52.047809]  kasan_report+0x210/0x230
[   52.047815]  __asan_report_load1_noabort+0x3c/0x50
[   52.047820]  snd_pcm_suspend_all+0x1a8/0x270
[   52.047824]  snd_soc_suspend+0x19c/0x4e0

The snd_pcm_sync_stop() has a NULL check on 'substream->runtime' before
making any access. So we need to always set 'substream->runtime' to NULL
everytime we kfree() it.

Fixes: a72706ed8208 ("ASoC: codec2codec: remove ephemeral variables")
Signed-off-by: robelin <robelin@nvidia.com>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://patch.msgid.link/20240823144342.4123814-2-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-dapm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -4066,6 +4066,7 @@ static int snd_soc_dai_link_event(struct
 
 	case SND_SOC_DAPM_POST_PMD:
 		kfree(substream->runtime);
+		substream->runtime = NULL;
 		break;
 
 	default:


